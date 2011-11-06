class Screen
    attr_reader :status_bar, :input
    attr_reader :width, :height
    attr_reader :line, :col

    def refresh; end
    def write(text); end
    def set_cursor(lines, cols); end
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

class StatusBar
    def right(text); end
    def left(text); end
end

