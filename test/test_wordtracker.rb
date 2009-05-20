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
    assert_equal({ "cats" => 999, "kittens" => 999 },
      @w.get_lateral_keyphrases(:keyphrases => ["cats", "kittens"]))
  end

  def test_get_all_words_popularity
    assert_equal({ "cats" => 999, "kittens" => 999 },
      @w.get_all_words_popularity(:keyphrases => ["cats", "kittens"]))
  end

  def test_query_version
    assert_equal({ "api_version" => "9.99", "build_number" => 999 },
      @w.query_version)
  end

  def test_query_permissions
    assert_equal({"get_all_words_popularity"=>{"cost_per_call"=>99, "timeout_limit"=>99, "keyphrase_limit"=>999, "result_limit"=>999}}, 
      @w.query_permissions)
  end

  def test_query_balance
     assert_equal(123.45, @w.query_balance)
  end

  def test_get_total_searches
    assert_equal(999999, @w.get_total_searches)
  end

  def test_get_plurals
    assert_equal({ "cat" => ["cat"], "kitten" => ["kitten"] }, 
      @w.get_plurals(["cat", "kitten"]))
  end
end
