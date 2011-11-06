require 'curses'

require 'screen'
require 'keycodes'

class CursesScreen < Screen
    def initialize
        Curses.noecho
        Curses.init_screen
        Curses.stdscr.keypad(true)
        @width = Curses.cols
        @height = Curses.lines - 1 # Save a line for the status bar
        @status_bar = CursesStatusBar.new(Curses.cols, Curses.lines)
        set_cursor(0, 0)
    end

    def finalize
        Curses.close_screen
    end

    def refresh
        if Curses.cols != @width or Curses.lines != @height
            resize
        end
        Curses.refresh
    end

    def write(text)
        update_position
        Curses.addstr(text)
        @col += text.length
    end


    def set_cursor(line, col)
        @line = line
        @col = col
        Curses.setpos(line, col)
    end

    def get_key
        ch = Curses.getch 
        return CursesKeyCodes.map(ch)
    end

    private

    def update_position
        Curses.setpos(@line, @col)
    end

    def resize
        @width = Curses.cols
        @height = Curses.lines
        # XXX Do something about out-of-bounds cursor position
        @status_bar.resize(@width, @height)
    end

end

class CursesStatusBar < StatusBar
    def initialize(width, height)
        @left_text = ''
        @right_text = ''
        resize(width, height)
    end

    def resize(width, height)
        @width = width
        @height = height
    end

    def draw
        # Clear line
        Curses.setpos(@height - 1, 0)
        Curses.clrtoeol 
        # Draw right side and then left side which may write over it
        Curses.setpos(@height - 1, @width - @right_text.length)
        Curses.addstr(@right_text)
        Curses.setpos(@height - 1, 0)
        Curses.addstr(@left_text + ' ')
        Curses.setpos(@height - 1, @left_text.length)
    end

    def right(text)
        @right_text = text
        draw
    end

    def left(text)
        @left_text = text
        draw
    end
end

class CursesKeyCodes
    MAP = {
        Curses::Key::UP => '<Up>',
        Curses::Key::DOWN => '<Down>',
        Curses::Key::LEFT => '<Left>',
        Curses::Key::RIGHT => '<Right>',
        Curses::Key::SLEFT => '<S-Left>',
        Curses::Key::SRIGHT => '<S-Right>',
    }

    def self.map(value)
        if value < 32
            return "^#{(64+value).chr}"
        elsif MAP.key?(value)
            return MAP[value]
        elsif KeyCodes::VI_CHAR_MAP.key?(value)
            return KeyCodes::VI_CHAR_MAP[value]
        else
            return value.chr
        end
    end
end
