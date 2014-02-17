Shyne.controller('ConversationsCtrl', ['$location', '$scope','$timeout','$routeParams', '$rootScope', 'Session', 'User', 'Workhistory', 'Conversation',($location, $scope, $timeout, $routeParams, $rootScope, Session, User, Workhistory, Conversation) ->

  $scope.user = null
  $scope.conversationModel = null
  $scope.conversations = null
  $scope.conversation_id = $routeParams.conversation_id

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

  $scope.getConversations = () ->
    Conversation.getConversations(false).then((data)->
      $scope.conversations = data
    )

  $scope.getConversation = () ->
    Conversation.getConversation($scope.conversation_id).then((data)->
      $scope.conversations = data
    )

  $scope.createConversation = () ->
    $scope.refresh(true)
    Conversation.createConversation($scope.conversationModel, $scope.user.id
    ).then((data) ->
      angular.extend($scope.conversation, data)
    , (data) ->
      $scope.conversationModelError = data
    )

  $scope.showConversation = (conversationUrl) ->
    $location.path ('/conversation/'+conversationUrl)

  if $routeParams.conversation_id != undefined and $routeParams.conversation_id != null
    $scope.getConversation()
  else
    $scope.getConversations()

  $scope.replyOnConversation = () ->
    Conversation.replyConversation($scope.conversationModel, $scope.conversation_id).then((data) ->
      $scope.getConversation()
      $scope.conversationModel.body = null
    , (data) ->
      $scope.conversationModelError = data
    )
])
