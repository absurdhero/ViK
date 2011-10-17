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

    def move_cursor_left(count)
        move_column_bounded(-count)
    end

    def move_cursor_right(count)
        move_column_bounded(count)
    end

    def move_cursor_down_line(count)
        move_line_bounded(count)
    end

    def move_cursor_up_line(count)
        move_line_bounded(-count)
    end

    private

    def render_line(lineno)
        if lineno > @buffer.max_line
            @screen.write('~')
        elsif
            @screen.write(@buffer.read_line(lineno))
        end
    end

    def move_column_bounded(count)
        pos = [[0, @col + count].max, @buffer.line_length(@line)-1].min
        @col = pos
        @screen.set_cursor(@line, @col)
    end 

    def move_line_bounded(count)
        pos = [[0, @line + count].max, @buffer.max_line].min
        @line = pos
        @screen.set_cursor(@line, @col)
    end
end
