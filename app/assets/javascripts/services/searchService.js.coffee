ShyneService.factory('Search', ['$location','$http','$q',($location, $http, $q) ->

  searchMentors: (search_text) ->
    if !search_text
      search_text = ""

    deferred = $q.defer()
    search_url = if search_text then "/api/search?q=#{search_text}" else "/api/mentors"
    $http.get(search_url).success((data)->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise
])