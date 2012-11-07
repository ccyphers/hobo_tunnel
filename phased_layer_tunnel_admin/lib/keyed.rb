module Keyed
  def method_missing(meth)
    self[meth] or self["#{meth}"] or raise StandardError, "Couldn't proxy method to hash key #{meth}"
  end

  def attr_str
    res = ''
    self.each_pair { |attr, value|
      res += " #{attr} = '#{value}'"
    }
    res
  end
end

