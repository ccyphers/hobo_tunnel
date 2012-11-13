require 'rspec'
base = File.expand_path(File.dirname(__FILE__) + '/../..')
require "#{base}/lib/cache"
require 'redis'
REDIS=Redis.new
describe Cache do
  it "should not allow setting up Cache object withoug a base cache name" do
    lambda do
      Cache.new
    end.should raise_error(ArgumentError)
  end
end

describe Cache do
  before do
    @cache = Cache.new(:cache_name => 'unit_test')
    @items1 = "who uses single ActiveRecord object instances for a cache when speaking about real performance?"
    @items2 = "One should get rid of all expensive operations in an application and cache data structures which may encompas many queries to build."
    @items3 = "should be the last set"
  end

  after do
    @cache.clear_all
  end

  it "should not allow caching if a set of identifiers is not present" do
    lambda do
      @cache.new_cache_set(Time.now, [])
    end.should raise_error(ArgumentError, "ids not provided.  ids must be an array of identifiers for all objects in a set")
  end

  # BSON requires to serialize Hash
  it "should update object to a Hash if in another data structure" do
    time = Time.now.utc
    @cache.new_cache_set(time, [1])
    time_from_cache = @cache.get_by_set_num(1)
    "#{time.should}" == "#{time_from_cache['cache']}"
  end

  it "should inform the user which cache set data is in based on an id" do
    @cache.new_cache_set(@items1 + @items2, [1, 2])
    @cache.new_cache_set(Time.now, [3])
    @cache.new_cache_set(@items3, [4])
    @cache.which_set?(1).should == 1
    @cache.which_set?(2).should == 1
    @cache.which_set?(3).should == 2
    @cache.which_set?(4).should == 3
  end

  it "shoud return data based on an id" do
    @cache.new_cache_set(@items1 + @items2, [1, 2])
    @cache.new_cache_set(Time.now, [3])
    @cache.new_cache_set(@items3, [4])
    @cache.get_by_id(1)['cache'].should == @items1 + @items2
    @cache.get_by_id(2)['cache'].should == @items1 + @items2
  end
end


