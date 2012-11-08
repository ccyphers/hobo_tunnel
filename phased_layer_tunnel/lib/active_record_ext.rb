module ARValidObjectID
  def valid_user_id?
    res = false
    begin
      res = User.find(self)
    rescue => e
    end
    res.kind_of?(User)
  end

  def valid_group_id?
    res = false
    begin
      res = Group.find(self)
    rescue => e
    end
    res.kind_of?(Group)
  end


end

class Fixnum
  include ARValidObjectID
end

class String
  include ARValidObjectID
end
