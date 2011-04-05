require "httparty"

module Twitter
  include HTTParty

  base_uri "api.twitter.com"

  def self.friends(params)
    params[:cursor] ||= -1
    get("/1/friends/ids.json", query: params)["ids"].map(&:to_s)
  end
end

