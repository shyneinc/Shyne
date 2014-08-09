Shyne.controller('CallCtrl', ['$location', '$scope', '$rootScope', '$timeout', '$routeParams', 'Session', 'User', 'Workhistory', 'Conversation', 'Calls',($location, $scope, $rootScope, $timeout, $routeParams, Session, User, Workhistory, Conversation, Calls) ->

  $rootScope.location = $location
  $scope.user = null
  $scope.advisor = null
  $scope.call_requests = null
  $scope.call_request_id = $routeParams.id
  $scope.callRescheduleModel = {am_pm: "PM"}

  time_arr = ["01:00", "01:30", "02:00", "02:30", "03:00", "03:30", "04:00", "04:30", "05:00", "05:30", "06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30"]
  $scope.timeList = []

  for i in time_arr
    $scope.timeList.push({ value : i, text: i})

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

        if status == 'approved_advisor' or status == 'approved_member'
          $rootScope.flash_message = "This call has officially been scheduled! Please check your email for instructions on entering the call."

        if status == 'cancelled_advisor' or status == 'cancelled_member'
          $rootScope.flash_message = "This call has officially been cancelled. We will let the other party know. Thanks"

        Calls.getCallRequest($routeParams.id).then((callRequest) ->
          $scope.call_request = callRequest
        )
    , (error)->
      $("#loaderimgText").hide()
      $scope.callRequestModelError = error
    )

  $scope.updateCallRequest = () ->
    $("#loaderimgText").show()

    #status changes when advisor or member update call request
    status = $scope.user.role_type == 'Advisor' && 'changed_advisor' || 'changed_member'

    Calls.updateCallRequest($scope.callRescheduleModel, status, $scope.call_request.id).then(
      (data)->
        $("#loaderimgText").hide()
        $rootScope.flash_message = "You've suggested a new time! We will send you an email once the other party responds."
        $location.path('/call_requests/' + $scope.call_request.id)
    , (error)->
      $("#loaderimgText").hide()
      $scope.callRequestModelError = error
    )

  $scope.removeFlashMessage = () ->
    $rootScope.flash_message = null
])
