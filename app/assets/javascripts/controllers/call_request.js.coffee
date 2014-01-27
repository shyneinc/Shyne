Shyne.controller('CallRequestCtrl', ['$location', '$scope','$timeout', '$routeParams', 'Session', 'User',($location, $scope, $timeout, $routeParams, Session, User) ->

  $scope.user = null
  $scope.callHistoryModel = {form: 'cal_details'}
  
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
  
  $scope.calDetails = () ->
    $scope.refresh(true)  
    $scope.callHistoryModel = {form: 'cal_details'}  
  
  $scope.availableTimes = () ->
    $scope.refresh(true)  
    $scope.callHistoryModel = {form: 'avl_times'}
  $scope.PaymentInfo = () ->
    $scope.refresh(true)  
    $scope.callHistoryModel = {form: 'payment_info'}    
  $scope.ConfirmDetails = () ->
    $scope.refresh(true)  
    $scope.callHistoryModel = {form: 'confirm_details'}    
    
])
