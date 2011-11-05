require 'rubygems'
require 'mocha'

require 'viewport'
require 'screen'

class ViewportTests < Test::Unit::TestCase
    def setup
        @screen = NilScreen.new
        @editor = BufferEditor.new_empty
        @viewport = Viewport.new(@screen, @editor)
    end

    def test_cursor_moves_when_text_inserted
        @screen.expects(:set_cursor).at_least_once
        @editor.insert('foo')
    end

    def test_redraw_when_whole_buffer_changes
        @viewport.expects(:draw)
        @viewport.update(:change, nil)
    end
end
