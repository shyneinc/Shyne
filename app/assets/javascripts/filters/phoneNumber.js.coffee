Shyne.filter "tel", ->
  (tel) ->
    return ""  unless tel
    value = tel.toString().trim().replace(/^\+/, "")
    country = undefined
    city = undefined
    number = undefined
    switch value.length
      when 11
        country = value[0]
        city = value.slice(1, 4)
        number = value.slice(4)
      else
        return tel
    number = number.slice(0, 3) + "-" + number.slice(3)
    (country + "-" + city + "-" + number)
