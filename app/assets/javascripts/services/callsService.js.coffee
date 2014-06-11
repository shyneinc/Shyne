ShyneService.factory('Calls', ['$location','$http','$q',($location, $http, $q) ->

  getCallRequests: () ->
    deferred = $q.defer()
    $http.get('/api/call_requests').success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
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
        scheduled_at: "#{scheduled_date} #{callRequest.scheduled_time} #{callRequest.am_pm}",
        status: status
    ).success((data) ->
      deferred.resolve(data)
    ).error((data)->
      deferred.reject(data.error)
    )
    deferred.promise
])