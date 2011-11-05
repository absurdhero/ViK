require 'modes'

class Editor
    require 'buffer_editor'
    require 'viewport'

    def initialize(screen, text_buffer)
        @screen = screen
        buffer_editor = BufferEditor.new(text_buffer)
        @viewport = Viewport.new(@screen, buffer_editor)
        @edit_state = EditState.new(buffer_editor, @screen.status_bar)
    end

    def run
        loop do
            key = @screen.get_key
            @screen.status_bar.right(key.to_s)
            begin
                @edit_state.handle_key(key)
            rescue QuitSignal
                break
            end
        end
    end
end

class EditState
    def initialize(buffer_editor, status_bar)
        @command_mode = CommandMode.new(self, buffer_editor)
        @insert_mode = InsertMode.new(self, buffer_editor)
        @line_mode = LineMode.new(self, status_bar)
        @current_mode = @command_mode
    end

    def handle_key(key)
        @current_mode.handle_key(key)
    end

    def command_mode
        switch_mode(@command_mode)
    end

    def insert_mode
        switch_mode(@insert_mode)
    end

    def line_mode
        switch_mode(@line_mode)
    end

    def mode
        @current_mode
    end

    private

    def switch_mode(new_mode)
        @current_mode.exit
        @current_mode = new_mode
        @current_mode.enter
        return @current_mode
    end
end
