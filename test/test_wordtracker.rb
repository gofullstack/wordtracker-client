require File.dirname(__FILE__) + '/test_helper.rb'

class TestWordtracker < Test::Unit::TestCase

  def setup
    # Create a guest instance on each test
    @w = Wordtracker::Client.new
  end
  
  def teardown
  end

  def test_initialize
    # Creating a new instance with no arguments should work
    assert @w.class == Wordtracker::Client
  end

  def test_ping
    # Call to ping service should return true
    assert @w.ping
  end

  def test_bad_ping
    # Request with invalid key should raise an error
    bad_client = Wordtracker::Client.new("bad")
    assert_raise Wordtracker::FaultException do
      bad_client.ping
    end
  end

  def test_get_lateral_keyphrases
    assert_equal @w.get_lateral_keyphrases(:keyphrases => ["cats", "kittens"]),
      { "cats" => 999, "kittens" => 999 }
  end
end
