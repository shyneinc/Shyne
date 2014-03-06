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
      deferred.reject(data)
    )
    deferred.promise

  getCurrentUser: (forceUpdate) ->
    deferred = $q.defer()
    if !forceUpdate && this.isAuthenticated()
      deferred.resolve(_currentUser)
    else
      $http.get('/api/users').success((data)->
        data.user.sign_in_count = data.sign_in_count
        _currentUser = data.user
        deferred.resolve(_currentUser)
      ).error((data)->
        deferred.reject(data)
      )
    deferred.promise

  getFeaturedMentors: () ->
    deferred = $q.defer()
    $http.get('/api/mentors?featured=true').success((data)->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

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

  getAllMentors: () ->
    deferred = $q.defer()
    $http.get('/api/mentors').success((data)->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  isAuthenticated: () ->
    !!_currentUser

])
