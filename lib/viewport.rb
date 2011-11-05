require 'buffer_editor'

class Viewport
    def initialize(screen, editor)
        @screen = screen
        @editor = editor
        @editor.add_observer(self)
    end

    def draw
        @screen.set_cursor(1, 0) 
        (1...@screen.height-1).each do |lineno|
            render_line(lineno)
            @screen.move_cursor(1, -@screen.col)
        end
        render_line(@screen.height-1)
        @screen.set_cursor(0, 0)
    end

    def update(message, *args)
        case message
            when :change
                range = args[0]
                if range.nil?
                    draw
                    set_cursor_pos
                else
                    redraw_lines(range)
                end
            when :movement
                set_cursor_pos
        end
    end

    private

    def render_line(lineno)
        if lineno > @buffer.max_line
            @screen.write('~')
        elsif
            @screen.write(@editor.read_line(lineno))
        end
    end

    def redraw_lines(line_range)
       line_range.lines.each do |lineno|
           @screen.set_cursor(lineno, 0)
           @screen.write(@editor.read_line(lineno))
       end
       set_cursor_pos
    end

    def set_cursor_pos
        @screen.set_cursor(@editor.line, @editor.col)
    end
end
