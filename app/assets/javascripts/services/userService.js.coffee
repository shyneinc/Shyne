ShyneService.factory('User', ['$location','$http','$q',($location, $http, $q) ->

  becomeMember: (phoneNumber)->
    deferred = $q.defer()
    $http.post('/api/members',
      member:
        phone_number:
          phoneNumber
    ).success((data)->
      if data.id
        deferred.resolve(data)
      else
        deferred.reject(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  getMemberInfo: (memberId) ->
    deferred = $q.defer()
    $http.get('/api/members/' + memberId).success((data) ->
      if data.id
        deferred.resolve(data)
      else
        deferred.reject(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  updateUser: (user) ->
    deferred = $q.defer()
    $http.put('/api/users', user).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

  updateMember: (user) ->
    deferred = $q.defer()
    $http.put('/api/members',
      member:
        phone_number:
          user.phone_number
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

])