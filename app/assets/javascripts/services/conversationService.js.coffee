ShyneService.factory('Conversation', ['$location','$http','$q',($location, $http, $q) ->

  getInboxConversations: () ->
    deferred = $q.defer()

    $http.get('/api/conversations/box/inbox').success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  createConversation: (conversation_model, sender_id) ->
    deferred = $q.defer()

    $http.post('/api/conversations',
      conversation:
        body: history_model.current_title,
        subject: history_model.current_company,
        user_id: sender_id
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

])