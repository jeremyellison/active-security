require File.dirname(__FILE__) + '/spec_helper'

class SecuredModel < ActiveRecord::Base
end
class SecuredController < ActionController::Base
end
class SecuredNonActiveRecordModel; end
class SecuredNonActiveControllerController; end

describe ActiveSecurity::RoleSet do
  it "should be yielded when Role.define is called" do
    test_roleset = nil
    ActiveSecurity::Role.define(:author) do |r|
      test_roleset = r
    end
    test_roleset.class.should == ActiveSecurity::RoleSet
    test_roleset.role.should == ActiveSecurity::RoleSet.get_role(:author)
  end
  
  it "should create a new Role object on define" do
    ActiveSecurity::Role.define(:editor) do |editor|
    end
    ActiveSecurity::RoleSet.get_role(:editor).should_not be_nil
    ActiveSecurity::RoleSet.get_role(:editor).class.should == ActiveSecurity::Role
  end
  
  it "should raise an error when attempting to redefine a Role" do
    ActiveSecurity::Role.define(:creator) {|creator|}
    lambda{ActiveSecurity::Role.define(:creator){|creator|}}.should raise_error("Can't redefine creator role, it is already defined.")
  end
  
  it "should create roles with the given permissions within the define block" do
    ActiveSecurity::ControllerPermission.should_receive(:new).with(SecuredController, :update).and_return(p1 = "mock permission 1")
    ActiveSecurity::ModelPermission.should_receive(:new).with(SecuredModel, :new).and_return(p2 = "mock permission 2")
    ActiveSecurity::Role.define(:manager) do |manager|
      manager.permit_action(SecuredController, :update)
      manager.permit_model(SecuredModel, :new)
    end
    ActiveSecurity::RoleSet.get_role(:manager).permissions.should == [p1, p2]
  end
  
  it "should raise an error if the model we are trying to permit is not an active record model" do
    lambda{ActiveSecurity::Role.define(:owner) do |owner|
      owner.permit_model(SecuredNonActiveRecordModel, :new)
    end}.should raise_error("Model must be an ActiveRecord model")
  end
  
  it "should raise an error if the controller we are trying to permit is not a child of ActionController" do
    lambda{ActiveSecurity::Role.define(:user) do |user|
      user.permit_action(SecuredNonActiveControllerController, :index)
    end}.should raise_error("Controller must be an ActionController controller")
  end
end