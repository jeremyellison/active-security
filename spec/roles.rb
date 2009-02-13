class SecuredModel; end

Role.define(:author) do |role|
  role.permit_model(SecuredModel, :create)
end
