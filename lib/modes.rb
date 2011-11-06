class QuitSignal < Exception; end

class EditorMode
    def initialize(edit_state)
        @edit_state = edit_state
    end

    def handle_key
    end

    def enter
    end

    def exit
    end
end

class CommandMode < EditorMode
    def initialize(edit_state, buffer)
        @buffer = buffer
        super(edit_state)
    end

    def handle_key(key)
        case key
        when ':'
            @edit_state.line_mode
        when 'i'
            @edit_state.insert_mode
        when 'h'
            move_cursor_left
        when 'l'
            move_cursor_right
        when 'j'
            move_cursor_down_line
        when 'k'
            move_cursor_up_line
        when 'q'
            abort "ended"
        end
    end

    def move_cursor_left(count=1)
        @buffer.move_column_bounded(-count)
    end

    def move_cursor_right(count=1)
        @buffer.move_column_bounded(count)
    end

    def move_cursor_down_line(count=1)
        @buffer.move_line_bounded(count)
    end

    def move_cursor_up_line(count=1)
        @buffer.move_line_bounded(-count)
    end
end

class InsertMode < EditorMode
    def initialize(edit_state, buffer)
        @buffer = buffer
        super(edit_state)
    end

    def handle_key(key)
        if key == '^['
            @edit_state.command_mode
        else
            @buffer.insert(key)
        end
    end
end

class LineMode < EditorMode
    def initialize(edit_state, status_bar)
        @text = ''
        @status_bar = status_bar
        super(edit_state)
    end
    def handle_key(key)
        if ['^J', '^M'].include?(key)
            interpret(@text)
            @text = ''
            @edit_state.command_mode
        else
            @text << key
            @status_bar.left(':' + @text)
        end
    end

    def enter
        @status_bar.left(':')
    end

    def interpret(text)
        if text == 'q'
            raise QuitSignal
        end
    end
end
