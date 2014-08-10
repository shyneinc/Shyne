ShyneService.factory('User', ['$location','$http','$q',($location, $http, $q) ->

  becomeMember: (phoneNumber, industries, time_zone, city, state)->
    deferred = $q.defer()
    $http.post('/api/members',
      member:
        city: city
        state: state
        phone_number: "1#{phoneNumber}"
        industries: industries.join(", ")
    ).success((data)->
      if data.id
        deferred.resolve(angular.extend(data, {role_type: 'Member', time_zone: time_zone}))
      else
        deferred.reject(data.errors)
    ).error((data)->
      deferred.reject(data.errors)
    )
    deferred.promise

  becomeAdvisor: (headline, city, state, years_of_experience, phone_number, availability, linkedin, industries, schools, skills) ->
    deferred = $q.defer()

    if linkedin && !linkedin.match(/^http([s]?):\/\/.*/)
      linkedin = "https://#{linkedin}"

    if phone_number
      phone_number = "1#{phone_number}"

    $http.post('/api/advisors',
      advisor:
        headline: headline,
        city: city,
        state: state
        years_of_experience: years_of_experience,
        phone_number: phone_number,
        availability: availability,
        linkedin: linkedin,
        industries: industries.join(", "),
        skills: skills,
        schools: schools.join(", ")
    ).success((data)->
      if data.id
        deferred.resolve(angular.extend(data, {role_type: 'Advisor'}))
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

  getAdvisorInfo: (memberId) ->
    deferred = $q.defer()
    $http.get('/api/advisors/' + memberId).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  updateUser: (user) ->
    deferred = $q.defer()
    $http.put('/api/users',
      user:
        first_name: user.first_name
        last_name:  user.last_name,
        email:  user.email,
        avatar: user.avatar,
        password: user.password,
        password_confirmation: user.password_confirmation,
        time_zone: user.time_zone
    ).success((data) ->
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
        "Content-Type": undefined
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
        city:
          user.city
        state:
          user.state
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

  updateAdvisor: (user) ->
    deferred = $q.defer()

    if !user.linkedin.match(/^http([s]?):\/\/.*/)
      user.linkedin = "https://#{user.linkedin}"

    $http.put('/api/advisors',
      advisor:
        headline: user.headline,
        city: user.city,
        state: user.state
        years_of_experience: user.years_of_experience,
        phone_number: user.phone_number,
        availability: user.availability,
        linkedin: user.linkedin,
        industries: user.industries.join(", "),
        skills: user.skills,
        schools: user.schools.join(", "),
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

  updateMemberInfo: (user) ->
    deferred = $q.defer()
    $http.put('/api/members',
      member:
        phone_number:
          user.phone_number
        city:
          user.city
        state:
          user.state
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data)
    )
    deferred.promise

  updateAdvisorInfo: (user) ->
    deferred = $q.defer()
    $http.put('/api/advisors',
      advisor:
        headline: user.headline,
        city: user.city,
        state: user.state
        years_of_experience: user.years_of_experience,
        phone_number: user.phone_number,
        availability: user.availability,
        linkedin: user.linkedin,
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

  addCreditCard: (creditCard) ->
    deferred = $q.defer()
    $http.post('/api/credit_cards',
      credit_card:
        card_number: creditCard.card_number,
        expiration_year: creditCard.expired_year.id,
        expiration_month: creditCard.expired_month.id,
        security_code: creditCard.security_code
    ).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  createCallRequest: (callRequest, memberId, advisorId) ->
    deferred = $q.defer()
    scheduled_date = callRequest.scheduled_at.split("-")
    scheduled_date = "#{scheduled_date[2]}-#{scheduled_date[0]}-#{scheduled_date[1]}"
    $http.post('/api/call_requests',
      call_request:
        agenda: callRequest.agenda,
        member_id: parseInt(memberId),
        advisor_id: parseInt(advisorId),
        scheduled_at: "#{scheduled_date} #{callRequest.scheduled_time} #{callRequest.am_pm}",
        proposed_duration: callRequest.proposed_duration.id,
        status: callRequest.status
    ).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  addBankAccount: (name, account_number, routing_number) ->
    deferred = $q.defer()
    $http.post('/api/bank_accounts',
      bank_account:
        name: name,
        account_number: account_number,
        routing_number: routing_number,
        type: 'checking'
    ).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  searchData: (objectList, query) ->
    items = undefined
    deferred = $q.defer()

    items = _.chain(objectList).filter((x) ->
      x.toLowerCase().indexOf(query.toLowerCase()) > -1
    ).value()

    deferred.resolve(items)
    deferred.promise

  getReviews: (advisorId) ->
    deferred = $q.defer()
    $http.get('/api/advisors/' + advisorId + '/reviews').success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  getUser: (user_id) ->
    deferred = $q.defer()
    $http.get('/api/users?user_id=' + user_id).success((data)->
      deferred.resolve(data.user)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  getCallRequest: (request_id) ->
    deferred = $q.defer()
    $http.get('/api/call_requests/' + request_id).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  acceptDeclineCallRequest: (callRequest, status) ->
    deferred = $q.defer()
    $http.put('/api/call_requests/' + callRequest.id,
      call_request:
        status: status
    ).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  updateCallRequest: (callRequest, status, request_id) ->
    deferred = $q.defer()
    scheduled_date = callRequest.scheduled_at.split("-")
    scheduled_date = "#{scheduled_date[2]}-#{scheduled_date[0]}-#{scheduled_date[1]}"
    $http.put('/api/call_requests/' + request_id,
      call_request:
        scheduled_at: "#{scheduled_date} #{callRequest.scheduled_time}",
        status: status
    ).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  getSchools: () ->
    deferred = $q.defer()

    $http.get('/api/schools').success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  getCreditCardInfo: () ->
    deferred = $q.defer()
    $http.get('/api/credit_cards').success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  deleteCreditCard: (credit_card_id) ->
    deferred = $q.defer()
    $http.delete('/api/credit_cards/' + credit_card_id).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise

  getBankAccountInfo: () ->
    deferred = $q.defer()
    $http.get('/api/bank_accounts').success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data)
    )
    deferred.promise

  deleteBankAccount: (bank_account_id) ->
    deferred = $q.defer()
    $http.delete('/api/bank_accounts/' + bank_account_id).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise
])