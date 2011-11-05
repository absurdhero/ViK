require 'test/unit'

require 'buffer_editor'
require 'text_buffer'

class MockEditorObserver
    attr_reader :messages

    def initialize
        @messages = []
    end

    def update(*args)
        @messages << args
    end

    def message
        @messages.last
    end
end

class BufferEditorTests < Test::Unit::TestCase
    def setup
        @editor = BufferEditor.new_empty
        @observer = MockEditorObserver.new
        @editor.add_observer(@observer)
    end
    
    def test_notified_when_buffer_changed
        @editor.set_buffer(TextBuffer.new)
        assert_equal [:change, nil], @observer.message
    end

    def test_write_to_buffer_when_inserting
        buffer = TextBuffer.new
        editor = BufferEditor.new(buffer)
        editor.insert('foo')
        assert_equal 'foo', buffer.read_line(0)
    end

    def test_notified_of_line_when_inserting_into_buffer
        @editor.insert('foo')
        assert_equal [:change, LineRange.at(0)], @observer.message
    end

    def test_notified_when_cursor_moves
        @editor.insert('test')
        @editor.set_column_bounded(1)
        assert_equal [:movement], @observer.message
    end
end

class LineRangeTests < Test::Unit::TestCase
    def test_list_equals_range_when_comparing_line_ranges
        assert_equal LineRange.new([1,2,3,4,5]), LineRange.range(1,5)
    end
end
