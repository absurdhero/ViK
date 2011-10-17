class DisplayBuffer
    def initialize(screen, buffer)
        @screen = screen
        set_buffer(buffer)
    end

    def set_buffer(buffer)
        @buffer = buffer
        @line = 0
        @col = 0
        draw
    end

    def insert(text)
        @buffer.write_str(@line, @col, text)
        @screen.set_cursor(@line, @col)
        @screen.write(text)
        @col += text.length
    end

    def insert_line_below(text='')
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

    private

    def render_line(lineno)
        if lineno > @buffer.max_line
            @screen.write('~')
        elsif
            @screen.write(@buffer.read_line(lineno))
        end
    end
end
