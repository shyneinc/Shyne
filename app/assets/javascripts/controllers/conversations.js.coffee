Shyne.controller('ConversationsCtrl', ['$location', '$scope','$timeout', '$routeParams', 'Session', 'User', 'Conversation',($location, $scope, $timeout, $routeParams, Session, User, Workhistory) ->

  $scope.user = null
  $scope.conversationModel = null
  $scope.conversations null

  $scope.refresh = (forceUpdate) ->
    Session.getCurrentUser(forceUpdate).then((user)->
      $scope.user = user
      if user.role_type is 'Member'
        User.getMemberInfo(user.role_id).then((memberInfo) ->
          angular.extend(user, memberInfo)
        )
      else if user.role_type is 'Mentor'
        User.getMentorInfo(user.role_id).then((mentorInfo) ->
          angular.extend(user, mentorInfo)
        )
        Workhistory.getWorkHistories(user.role_id).then((workHistoriesInfo) ->
          $scope.work_histories = workHistoriesInfo
        )
    )

  $scope.refresh(false)

  Conversation.getInboxConversations().then((data)->
    $scope.conversations = data
  )

  $scope.createConversation = () ->
    $scope.refresh(true)
    Conversation.createConversation($scope.conversationModel, $routeParams.sender_id
    ).then((data) ->
      angular.extend($scope.conversation, data)
    , (data) ->
      $scope.conversationModelError = data
    )

])
