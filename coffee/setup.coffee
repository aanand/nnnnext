UserInfo = localStorage.user? && JSON.parse(localStorage.user)

LocalSync =
  sync: (method, model, options) ->
    ret = Backbone.localSync(method, model, options)
    @trigger("sync", method, model, options)
    ret

  migrate: (oldNS, newNS) ->
    for key in _.keys(localStorage)
      if key.search("#{oldNS}/") == 0
        value  = localStorage.getItem(key)
        newKey = key.replace(oldNS, newNS)

        console.log "Moving #{key} to #{newKey}"

        localStorage.setItem(newKey, value)
        localStorage.removeItem(key)

LocalSync.nsPrefix   = "nnnnext"
LocalSync.unsyncedNS = "#{LocalSync.nsPrefix}/unsynced"

if UserInfo
  LocalSync.ns = "#{LocalSync.nsPrefix}/#{UserInfo._id}"
  LocalSync.migrate(LocalSync.unsyncedNS, LocalSync.ns)
else
  LocalSync.ns = LocalSync.unsyncedNS

_.bindAll(LocalSync, "sync")
_.extend(LocalSync, Backbone.Events)

