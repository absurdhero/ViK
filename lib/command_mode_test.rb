require 'test/unit'

require 'buffer_editor'
require 'modes'

class FakeEditState
    def insert_mode; end
    def line_mode; end
end

class CommandModeTests < Test::Unit::TestCase
    def setup
        @edit_state =  FakeEditState.new
        @editor = BufferEditor.new_empty
        @command = CommandMode.new(@edit_state, @editor)
    end
    def test_column_changed_when_move_cursor_horizontally
        @editor.insert('foo')
        assert_equal 3, @editor.col
        @command.move_cursor_left
        @command.move_cursor_left
        assert_equal 1, @editor.col
        @command.move_cursor_right(2)
        assert_equal 3, @editor.col
    end

    def test_column_unchanged_when_moving_left_past_start
        @command.move_cursor_left(9)
        assert_equal 0, @editor.col
        @editor.insert('foo')
        @command.move_cursor_left(3)
        assert_equal 0, @editor.col
        @command.move_cursor_left
        assert_equal 0, @editor.col
    end

    def test_line_unchanged_when_moving_above_first_line
        @command.move_cursor_up_line
        assert_equal 0, @editor.line
    end
end
