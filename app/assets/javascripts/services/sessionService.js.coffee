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

  register: (email, password, confirmPassword) ->
    deferred = $q.defer()
    $http.post('/api/users',
      user:
        email: email
        password: password
        password_confirmation: confirmPassword
    ).success((data) ->
      _currentUser = data
      deferred.resolve(_currentUser)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  requestCurrentUser: () ->
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