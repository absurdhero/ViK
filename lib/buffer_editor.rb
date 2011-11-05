require 'observer'
require 'text_buffer'

class BufferEditor
    # Keeps track of cursor and selection state in a TextBuffer and exposes
    # buffer operations. It also provides state-change notifications to
    # observers such as ViewPort.

    include Observable

    attr_reader :line, :col

    def initialize(buffer)
        set_buffer(buffer)
    end

    def self.new_empty
        self.new(TextBuffer.new)
    end

    def set_buffer(buffer)
        @buffer = buffer
        @line = 0
        @col = 0
        changed
        notify_observers(:change, nil)
    end

    def insert(text)
        @buffer.write_str(@line, @col, text)
        @col += text.length
        changed
        notify_observers(:change, LineRange.at(@line))
    end

    def set_line_bounded(pos)
        @line = [[0, pos].max, @buffer.max_line].min
        changed
        set_column_bounded(@col) # reposition column to be within line
    end

    def move_line_bounded(count)
        set_line_bounded(@line + count)
    end

    def set_column_bounded(pos)
        @col = [[0, pos].max, @buffer.line_length(@line)].min 
        changed
        notify_observers(:movement)
    end

    def move_column_bounded(count)
        set_column_bounded(@col + count)
    end

    def is_column_on_line_end(col, line=@line)
        return True if col >= @buffer.line_length(line) 
        return False
    end

    def insert_line_below(text='')
    end

    def read_line(line)
        return @buffer.read_line(line)
    end
end

class LineRange
    attr_reader :lines

    # Pass in a range, list of lines, or another enumerator
    def initialize(enumerator)
        @lines = enumerator
    end

    def self.range(first, last)
        self.new(first..last)
    end

    def self.at(line)
        self.new([line])
    end

    def ==(other_range)
        self.lines.to_a == other_range.lines.to_a
    end
end
