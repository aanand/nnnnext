module Twitter
  def self.friends(user)
    response = user.oauth_access_token.get("/1/friends/ids.json?user_id=#{user.twitter_uid}&cursor=-1")

    if response.code.to_i == 200
      JSON.parse(response.body)["ids"].map(&:to_s)
    else
      []
    end
  end
end

