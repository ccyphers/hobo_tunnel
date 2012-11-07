class GroupController < ApplicationController
  def list
    render :json => Group.all.map { |i| {:name => i.name, :users => i.users.map(&:email) } }.to_json
  end
end
