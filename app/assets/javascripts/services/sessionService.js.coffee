ShyneService.factory('Session', ($location, $http, $q) ->

  _currentUser = null

  login: (email, password) ->
    $http.post('/api/login',
      user:
        email: email
        password: password
    ).success((data)->
      _currentUser = data.user
      $location.path '/profile'
    )

  logout: (redirectTo) ->
    $http.post("/api/logout").then ->
      _currentUser = null
      $location.path redirectTo


  register: (firstName, lastName, email, password) ->
    $http.post('/api/members',
      member:
        first_name: firstName
        last_name: lastName
        user_attributes:
          email: email
          password: password
    ).success((data)->
      _currentUser = data.user
      $location.path '/profile'
    )

  requestCurrentUser: () ->
    deferred = $q.defer()
    if this.isAuthenticated()
      deferred.resolve(_currentUser)
    else
      $http.get('/api/current_user').success((data)->
        _currentUser = data.user
        deferred.resolve(_currentUser)
      )
    deferred.promise

  isAuthenticated: () ->
    !!_currentUser

)