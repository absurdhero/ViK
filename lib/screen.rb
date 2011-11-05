class Screen
    attr_reader :status_bar, :input
    attr_reader :width, :height
    attr_reader :line, :col

    def refresh; end
    def write(text); end
    def move_cursor(lines, cols); end
    def get_key; end

    def move_cursor(lines, cols)
        newline = @line + lines
        newcol = @col + cols
        if newline > @height or newline < 0
            raise Exception, "Line outside of window (#{newline} of #{@line} lines)"
        end
        if newcol > @width or newcol < 0
            raise Exception, "Column outside of window"
        end
        set_cursor(newline, newcol)
    end 
end

class NilScreen < Screen
    attr :width, :height

    def initialize
        @width = 80
        @height = 24
        set_cursor(0, 0)
        @status_bar = StatusBar.new
    end

    def set_cursor(line, col)
        @line = line
        @col = col
    end

    def write(text)
        @col += text.length
    end
end

class CursesScreen < Screen
    def initialize
        require 'curses'
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
        # XXX Translate into keyboard keycodes
        # XXX Write a function to turn those into vi key names
        keys = {10 => '^M', 27 => '^[', 258 => '<Down>', 259 => '<Up>', 260 => '<Left>', 261 => '<Right>'}
        return keys.fetch(ch, ch.chr)
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

class StatusBar
    def right(text); end
    def left(text); end
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

