Shyne.controller('ConversationsCtrl', ['$location', '$scope','$timeout','$routeParams', '$rootScope', '$sce', 'Session', 'User', 'Workhistory', 'Conversation', 'Calls',($location, $scope, $timeout, $routeParams, $rootScope, $sce, Session, User, Workhistory, Conversation, Calls) ->

  $rootScope.location = $location
  $scope.user = null
  $scope.conversationModel = {}
  $scope.conversations = null
  $scope.conversation_id = $routeParams.conversation_id
  $scope.call_request_id = $routeParams.call_request_id

  $scope.refresh = (forceUpdate) ->
    Session.getCurrentUser(forceUpdate).then((user)->
      $scope.user = user
      if user.role_type is 'Member'
        User.getMemberInfo(user.role_id).then((memberInfo) ->
          angular.extend(user, memberInfo)
        )
      else if user.role_type is 'Advisor'
        User.getAdvisorInfo(user.role_id).then((advisorInfo) ->
          angular.extend(user, advisorInfo)
        )
        Workhistory.getWorkHistories(user.role_id).then((workHistoriesInfo) ->
          $scope.work_histories = workHistoriesInfo
        )
    )

  $scope.refresh(false)

  if $routeParams.call_request_id != null and $routeParams.call_request_id != undefined
    Calls.getCallRequest($routeParams.call_request_id).then((callRequest) ->
      $scope.call_request = callRequest
      if $scope.user.role_type is 'Member'
        $scope.reply_to = callRequest.advisor.full_name

      if $scope.user.role_type is 'Advisor'
        $scope.reply_to = callRequest.member.full_name
    )

  $scope.getConversations = () ->
    Conversation.getConversations(false).then((data)->
      $scope.conversations = data
    )

  $scope.getConversation = () ->
    Conversation.getConversation($scope.conversation_id).then((data)->
      $scope.conversations = data
    )

  $scope.createConversation = () ->
    Conversation.createConversation($scope.conversationModel, $scope.user.user.id
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
    if $routeParams.call_request_id == null || $routeParams.call_request_id == undefined
      $scope.getConversations()

  $scope.replyOnConversation = () ->
    Conversation.replyConversation($scope.conversationModel, $scope.conversation_id).then((data) ->
      $scope.getConversation()
      $scope.conversationModel.body = null
    , (data) ->
      $scope.conversationModelError = data
    )

  $scope.stringToHTML = (htmlContent) ->
    $sce.trustAsHtml(htmlContent)


  $scope.createConversation = (call_request) ->
    $scope.loading = true
    if $scope.user.role_type is 'Member'
      user_id = $scope.call_request.advisor.user_id

    if $scope.user.role_type is 'Advisor'
      user_id = $scope.call_request.member.user_id

    Conversation.createConversation($scope.conversationModel, user_id, $scope.call_request.id).then((data)->
      $scope.loading = false
      $rootScope.flash_message = "Message sent successfully!"
      $location.path("/call_requests/#{$scope.call_request.id}")
    )
])
