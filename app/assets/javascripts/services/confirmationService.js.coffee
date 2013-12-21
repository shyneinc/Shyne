ShyneService.factory('Confirmation', ['$location','$http','$q',($location, $http, $q) ->

  verify: (token) ->
    deferred = $q.defer()
    $http.get("/api/confirmations?confirmation_token=" + token).then(
      (response) ->
        deferred.resolve()
    , (response) ->
        deferred.reject(response.data.error)
    )
    deferred.promise
])
