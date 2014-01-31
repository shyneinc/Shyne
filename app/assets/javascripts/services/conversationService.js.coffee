ShyneService.factory('Conversation', ['$location','$http','$q',($location, $http, $q) ->

  getConversations: (conversationType) ->
    deferred = $q.defer()

    if !conversationType
      conversationType = 'inbox'

    $http.get('/api/conversations?box=' + conversationType).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  getConversation: (conversationId) ->
    deferred = $q.defer()

    $http.get('/api/conversations/' + conversationId).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  createConversation: (conversationModel, userId) ->
    deferred = $q.defer()

    $http.post('/api/conversations',
      conversation:
        body: conversationModel.body,
        subject: conversationModel.subject,
        user_id: userId
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise


  replyConversation: (conversationModel, conversationId) ->
    deferred = $q.defer()

    $http.put('/api/conversations/' + conversationId,
      conversation:
        body: conversationModel.body,
        subject: conversationModel.subject
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

])