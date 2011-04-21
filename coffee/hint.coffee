Hint =
  dismiss: (hint) ->
    if hintClass = hint.__proto__.constructor.name
      key = @storageKey(hintClass)
      localStorage.setItem("#{key}/isDismissed", true)

  isDismissed: (hintClass) ->
    key = @storageKey(hintClass)
    localStorage.getItem("#{key}/isDismissed")

  storageKey: (hintClass) ->
    "#{LocalSync.ns}/hint/#{hintClass}"
