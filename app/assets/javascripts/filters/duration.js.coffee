Shyne.filter("duration", ->
  "$locale"
  "$localeDurations"
  ($locale, $localeDurations) ->
    return duration = (value, unit, precision) ->
      unit_names = [
        "year"
        "month"
        "week"
        "day"
        "hour"
        "minute"
        "second"
      ]
      units =
        year: 86400 * 365.25
        month: 86400 * 31
        week: 86400 * 7
        day: 86400
        hour: 3600
        minute: 60
        second: 1

      words = []
      max_units = unit_names.length
      precision = parseInt(precision, 10) or units[precision or "second"] or 1
      value = (parseInt(value, 10) or 0) * (units[unit or "second"] or 1)
      if value >= precision
        value = Math.round(value / precision) * precision
      else
        max_units = 1
      i = undefined
      n = undefined
      i = 0
      n = unit_names.length

      while i < n and value isnt 0
        unit_name = unit_names[i]
        unit_value = Math.floor(value / units[unit_name])
        unless unit_value is 0
          words.push ($localeDurations[unit_value] or $localeDurations[$locale.pluralCat(unit_value)] or unit_name: ("{} " + unit_name))[unit_name].replace("{}", unit_value)
          break  if --max_units is 0
        value = value % units[unit_name]
        i++
      words.join " "
)