require "httparty"

module AlbumSearch
  include HTTParty

  base_uri "musicbrainz.org"
  default_params type: "xml"

  def self.search(q)
    words = q.gsub('"', '').split
    query = (words + words.map { |w| "artist:#{w}" }).join(" ")

    response = get("/ws/1/release/", query: {query: query})

    albums = []

    releases = response["metadata"]["release_list"]["release"]
    releases = [releases].flatten

    releases.each do |release|
      id     = release["id"]
      title  = release["title"]
      artist = release["artist"]["name"]

      unless albums.any? { |a| a[:title] == title and a[:artist] == artist }
        albums << { id: id, title: title, artist: artist }
      end
    end
    
    albums[0..7]
  end
end

