module Nnnnext::Controllers
  class Index
    def get
      @headers["content-type"] = "text/html; charset=utf-8"
      render :index
    end
  end

  class Wipe
    def get
      @headers["content-type"] = "text/html; charset=utf-8"

      %{
        <script type="text/javascript">
          localStorage.clear();
          window.location.href = "/";
        </script>
      }
    end
  end

  class ConcatenatedJavascript < R("/all.js")
    def get
      logger.puts "concatenating javascript..."
      paths = js_files.map { |p| "#{Nnnnext.root}/public#{p}" }
      @headers["Content-Type"] = "text/javascript; charset=utf-8"
      @headers["Cache-Control"] = "public; max-age=3600"
      paths.map { |p| File.read(p) }.join
    end
  end

  class AuthTwitterCallback
    def get
      auth = @env['omniauth.auth']

      # require 'pp'; pp auth

      user = User.find_or_create_by(twitter_uid: auth["uid"])
      user.attributes = auth["user_info"]
      user.save!

      @state[:user_id] = user.id

      redirect '/'
    end
  end

  class Signout
    def get
      @state[:user_id] = nil
      ""
    end
  end

  class AlbumsSearch
    def get
      json AlbumSearch.search(@input.q)
    end
  end

  class AlbumsSync
    def post
      if user.nil?
        @status = 401
        return "Unauthorized"
      end

      json = @request.body.read.force_encoding("UTF-8")

      client_albums  = JSON.parse(json)
      user_albums    = user.albums
      updated_albums = Set.new(user_albums)

      client_albums.each do |client_album|
        album_attrs      = client_album.slice("id", "artist", "title")
        user_album_attrs = client_album.except(*album_attrs.keys)
        id               = client_album["id"]
        album            = Models::Album.where(_id: id).first

        if album.nil?
          logger.puts "Album #{id} does not exist on server, creating."
          album = Models::Album.create(album_attrs)
        end

        all_user_albums = user_albums.select { |ua| ua.album_id == id }.sort_by(&:updated).reverse

        if all_user_albums.length > 1
          logger.puts "Found #{all_user_albums.length} copies of album #{id}."

          all_user_albums[1..-1].each do |ua|
            logger.puts " -> Deleting old duplicate (#{ua.updated} < #{all_user_albums.first.updated})"
            ua.destroy
            updated_albums.delete(ua)
          end
        end

        if user_album = all_user_albums.first
          if user_album.updated < client_album["updated"]
            user_album.update_attributes(user_album_attrs)
            updated_albums.delete(user_album)

            logger.puts "Album #{id} is behind on server (#{user_album.updated} < #{client_album["updated"]})."
            logger.puts "Updated server copy: #{user_album.to_json}"
          elsif user_album.updated > client_album["updated"]
            logger.puts "Album #{id} is behind on client. (#{user_album.updated} > #{client_album["updated"]})"
            logger.puts "Sending updated album: #{user_album.to_json}"
          else
            logger.puts "Album #{id} is in sync. (#{user_album.updated})"
            updated_albums.delete(user_album)
          end
        else
          user.albums.create(user_album_attrs.merge(album: album))

          logger.puts "Album #{id} is not in user's list on server."
          logger.puts "Created server copy: #{user_album.to_json}"
        end
      end

      json(updated_albums.to_a)
    end
  end

  class Friends
    def get
      if user.nil?
        @status = 401
        return "Unauthorized"
      end

      ids     = Twitter.friends(user_id: user.twitter_uid)
      friends = Models::User.where(twitter_uid: {:$in => ids})

      json(friends)
    end
  end

  class UserAlbums < R('/u/(\w+)/albums')
    def get(nickname)
      u = Models::User.where(nickname: nickname).first

      if u.nil?
        @status = 404
        return "Not Found"
      end

      albums = u.albums.where(state: "current").descending(:stateChanged) +
               u.albums.where(state: "archived").descending(:stateChanged).limit(10)

      json(albums)
    end
  end
end

