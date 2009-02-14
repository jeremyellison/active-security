module ActiveSecurity
  class Role
    attr_accessor :name
    attr_accessor :permissions
  
    def self.define(name)
      raise "Can't redefine #{name} role, it is already defined." if RoleSet.get_role(name)
      role = ActiveSecurity::Role.new(name)
      yield ActiveSecurity::RoleSet.new(role)
      ActiveSecurity::RoleSet.register(role)
      role.freeze
    end
  
    def initialize(name)
      # TODO - Verify symbol...
      @name = name
      @permissions = []
    end
  
    def to_s
      #because humanize is part of rails ActiveSupport
      name.to_s.split("_").map{|s| s.capitalize}.join(" ")
    end
  
    def has_permission?(permission)
      permissions.include?(permission)
      !!permissions.detect { |p| p == permission }
    end
  end
end