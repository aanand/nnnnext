class User extends Backbone.Model
  albumsUrl: ->
    "/u/#{@get('nickname')}/albums"

class UserCollection extends Backbone.Collection
  model: User

