Shyne.controller('CallRequestCtrl', ['$location', '$scope','$timeout', '$routeParams', 'Session', 'User',($location, $scope, $timeout, $routeParams, Session, User) ->

  $scope.user = null
  $scope.mentor = null
  $scope.callRequestModel = {form: 'cal_details'}

  $scope.proposedDurationOptions = []
  proposed_duration = ["10", "15", "20", "25", "30"]
  for i in proposed_duration
    $scope.proposedDurationOptions.push({ name: i, id: i })

  $scope.scheduledTimeOptions = []
  scheduled_time = ["10", "15", "20", "25", "30"]
  for i in scheduled_time
    $scope.scheduledTimeOptions.push({ name: i, id: i })

  $scope.callRequestModel.proposed_duration = $scope.proposedDurationOptions[0]
  mentor_id = $routeParams.mentor_id
  $scope.mentor = User.getMentorInfo(mentor_id)



  month_list = ["January", "February", "March", "April",  "May",  "June", "July", "August", "September", "October", "November", "December"]
  $scope.expiredMonths = []
  for j in month_list
    $scope.expiredMonths.push({ name: j, id: j })

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
    $scope.callRequestModel = {form: 'cal_details'}
  $scope.availableTimes = () ->
    $scope.callRequestModel = {form: 'avl_times'}
  $scope.PaymentInfo = () ->
    $scope.callRequestModel = {form: 'payment_info'}
  $scope.ConfirmDetails = () ->
    $scope.callRequestModel = {form: 'confirm_details'}

])
