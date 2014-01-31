Shyne.controller('ProfileCtrl', ['$http', '$location', '$scope','$timeout', '$routeParams', 'Session', 'User', 'Workhistory',($http, $location, $scope, $timeout, $routeParams, Session, User, Workhistory) ->

  $scope.user = null
  $scope.work_history = null
  $scope.welcomeModel = {role: null}
  $scope.resetModel = {token: null}
  $scope.historyModel = {role: null}
  $scope.work_histories = null
  $scope.memberModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.mentorModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.previousPosition = false
  
  $scope.loadIndustries = (query) ->
    $http.get('/api/industries?query=' + query).then((industries)->
      $scope.historyModel.industries = []
      for i in industries
        $scope.historyModel.industries.push(i.title)
      return $scope.historyModel.industries
    )
  
  $scope.loadIndustries1 = (query) ->
    return ['aaa', 'bbb', 'ccc']
  

  #month started ended
  month_arr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Octomber", "November", "December"]

  $scope.startedMonthOptions = []
  $scope.endedMonthOptions = []

  for i in month_arr
    $scope.startedMonthOptions.push({ name: i, id: i })
    $scope.endedMonthOptions.push({ name: i, id: i })

  $scope.historyModel.startedCurrentMonthOption = $scope.historyModel.startedPreviousMonthOption = ""
  $scope.historyModel.endedPreviousMonthOption = ""
  current_year = new Date().getFullYear()

  #year started ended
  $scope.startedYearOptions = []
  $scope.endedYearOptions = []
  for i in [current_year-20..current_year]
    $scope.startedYearOptions.push({ name: i, id: i })
    $scope.endedYearOptions.push({ name: i, id: i })

  $scope.historyModel.startedCurrentYearOption = ""
  $scope.historyModel.endedPreviousYearOption = ""

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
  
  $scope.state_list = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC',
                'ND','OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']
  
  $scope.refresh(false)

  $scope.showMemberForm = () ->
    $scope.welcomeModel.role = 'Member'

  $scope.showMentorForm = () ->
    $scope.welcomeModel.role = 'Mentor'

  $scope.clearRole = () ->
    $scope.welcomeModel.role = null

  $scope.becomeMember = () ->
    User.becomeMember($scope.memberModel.phoneNumber, $scope.memberModel.industries, $scope.memberModel.timeZone).then((data)->
     $scope.userInfo = { user: { time_zone: $scope.memberModel.timeZone} }
     angular.extend($scope.user, data)
     User.updateUser($scope.userInfo)
    , (data) ->
      $scope.memberFormError = data
    )

  $scope.becomeMentor = () ->
    User.becomeMentor(
      $scope.mentorModel.headline,
      $scope.mentorModel.city,
      $scope.mentorModel.state,
      $scope.mentorModel.yearsOfExperience,
      $scope.mentorModel.phoneNumber,
      $scope.mentorModel.availability,
      $scope.mentorModel.linkedin
    ).then((data) ->
      angular.extend($scope.user, data)
      $scope.historyModel.role = 'Mentor'
      $scope.userInfo = { user: { time_zone: $scope.mentorModel.timeZone} }
      User.updateUser($scope.userInfo)
    , (data) ->
      $scope.mentorFormError = data
    )

  $scope.createWorkHistory = () ->
    $scope.refresh(true)
    window.setTimeout(() ->
      $scope.user.industries = $scope.historyModel.industries
      $scope.user.skills = $scope.historyModel.skills
      #update industries and program of mentor
      User.updateMentor($scope.user)
      #create work current and previous history of mentor

      Workhistory.createWorkHistory($scope.historyModel,
        $scope.user.role_id
      ).then((data) ->
        angular.extend($scope.work_history, data)
      , (data) ->
        $scope.historyFormError = data
      )
    , 1000)
    window.setTimeout(() ->
      $scope.historyModel = {role: null}
    , 1000)

  $scope.updateMember = () ->
    User.updateMember($scope.user).then(() ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )

  $scope.updateMentor = () ->
    User.updateMentor($scope.user).then(() ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )

  $scope.password_reset = () ->
    User.password_reset($scope.forgotModel).then((data) ->
      $scope.flash_message = 'Email sent with password reset instructions.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    , (data) ->
      $scope.resetpasswordFormError = data
    )


  $scope.changePassword = () ->
    User.changePassword($scope.resetModel).then((data) ->
      $scope.flash_message = 'Your password has been changed.'
      $timeout (->
          $scope.flash_message = null
          $location.path '/profile/'
        ), 1500
    , (data) ->
      $scope.resetpasswordFormError = data
    )

  if $routeParams.token != null
    $scope.resetModel.reset_password_token = $routeParams.token

  $scope.resendconfirmation = () ->
    User.sendconfirmation().then((data) ->
      $scope.flash_message = 'Re-send confirmation link successfully.'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    ,(data) ->
      $scope.flash_message = data.error
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    )

  $scope.updateAvatar = (element) ->
    User.updateAvatar(element.files).then((data) ->
      Session.getCurrentUser(true).then((user)->
        $scope.user.avatar = user.avatar
      )
    , (data) ->
      $scope.resetpasswordFormError = data.errors
    )

  $scope.updateUser = () ->
    $scope.updateMentor($scope.user)
    User.updateUser($scope.user).then((data) ->
      $scope.flash_message = 'User Information Updated.'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    , (data) ->
      $scope.resetpasswordFormError = data.errors
    )

  $scope.updatePassword = () ->
    User.updatePassword($scope.user).then((data) ->
      $scope.flash_message = 'Your Password has been updated!'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    , (data) ->
      $scope.changepasswordFormError = data.errors
    )
])
