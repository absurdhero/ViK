class OutOfBoundsError < Exception; end

class TextBuffer
    def initialize
        @lines = ['']
    end

    def write_line(line, text)
        if line > max_line
            ([0, max_line].max...line).each do |lineno|
                @lines[lineno] = ''
            end
        end
        @lines[line] = text
    end

    def max_line
        return @lines.length - 1
    end

    def write_str(line, col, text)
        if @lines[line].nil?
            if col == 0
                @lines[line] = text
            else
                raise OutOfBoundsError 
            end
        end
        if col > @lines[line].length
            raise OutOfBoundsError
        elsif col == @lines[line].length
            @lines[line] += text
        else
            @lines[line][col, text.length] = text 
        end
    end

    def read_line(line)
        if line > max_line
            raise OutOfBoundsError
        end
        return @lines[line]
    end

    def read_str(line, col, length)
        return @lines[line][col, length]
    end

    def line_length(line)
        if line >= @lines.length
            raise OutOfBoundsError
        end
        return @lines[line].length
    end

    def insert_line(line, text)
        @lines.insert(line, text)
    end

    def delete_line(line)
        @lines.delete_at(line)
    end
end
