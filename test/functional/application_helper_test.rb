require File.dirname(__FILE__) + '/../test_helper'
require File.join('action_view','test_case')

class ApplicationHelperTest < ActionView::TestCase
  
  context "display_date" do
    should "deliver German date format" do
      assert_equal '08.01.2008', display_date(Time.utc(2008,1,8))
    end
  end

  context "display_date_and_time" do
    should "deliver German datetime format" do
      assert_equal '08.01.2008 | 10:13', display_date_and_time(Time.utc(2008,1,8,10,13))
    end
  end
  
  context "display_time" do
    should "deliver German time format" do
      assert_equal '10:13 Uhr', display_time(Time.utc(2008,1,8,10,13))
    end
  end
  
  context "link_to_website" do
    should "return none string on nil" do
      assert_equal '<em>none</em>', link_to_website(nil)
    end
    should "return none string on empty website" do
      assert_equal '<em>none</em>', link_to_website('')
    end
    should "provide a http link for urls with protocol" do
      assert_equal '<a href="http://mt7.de">mt7.de</a>', link_to_website('http://mt7.de')
    end
    should "provide a http link for urls without protocol" do
      assert_equal '<a href="http://mt7.de">mt7.de</a>', link_to_website('mt7.de')
    end
  end
  
end
