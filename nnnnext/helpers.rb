module Nnnnext::Helpers
  def user
    @user ||= (@request[:auth_token] && Nnnnext::Models::User.where(auth_token: @request[:auth_token]).first)
  end

  def json(obj)
    @headers["content-type"] = "application/json; charset=utf-8"
    obj.to_json
  end

  def logger
    defined?(LOGGER) ? LOGGER : STDOUT
  end
end

