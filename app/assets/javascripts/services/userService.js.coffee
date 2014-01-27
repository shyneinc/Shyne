ShyneService.factory('User', ['$location','$http','$q',($location, $http, $q) ->

  becomeMember: (phoneNumber, industries, time_zone)->
    deferred = $q.defer()
    $http.post('/api/members',
      member:
        phone_number:
          phoneNumber
        industries:
          industries
    ).success((data)->
      if data.id
        deferred.resolve(angular.extend(data, {role_type: 'Member', time_zone: time_zone}))
      else
        deferred.reject(data.errors)
    ).error((data)->
      deferred.reject(data.errors)
    )
    deferred.promise

  becomeMentor: (headline, city, state, years_of_experience, phone_number, availability, linkedin) ->
    deferred = $q.defer()

    $http.post('/api/mentors',
      mentor:
        headline: headline,
        city: city,
        state: state
        years_of_experience: years_of_experience,
        phone_number: phone_number,
        availability: availability,
        linkedin: linkedin
    ).success((data)->
      if data.id
        deferred.resolve(angular.extend(data, {role_type: 'Mentor'}))
      else
        deferred.reject(data.errors)
    ).error((data)->
      deferred.reject(data.errors)
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

  getMentorInfo: (memberId) ->
    deferred = $q.defer()
    $http.get('/api/mentors/' + memberId).success((data) ->
      deferred.resolve(data)
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

  updateAvatar: (files) ->
    payload = new FormData()
    payload.append "user[avatar]", files[0]
    deferred = $q.defer()
    $http.put('/api/users',
      payload
      withCredentials: true
      headers:
        "Content-Type": false
      transformRequest: (tdata) ->
        tdata
    ).success((data) ->
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
        industries:
          user.industries
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

  updateMentor: (user) ->
    deferred = $q.defer()
    $http.put('/api/mentors',
      mentor:
        headline: user.headline,
        city: user.city,
        state: user.state
        years_of_experience: user.years_of_experience,
        phone_number: user.phone_number,
        availability: user.availability,
        linkedin: user.linkedin,
        industries: user.industries,
        skills: user.skills
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

  password_reset: (user) ->
    deferred = $q.defer()
    $http.post('/api/passwords',
      user:
        email:
          user.email
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  changePassword: (user) ->
    deferred = $q.defer()
    $http.put('/api/passwords',
      user:
        reset_password_token: user.reset_password_token,
        password: user.password,
        password_confirmation: user.confirmPassword
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  sendconfirmation: () ->
    deferred = $q.defer()
    $http.post('/api/confirmations').success((data) ->
      if data
        deferred.resolve(data)
      else
        deferred.reject(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  updatePassword: (user) ->
    deferred = $q.defer()
    $http.put('/api/update_password',
      user:
        current_password: user.current_password,
        password: user.password,
        password_confirmation: user.confirmPassword,
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise
])