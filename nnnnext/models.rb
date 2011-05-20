require "digest/sha1"

module Nnnnext::Models
  class User
    include Mongoid::Document

    references_many :albums, class_name: "Nnnnext::Models::UserAlbum"

    field :auth_token,        type: String
    field :oauth_credentials, type: Hash

    def generate_auth_token!
      self.auth_token ||= Digest::SHA1.hexdigest(rand.to_s)
    end

    def oauth_access_token
      @access_token ||= OAuth::AccessToken.from_hash(
        Nnnnext.oauth_consumer,
        oauth_token:        oauth_credentials["token"],
        oauth_token_secret: oauth_credentials["secret"])
    end

    def as_json(options=nil)
      options ||= {}

      exclude = [:oauth_credentials]
      exclude << :auth_token unless options.fetch(:include_auth_token, false)

      attributes.except(*exclude).as_json(options)
    end
  end

  class UserAlbum
    include Mongoid::Document

    referenced_in :user,  class_name: "Nnnnext::Models::User"

    field :state,        type: String
    field :stateChanged, type: Integer
    field :rating,       type: Integer
    field :updated,      type: Integer
    field :album_id,     type: String

    def album
      @album ||= Album.find(album_id)
    end

    def album=(a)
      self.album_id = (a.id)
      @album = a
    end

    def as_json(options=nil)
      attributes.except(:_id, :user_id, :album_id).merge(
        id:      album.id,
        artist:  album.artist,
        title:   album.title,
      ).as_json(options)
    end
  end

  class Album
    include Mongoid::Document

    identity type: String

    field :artist, type: String
    field :title,  type: String
  end
end


