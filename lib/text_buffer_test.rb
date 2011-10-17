require 'test/unit/ui/console/testrunner'
require 'test/unit'

require 'text_buffer'

class TextBufferTests < Test::Unit::TestCase
    def test_error_when_reading_empty_line
        b = TextBuffer.new
        assert_raise(OutOfBoundsError) { b.read_line(1) }
    end

    def test_fill_in_blanks_when_writing_line_out_of_range
        b = TextBuffer.new
        b.write_line 1, 'test'
        assert_equal '', b.read_line(0)
        assert_equal 'test', b.read_line(1)
    end

    def test_max_line_lower_after_truncation
        b = TextBuffer.new
        b.write_line 2, 'test'
        b.write_line 3, 'testing'
        assert_equal 3, b.max_line

        b.write_line 2, ''
        b.delete_line 3
        assert_equal 2, b.max_line
    end

    def test_text_overwritten_when_replaced_with_write_str
       b = TextBuffer.new
       b.write_line 1, 'foo bar baz'
       b.write_str 1, 4, 'baz'
       assert_equal 'foo baz baz', b.read_line(1)
    end

    def test_append_when_writing_string_at_end_of_line
       b = TextBuffer.new
       b.write_line 0, '0123'
       assert_equal '0123456', b.write_str(0, 4, '456')
    end

    def test_error_when_writing_string_to_middle_of_empty_line
       b = TextBuffer.new
       assert_raise(OutOfBoundsError) { b.write_str(0, 10, 'foo') }
    end

    def test_error_when_writing_string_off_of_line
       b = TextBuffer.new
       b.write_line 0, '0123456789'
       assert_raise(OutOfBoundsError) { b.write_str(0, 11, 'foo') }
    end

    def test_write_string_to_start_of_empty_line
       b = TextBuffer.new
       assert_equal 'foo', b.write_str(0, 0, 'foo')
    end

    def test_read_written_line
        b = TextBuffer.new
        b.write_line 10, 'line 10'
        assert_equal 'line 10', b.read_line(10)

        b.write_line 0, '0'
        assert_equal '0', b.read_line(0)
    end
    
    def test_return_right_chars_when_reading_string
        b = TextBuffer.new
        b.write_line 0, 'one two three'
        assert_equal 'one', b.read_str(0, 0, 3)
        assert_equal 'two', b.read_str(0, 4, 3)
        assert_equal 'three', b.read_str(0, 8, 5)
    end

    def test_line_length
        b = TextBuffer.new
        b.write_line 0, '0123456789'
        assert_equal 10, b.line_length(0)
    end

    def test_line_length_errors_when_out_of_bounds
        b = TextBuffer.new
        assert_raise(OutOfBoundsError) { b.line_length(1) }
    end

    def test_lines_move_when_line_inserted
        b = TextBuffer.new
        b.write_line(0, 'foo')
        b.insert_line(0, 'bar')
        assert_equal 1, b.max_line
        assert_equal 'bar', b.read_line(0)
    end
end

Test::Unit::UI::Console::TestRunner.run(TextBufferTests)

