class UserActivatorService
  def self.call(user)
    digest = user.set_activation_token
    # send email with link
    # "/users/#{user.id}/activate?token=#{user.activate_token}"
    "/users/#{user.id}/activate?token=#{digest}"
  end
end
