require File.dirname(__FILE__) + '/spec_helper'

class SecuredModel < ActiveRecord::Base
end
class SecuredController < ActionController::Base
end

describe ActiveSecurity::Role do
  
  before(:all) do
    @role = ActiveSecurity::Role.define(:role_name) do |role_set|
      role_set.permit_action(SecuredController, :update)
      role_set.permit_model(SecuredModel, :new)
    end
  end
  
  it "should humanize the name in to_s" do
    "#{@role}".should == "Role Name"
  end
  
  it "should be able to tell you if it has an equivilant permission" do
    @role.has_permission?(ActiveSecurity::ModelPermission.new(SecuredModel, :new)).should be_true
    @role.has_permission?(ActiveSecurity::ControllerPermission.new(SecuredController, :update)).should be_true
  end
  
  it "should be able to tell you if it does not have an equivilant permission" do
    @role.has_permission?(ActiveSecurity::ModelPermission.new(SecuredModel, :delete)).should be_false
    @role.has_permission?(ActiveSecurity::ControllerPermission.new(SecuredController, :destroy)).should be_false
  end
  
end