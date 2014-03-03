Shyne.controller('ProfileCtrl', ['$http', '$location', '$scope', '$rootScope','$timeout', '$routeParams', '$filter', '$q', 'Session', 'User', 'Workhistory',($http, $location, $scope, $rootScope, $timeout, $routeParams, $filter, $q, Session, User, Workhistory) ->

  $scope.user = null
  $scope.userProfile = null
  $scope.work_history = null
  $scope.welcomeModel = {role: null}
  $scope.resetModel = {token: null}
  $scope.historyModel = {role: null}
  $scope.work_histories = null
  $scope.memberModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.mentorModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.previousPosition = false
  $scope.creditCardModel = {}
  $scope.reviews = null
  $scope.user_id = $routeParams.user_id
  timeZoneArray = ["Alaska", "Arizona", "Central Time (US & Canada)", "Eastern Time (US & Canada)", "Hawaii", "Indiana (East)", "Mountain Time (US & Canada)", "Pacific Time (US & Canada)"]
  $scope.timeZoneList = []
  $scope.monthList = []
  $scope.is_industries = false
  $scope.memberDetailModel = {}
  $scope.editIndustryModel = {}
  $scope.changePasswordModel = null

  for i in timeZoneArray
    $scope.timeZoneList.push({ value : i, text: i})

  $scope.industries = []
  Workhistory.getIndustries().then((industries) ->
    for i in industries
      $scope.industries.push(i[1])
  )

  $scope.loadIndustries = (query) ->
    return User.searchData($scope.industries, query)

  #month started ended
  month_arr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

  $scope.startedMonthOptions = []
  $scope.endedMonthOptions = []

  for i in month_arr
    $scope.startedMonthOptions.push({ name: i, id: i })
    $scope.endedMonthOptions.push({ name: i, id: i })
    $scope.monthList.push({ value : i, text: i})

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


  $scope.creditCardModel.expired_month = ""
  $scope.creditCardModel.expired_year = ""

  month_list = ["January", "February", "March", "April",  "May",  "June", "July", "August", "September", "October", "November", "December"]
  $scope.expiredMonths = []
  for j,idx in month_list
    $scope.expiredMonths.push({ name: j, id: (idx + 1) })

  $scope.creditCardModel.expired_month = $scope.expiredMonths[0]

  $scope.expiredYears = []
  current_year = new Date()
  started_year = current_year.getFullYear()
  ended_year = started_year + 15
  year_list = [started_year..ended_year]

  for j in year_list
    $scope.expiredYears.push({ name: j, id: j })

  $scope.creditCardModel.expired_year = $scope.expiredYears[0]

  $scope.refresh = (forceUpdate) ->
    Session.getCurrentUser(forceUpdate).then((user)->
      $scope.user = user
      if user.role_type is 'Member'
        User.getMemberInfo(user.role_id).then((memberInfo) ->
          $scope.memberDetailModel.industries = memberInfo.industries.split(", ")
          angular.extend(user, memberInfo)
        )
      else if user.role_type is 'Mentor'
        User.getMentorInfo(user.role_id).then((mentorInfo) ->
          $scope.editIndustryModel.industries = mentorInfo.industries.split(", ")
          $scope.user.user_industries = mentorInfo.industries
          angular.extend(user, mentorInfo)
        )
        Workhistory.getWorkHistories(user.role_id).then((workHistoriesInfo) ->
          $scope.work_histories = workHistoriesInfo
        )
        User.getReviews(user.role_id).then((reviews) ->
          $scope.reviews = reviews
        )
    )

  $scope.state_list = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC',
                'ND','OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']

  $scope.stateList = []

  for i in $scope.state_list
    $scope.stateList.push({ value : i, text: i})

  $scope.refresh(false)

  $scope.showMemberForm = () ->
    $scope.welcomeModel.role = 'Member'

  $scope.showMentorForm = () ->
    $scope.welcomeModel.role = 'Mentor'

  $scope.clearRole = () ->
    $scope.welcomeModel.role = null

  $scope.becomeMember = () ->
    User.becomeMember($scope.memberModel.phoneNumber, $scope.memberModel.industries, $scope.memberModel.timeZone).then((data)->
     $scope.user.time_zone = $scope.memberModel.timeZone
     angular.extend($scope.user, data)
     User.updateUser($scope.user)
     $scope.refresh(true)
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
    , (data) ->
      $scope.mentorFormError = data
    )

  $scope.createWorkHistory = () ->
    $scope.refresh(true)
    $scope.user.industries = $scope.historyModel.industries
    $scope.user.skills = $scope.historyModel.skills
    #update industries and program of mentor
    User.updateMentor($scope.user)
    #create work current and previous history of mentor
    window.setTimeout(() ->
      Workhistory.createWorkHistory($scope.historyModel, $scope.user.role_id)
      $scope.refresh(true)
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

  $scope.updateMentorInfo = () ->
    User.updateMentorInfo($scope.user).then((data) ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )

  $scope.updateMentorIndustries = () ->
    $scope.user.industries = $scope.editIndustryModel.industries

    User.updateMentor($scope.user).then(() ->
      $scope.user.industries = $scope.user.industries.join(", ")
      $scope.flash_message = 'User Information Updated.'
      $scope.is_industries = true
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
    User.updateUser($scope.user).then((data) ->
      $scope.flash_message = 'User Information Updated.'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    , (data) ->
      $scope.resetpasswordFormError = data.errors
    )

  $scope.updateMemberDetail = () ->
    $scope.user.industries = $scope.memberDetailModel.industries
    User.updateUser($scope.user).then((data) ->
      $scope.user.industries = $scope.user.industries.join(", ")
      $scope.flash_message = 'User Information Updated.'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
      $scope.updateMentor($scope.user) if $scope.user.role_type == 'Mentor'
      $scope.updateMember($scope.user) if $scope.user.role_type == 'Member'
    , (data) ->
      $scope.memberdetailFormError = data.errors
    )

  $scope.updateUserInformation = () ->
    User.updateUser($scope.user).then((data) ->
      $scope.flash_message = 'User Information Updated.'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
      $scope.updateMentor($scope.user) if $scope.user.role_type == 'Mentor'
      $scope.updateMember($scope.user) if $scope.user.role_type == 'Member'
    , (data) ->
      $scope.resetpasswordFormError = data.errors
    )

  $scope.updatePassword = () ->
    User.updatePassword($scope.changePasswordModel).then((data) ->
      $scope.flash_message = 'Your Password has been updated!'
      $scope.changePasswordModel = null
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    , (data) ->
      $scope.changepasswordFormError = data.errors
    )

  $scope.addCreditCard = () ->
    User.addCreditCard($scope.creditCardModel).then((data) ->
      $scope.refresh(false)
      $scope.flash_message = 'Credit card detail added successfully!'
      $timeout (->
          $scope.flash_message = null
          $location.path '/settings/'
        ), 5000
    , (data) ->
      $scope.creditCardFormError = data.error
    )

  $scope.addBankAccount = () ->
    User.addBankAccount($scope.bankAccountModel).then((data) ->
      $scope.refresh(false)
      $scope.flash_message = 'Bank account detail added successfully!'
      $timeout (->
          $scope.flash_message = null
          $location.path '/settings/'
        ), 5000
    , (data) ->
      $scope.creditCardFormError = data.error
    )

  if $routeParams.user_id != undefined and $routeParams.user_id != null
    User.getUser($routeParams.user_id).then((userProfile)->
      $scope.userProfile = userProfile
      User.getMentorInfo(userProfile.role_id).then((mentorInfo) ->
        angular.extend(userProfile, mentorInfo)
      )
      Workhistory.getWorkHistories(userProfile.role_id).then((workHistoriesInfo) ->
        $scope.user_work_histories = workHistoriesInfo
      )
      User.getReviews(userProfile.role_id).then((reviews) ->
        $scope.user_reviews = reviews
      )
    )

  # filter work histories to show
  $scope.filterWorkHistory = (work_history) ->
    work_history.isDeleted isnt true

  # add user
  $scope.addWorkHistory = ->
    $scope.work_histories.push
      id: $scope.work_histories.length + 1
      title: ""
      company: ""
      started_month: "January"
      started_year: ""
      ended_month: "December"
      ended_year: ""
      isNew: true
    return

  # mark work history as deleted
  $scope.deleteWorkHistory = (id) ->
    filtered = $filter("filter")($scope.work_histories,
      id: id
    )
    filtered[0].isDeleted = true  if filtered.length
    return

  # cancel all changes
  $scope.cancel = ->
    i = $scope.work_histories.length

    while i--
      work_history = $scope.work_histories[i]

      # undelete
      delete work_history.isDeleted  if work_history.isDeleted

      # remove new
      $scope.work_histories.splice i, 1  if work_history.isNew
    return

  $scope.updateWorkHistories = () ->
    results = []
    i = $scope.work_histories.length

    while i--
      work_history = $scope.work_histories[i]

      if work_history.isDeleted
        Workhistory.deleteWorkHistory($scope.user.role_id, work_history.id).then((data) ->
          $scope.work_histories.splice i, 1
        , (data) ->
          $scope.historyFormError = data
        )

      work_history.isNew = true if work_history.isNew

      # send on server
      if !work_history.isDeleted
        if work_history.isNew
          Workhistory.addWorkHistory(work_history, $scope.user.role_id).then((data) ->
            results.push(data)
          , (data) ->
            $scope.historyFormError = data
          )
        else
          Workhistory.updateWorkHistory(work_history, $scope.user.role_id, work_history.id).then((data) ->
            results.push(data)
          , (data) ->
            $scope.historyFormError = data
          )
    $q.all results

  $scope.removeFlashMessage = () ->
    $rootScope.flash_message = null
])
