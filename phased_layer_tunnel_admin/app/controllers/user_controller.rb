class UserController < ApplicationController
  caches_action :list
  def users_perspective
    render :json => User.users_and_groups_map
  end

  def list
    render :json => User.all.map { |i| {:email => i.email } }.to_json
  end

  def new
    expire_action :action => :list
    res = {:results => false, :errors => []}
    params[:email] ||= 0
    begin
      u = User.new
      u.email = params[:email]
      u.enc_save
      if u.errors.empty?
        res[:results] = true
      else
        res[:errors] << u.errors.first
      end
    rescue => e
      res[:errors] << "#{e.inspect}"
    end

    render :json => res.to_json
  end

  def add_to_group
    res = {:results => false, :errors => []}
    if params.has_key?(:group)
      begin
        params[:group_id] = Group.find(:first, :conditions => {:name => params[:group]}).id
      rescue => e
        res[:errors] << "#{e.inspect}"
      end
    end

    if params.has_key?(:user)
      begin
        params[:user_id] = User.find(:first, :conditions => {:email => params[:user]}).id
      rescue => e
        res[:errors] << "#{e.inspect}"
      end
    end

    params[:user_id] ||= 0
    params[:group_id] ||= 0
    begin
      ug = UserGroup.new
      tmp = {:user_id => params[:user_id], :group_id => params[:group_id]}
      tmp.each_pair { |k, v|
        eval("ug.#{k}=#{v}")
        #ug.send(k, v)
      }
      if ug.save
        res[:results] = true
        expire_action :action => :list
      else
        res[:errors] = ug.errors
      end
    rescue => e
      res[:errors] << "#{e.inspect}"
    end
    render :json => res.to_json
  end

  def del_from_group
    params[:email] ||= 0
    params[:group] ||= 0
    res = {:results => false, :errors => []}
    begin
      user_id = User.find(:first, :conditions =>{:email => params[:email]}).id
      group_id = Group.find(:first, :conditions =>{:name => params[:group]}).id
      ug = UserGroup.find(:first, :conditions => 
                          {:user_id => user_id, :group_id => group_id})
      ug.delete
      expire_action :action => :list
      res[:results] = true
    rescue => e
    end
    render :json => res.to_json
  end

  def delete
    res = {:results => false, :errors => []}
    params[:email] ||= 0
    begin
      user = User.delete_by_email(params[:email])
      if user.errors.empty?
        res[:results] = true
        expire_action :action => :list
      else
        res[:errors] << user.errors.first.inspect
      end
    rescue => e
      res[:errors] << e.inspect
    end
    render :json => res.to_json

  end
end
