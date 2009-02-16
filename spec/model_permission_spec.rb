require File.dirname(__FILE__) + '/spec_helper'

class SecuredModel #< ActiveRecord::Base
  
  def do_something
    "I should only be able to call this if I have the SecuredModel#do_something permission"
  end
end

class User #< ActiveRecord::Base
  attr_accessor :roles
end

describe ActiveSecurity::ModelPermission do
  
  before(:all) do
    @user = User.new
    SecuredModel.stub!(:ancestors).and_return([ActiveRecord::Base]) #stub out inheritance so we dont have to deal with active record
    ActiveSecurity::Role.define(:creator) do |creator|
      creator.permit_model(SecuredModel, :new)
    end
    ActiveSecurity::Role.define(:do_somethinger) do |do_somethinger|
      do_somethinger.permit_model(SecuredModel, :do_something)
    end
    #TODO set @user to active?
    #config method to return active user?
  end
  
  before(:each) do
    #reset permissions before each test
    @user.roles = []
  end

  it "should not let me call SecuredModel#new if I do not have the SecuredModel#new permission (class method)" do
    lambda{SecuredModel.new}.should raise_error("you do not have permission to do that")
  end
  
  it "should not let me call SecuredModel#do_something if I do not have the SecuredModel#do_something permission (instance method)" do
    @user.add_role(:creator)
    secured_model = SecuredModel.new
    lambda{secured_model.do_something}.should raise_error("you do not have permission to do that")
  end
  
  it "should let me call SecuredModel#new if I have the SecuredModel#new permission (class method)" do
    @user.add_role(:creator)
    secured_model = SecuredModel.new
    secured_model.should_not be_nil
  end
  
  it "should let me call SecuredModel#do_something if I have the SecuredModel#do_something permission (instance method)" do
    @user.add_role(:creator)
    secured_model = SecuredModel.new
    secured_model.do_something.should == "I should only be able to call this if I have the SecuredModel#do_something permission"
  end
end