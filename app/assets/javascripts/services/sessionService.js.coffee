ShyneService.factory('Session', ['$location','$http','$q',($location, $http, $q) ->

  _currentUser = null

  login: (email, password) ->
    deferred = $q.defer()
    $http.post('/api/sessions',
      user:
        email: email
        password: password
    ).success((data)->
      _currentUser = data.user
      deferred.resolve(_currentUser)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  logout: () ->
    deferred = $q.defer()
    $http.delete("/api/sessions").then ->
      _currentUser = null
      deferred.resolve()
    deferred.promise

  register: (firstName, lastName, email, password, confirmPassword, timeZone) ->
    deferred = $q.defer()
    $http.post('/api/users',
      user:
        first_name: firstName,
        last_name: lastName,
        email: email
        password: password
        password_confirmation: confirmPassword
        time_zone: timeZone
    ).success((data) ->
      if data.id
        _currentUser = data
        deferred.resolve(_currentUser)
      else
        deferred.reject(data)
    ).error((data) ->
      # TODO: Check server error formate
      deferred.reject(data)
    )
    deferred.promise

  getCurrentUser: () ->
    deferred = $q.defer()
    if this.isAuthenticated()
      deferred.resolve(_currentUser)
    else
      $http.get('/api/users').success((data)->
        _currentUser = data.user
        deferred.resolve(_currentUser)
      )
    deferred.promise

  isAuthenticated: () ->
    !!_currentUser

])
