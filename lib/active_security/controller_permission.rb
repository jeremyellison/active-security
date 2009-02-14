module ActiveSecurity
  class ControllerPermission
    attr_accessor :controller, :action
  
    def initialize(controller, action)
      @controller = controller
      @action = action
    end
    
    def ==(permission)
      return false unless permission.class == ActiveSecurity::ControllerPermission
      self.controller == permission.controller && self.action == permission.action
    end
  end
end