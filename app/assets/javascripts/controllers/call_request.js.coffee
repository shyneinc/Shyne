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
      
  mentor_id = $routeParams.mentor_id
  $scope.mentor = User.getMentorInfo(mentor_id)
  

  
  $scope.calDetails = () ->
    $scope.callRequestModel = {form: 'cal_details'} 
  $scope.availableTimes = () ->
    $scope.callRequestModel = {form: 'avl_times'}
  $scope.PaymentInfo = () ->
    $scope.callRequestModel = {form: 'payment_info'}    
  $scope.ConfirmDetails = () ->
    $scope.callRequestModel = {form: 'confirm_details'}    
    
])
