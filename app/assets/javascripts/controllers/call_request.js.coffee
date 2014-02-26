Shyne.controller('CallRequestCtrl', ['$location', '$scope', '$rootScope', '$timeout', '$routeParams', 'Session', 'User', 'Workhistory', 'Conversation',($location, $scope, $rootScope, $timeout, $routeParams, Session, User, Workhistory, Conversation) ->

  $scope.user = null
  $scope.mentor = null
  $scope.callRequestModel = {form: 'cal_details'}
  $scope.callRequestModel.status = "proposed"

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

  mentor_id = $routeParams.mentor_id

  if $routeParams.mentor_id != null and $routeParams.mentor_id != undefined
    User.getMentorInfo(mentor_id).then((mentorInfo) ->
      $scope.mentor = mentorInfo
    )

  request_id = $routeParams.request_id

  if $routeParams.request_id != null and $routeParams.request_id != undefined
    User.getCallRequest(request_id).then((requestInfo) ->
      $scope.callRequestModel = requestInfo
    )

  $scope.proposedDurationOptions = []
  proposed_duration = ["20", "30", "40"]
  for i in proposed_duration
    $scope.proposedDurationOptions.push({ name: "#{i} Minutes", id: i })

  $scope.callRequestModel.proposed_duration = $scope.proposedDurationOptions[0]

  month_list = ["January", "February", "March", "April",  "May",  "June", "July", "August", "September", "October", "November", "December"]
  $scope.expiredMonths = []
  for j,idx in month_list
    $scope.expiredMonths.push({ name: j, id: (idx + 1) })

  $scope.callRequestModel.expired_month = $scope.expiredMonths[0]

  $scope.expiredYears = []
  current_year = new Date()
  started_year = current_year.getFullYear()
  ended_year = started_year + 15
  year_list = [started_year..ended_year]

  for j in year_list
    $scope.expiredYears.push({ name: j, id: j })

  $scope.callRequestModel.expired_year = $scope.expiredYears[0]

  $scope.calDetails = () ->
    $scope.callRequestModel.form = 'cal_details'
  $scope.availableTimes = () ->
    $scope.callRequestModel.form = 'avl_times'
  $scope.PaymentInfo = (forceRedirect) ->
    $scope.callRequestModel.form = 'avl_times' if $scope.user.customer_uri != null and forceRedirect
    $scope.callRequestModel.form = 'payment_info' if $scope.user.customer_uri == null and !forceRedirect
    $scope.callRequestModel.form = 'confirm_details' if $scope.user.customer_uri != null and !forceRedirect

  $scope.ConfirmDetails = () ->
    $("#spinner").show()
    User.addCreditCard($scope.callRequestModel).then(
      (data)->
        $("#spinner").hide()
        $scope.creditCardError = ''
        $scope.callRequestModel.form = 'confirm_details'
    , (error)->
        $("#spinner").hide()
        $scope.creditCardError = error
    )

  $scope.SubmitCallRequest = () ->
    $("#loaderimgText").show()
    User.createCallRequest($scope.callRequestModel, $scope.user.role_id, mentor_id).then(
      (call_request)->
        Conversation.createConversation($scope.callRequestModel, $scope.mentor.user.id, call_request.id).then((data)->
          $("#loaderimgText").hide()
          $rootScope.flash_message = "You're all done! We'll send you an email once the Mentor responds."
          $location.path('/profile/' + $scope.mentor.user_id)
        )
    , (error)->
      $scope.callRequestModelError = error
    )

])
