require "httparty"

module AlbumSearch
  include HTTParty

  base_uri "musicbrainz.org"
  default_params type: "xml"

  def self.search(q)
    q = q.gsub('"', '')
    words = q.split

    terms = []

    if words.length > 1
      # search for individual words in title & artist
      terms += words
      terms += words.map { |w| "artist:#{w}" }
    end

    terms << "\"#{q}\""          # boost exact match
    terms << "artist:\"#{q}\"^2" # boost exact artist match extra hard

    # boost official albums over compilations, remixes etc
    terms += ['type:album', 'status:official']

    query = terms.join(" ")

    # puts
    # puts query
    # puts

    response = get("/ws/1/release/", query: {query: query})

    albums = []

    return [] unless response and
      metadata     = response["metadata"] and
      release_list = metadata["release_list"] and
      releases     = release_list["release"]

    releases = [releases].flatten

    releases.each do |release|
      id     = release["id"]
      title  = release["title"]
      artist = release["artist"]["name"]

      # p [artist, title, release["type"]]

      unless albums.any? { |a| a[:title] == title and a[:artist] == artist }
        albums << { id: id, title: title, artist: artist }
      end
    end
    
    albums[0..7]
  end
end

