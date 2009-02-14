module ActiveSecurity
  class ModelPermission
    attr_accessor :model, :verb
  
    def initialize(model, verb)
      @model = model
      @verb = verb
    end
    
    def ==(permission)
      return false unless permission.class == ActiveSecurity::ModelPermission
      self.model == permission.model && self.verb == permission.verb
    end
  end
end