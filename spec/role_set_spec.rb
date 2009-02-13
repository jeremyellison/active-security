require File.dirname(__FILE__) + '/spec_helper'

class ModelPermission
  attr_accessor :model, :verb
  
  def ==(permission)
    self.model == permission.model && self.verb == permission.verb
  end
end

class ControllerPermission
  attr_accessor :controller, :action
  
  def ==(permission)
    self.controller == permission.controller && self.action == permission.action
  end
end

class RoleSet
  cattr_accessor :defined_roles
  attr_accessor :role  
  
  def self.register(role)
    self.defined_roles ||= []
    self.defined_roles << role
  end
  
  def self.get_role(role_name)
    self.defined_roles.detect { |role| role.name == role_name }
  end
  
  def initialize(role)
    @role = role
  end
  
  def permit_model(model, verb)
    # validate the verb    
    role.permissions << ModelPermission.new(model, verb)
  end
  
  def permit_action(controller, action)
    # check that its an ActionController descendent
    # check that the action exists as an instance method
    role.permissions << ControllerPermission.new(controller, action)
  end
end

class Role
  attr_accessor :name
  attr_accessor :permissions
  
  def self.define(name)
    role = Role.new(name)
    yield RoleSet.new(role)
    RoleSet.register(role)
    role.freeze
  end
  
  def initialize(name)
    # TODO - Verify symbol...
    @name = name
  end
  
  def to_s
    name.humanize
  end
  
  def has_permission?(permission)
    permissions.include?(permission)
    permissions.detect { |p| p == permission } # triggers <=> ????
  end
end

describe RoleSet do
  it "be yielded when Role.define is called" do
    Role.define.
  end
  
  it "should create a new Role object on define" do
    
  end
  
  it "should raise an error when attempting to redefine a Role" do
    
  end
end
