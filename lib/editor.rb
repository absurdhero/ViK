require 'modes'

class Editor
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
    end
end
