module ActiveSecurity
  class RoleSet
    #cattr_accessor :defined_roles
    attr_accessor :role  
  
    class << self
      attr_accessor :defined_roles
    end
  
    def self.register(role)
      self.defined_roles ||= []
      self.defined_roles << role
    end
  
    def self.get_role(role_name)
      self.defined_roles ||= []
      self.defined_roles.detect { |role| role.name == role_name }
    end
  
    def initialize(role)
      @role = role
    end
  
    def permit_model(model, verb)
      # validate the verb    
      raise "Model must be an ActiveRecord model" unless model.ancestors.include?(ActiveRecord::Base)
      role.permissions << ActiveSecurity::ModelPermission.new(model, verb)
    end
  
    def permit_action(controller, action)
      # check that its an ActionController descendent
      # check that the action exists as an instance method
      raise "Controller must be an ActionController controller" unless controller.ancestors.include?(ActionController::Base)
      role.permissions << ActiveSecurity::ControllerPermission.new(controller, action)
    end
  end
end