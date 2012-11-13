require 'bson'

# Assumptions:
# * for now assume that user has a constant for the Redis object
# * only support objects that can be serialized/deserialized as BSON
#   for faster performance than Marshal
class Cache

  def initialize(params={})
    raise ArgumentError unless params[:cache_name]
    raise ArgumentError if REDIS.keys.include?("#{params[:cache_name]}_0")
    @num_sets = 0
    @set_base=params[:cache_name]
  end

  def new_cache_set(obj=nil, ids=[])
    raise ArgumentError, "No object provided to cache" unless obj
    if ids.empty?
      raise ArgumentError, "ids not provided.  ids must be an array of identifiers for all objects in a set" 
    end

    @num_sets += 1
    ids.each { |id| REDIS.sadd("#{@set_base}_ids_#{@num_sets}", id) }
    obj = {'cache' => obj} unless obj.kind_of?(Hash)
    REDIS.set("#{@set_base}_#{@num_sets}", BSON.serialize(obj))
  end

  def which_set?(id)
    0.upto(@num_sets) { |ct|
      return ct if REDIS.sismember("#{@set_base}_ids_#{ct}", id)
    }
    -1
  end

  def get_by_set_num(num)
    BSON.deserialize(REDIS.get("#{@set_base}_#{num}"))
  end

  def get_by_id(id)
    set_num = which_set?(id)
    if set_num > -1
      return get_by_set_num(which_set?(id))
    end
    {}
  end

  def clear_all
    0.upto(@num_sets) { |ct|
      REDIS.del("#{@set_base}_ids_#{ct}")
      REDIS.del("#{@set_base}_#{ct}")
    }
  end
end
