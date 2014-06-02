Shyne.filter "capitalize", ->
  (string) ->
    return ""  unless string
    value = string.substring(0,1).toUpperCase() + string.substring(1)
