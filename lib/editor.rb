require 'modes'

class Editor
    require 'display_buffer'

    def initialize(screen, text_buffer)
        @screen = screen
        @text_buffer = text_buffer
        display_buffer = DisplayBuffer.new(@screen, text_buffer)
        @edit_state = EditState.new(display_buffer, @screen.status_bar)
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
    def initialize(display_buffer, status_bar)
        @command_mode = CommandMode.new(self, display_buffer)
        @insert_mode = InsertMode.new(self, display_buffer)
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
