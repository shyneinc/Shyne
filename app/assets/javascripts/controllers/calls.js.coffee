Shyne.controller('CallCtrl', ['$location', '$scope', '$rootScope', '$timeout', '$routeParams', 'Session', 'User', 'Workhistory', 'Conversation', 'Calls',($location, $scope, $rootScope, $timeout, $routeParams, Session, User, Workhistory, Conversation, Calls) ->

  $scope.user = null
  $scope.mentor = null
  $scope.call_requests = null

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

  if $routeParams.id != null and $routeParams.id != undefined
    Calls.getCallRequest($routeParams.id).then((callRequest) ->
      $scope.call_request = callRequest
    )
  else
    Calls.getCallRequests().then((callRequest) ->
      $scope.call_requests = callRequest
    )

  $scope.acceptDeclineCallRequest = (status) ->
    $("#loaderimgText").show()
    Calls.acceptDeclineCallRequest($scope.call_request, status).then(
      (data)->
        $("#loaderimgText").hide()
        Calls.getCallRequest($routeParams.id).then((callRequest) ->
          $scope.call_request = callRequest
        )
    , (error)->
      $("#loaderimgText").hide()
      $scope.callRequestModelError = error
    )

  $scope.updateCallRequest = () ->
    $("#loaderimgText").show()
    if $scope.user.role_type == 'Mentor'
      status = 'changed_mentor'
    else
      status = 'changed_member'

    Calls.updateCallRequest($scope.callRescheduleModel, status, $scope.call_request.id).then(
      (data)->
        $("#loaderimgText").hide()
        $rootScope.flash_message = "You're suggested a new time! We'll send you an email once the Mentor responds."
        $location.path('/call_requests/' + $scope.call_request.id)
    , (error)->
      $("#loaderimgText").hide()
      $scope.callRequestModelError = error
    )

  $scope.removeFlashMessage = () ->
    $rootScope.flash_message = null
])
