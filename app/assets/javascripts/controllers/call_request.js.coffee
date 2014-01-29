Shyne.controller('CallRequestCtrl', ['$location', '$scope','$timeout', '$routeParams', 'Session', 'User', 'Workhistory',($location, $scope, $timeout, $routeParams, Session, User, Workhistory) ->

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

  $scope.proposedDurationOptions = []
  proposed_duration = ["10", "15", "20", "25", "30"]
  for i in proposed_duration
    $scope.proposedDurationOptions.push({ name: "#{i} minutes", id: i })

  $scope.callRequestModel.proposed_duration = $scope.proposedDurationOptions[0]
  mentor_id = $routeParams.mentor_id
  $scope.mentor = User.getMentorInfo(mentor_id)

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
  $scope.PaymentInfo = () ->
    $scope.callRequestModel.form = 'payment_info'

  $scope.ConfirmDetails = () ->
    User.addCreditCard($scope.callRequestModel).then(
      (data)->
        $scope.callRequestModel.form = 'confirm_details'
    , (error)->
      $scope.creditCardError = error
    )

  $scope.SubmitCallRequest = () ->
    User.createCallRequest($scope.callRequestModel, $scope.user.role_id, mentor_id).then(
      (data)->
        $location.path '/profile/'
    , (error)->
      $scope.callRequestModelError = error
    )
])
