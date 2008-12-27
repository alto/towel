require File.dirname(__FILE__) + '/../test_helper'

class ArrayTest < ActiveSupport::TestCase
  context "windowing" do
    should "deliver window_around_index" do
      mine = [0,1,2,3,4,5,6,7,8,9]
      assert_equal [0], mine.window_around_index(0,0)
      assert_equal [0,1], mine.window_around_index(0,1)
      assert_equal [9], mine.window_around_index(9,0)
      assert_equal [8,9], mine.window_around_index(9,1)
      assert_equal [2,3,4,5,6], mine.window_around_index(4,2)
    end
    should "deliver window_around_element" do
      mine = ['0','1','2','3','4','5','6','7','8','9']
      assert_equal ['0'], mine.window_around_element('0',0)
      assert_equal ['0','1'], mine.window_around_element('0',1)
      assert_equal ['9'], mine.window_around_element('9',0)
      assert_equal ['8','9'], mine.window_around_element('9',1)
      assert_equal ['2','3','4','5','6'], mine.window_around_element('4',2)
    end
  end
end
