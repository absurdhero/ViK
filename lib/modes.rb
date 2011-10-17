class QuitSignal < Exception; end

class EditorMode
    def initialize(editor)
        @editor = editor
    end

    def handle_key
    end

    def enter
    end

    def exit
    end
end

class CommandMode < EditorMode
    def initialize(editor, display_buffer)
        @buffer = display_buffer
        super(editor)
    end

    def handle_key(key)
        case key
        when ':'
            @editor.line_mode
        when 'i'
            @editor.insert_mode
        when 'q'
            abort "ended"
        end
    end
end

class InsertMode < EditorMode
    def initialize(editor, display_buffer)
        @buffer = display_buffer
        super(editor)
    end

    def handle_key(key)
        if key == '^['
            @editor.command_mode
        else
            @buffer.insert(key)
        end
    end
end

class LineMode < EditorMode
    def initialize(editor, status_bar)
        @text = ''
        @status_bar = status_bar
        super(editor)
    end
    def handle_key(key)
        if key == '^M'
            interpret(@text)
            @text = ''
            @editor.command_mode
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
