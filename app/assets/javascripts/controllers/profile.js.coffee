Shyne.controller('ProfileCtrl', ['$http', '$location', '$scope', '$rootScope','$timeout', '$routeParams', '$filter', '$q', 'Session', 'User', 'Workhistory',($http, $location, $scope, $rootScope, $timeout, $routeParams, $filter, $q, Session, User, Workhistory) ->

  $rootScope.location = $location
  $scope.user = null
  $scope.userProfile = null
  $scope.work_history = null
  $scope.welcomeModel = {role: null}
  $scope.resetModel = {token: null}
  $scope.historyModel = {role: null}
  $scope.work_histories = null
  $scope.memberModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.advisorModel = {timeZone: 'Pacific Time (US & Canada)'}
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
  $scope.editSchoolModel = {}
  $scope.changePasswordModel = {}
  $scope.bankAccountModel = {}
  $scope.user_industries = []
  $scope.user_skills = []
  $scope.user_profile_industries = []
  $scope.user_profile_skills = []
  $scope.settings = {tab: 'basic_info'}
  $scope.isApproved = true
  $scope.isPhotoNotUploaded = false
  $scope.isPhotoUploaded = false
  $scope.uploadPhotoModel = { uploaded_photo: null}
  $scope.urlPrefix = null
  $scope.userUrlPrefix = null

  $scope.prepareIndustriesAndSchools = () ->
    Workhistory.getIndustries().then((industries) ->
      for i in industries
        $rootScope.industries.push(i[1])
    )

    User.getSchools().then((schools) ->
      for i in schools
        $rootScope.schools.push(i[1])
    )

  if $rootScope.industries != undefined && $rootScope.industries != null && $rootScope.schools != undefined && $rootScope.schools != null
    $rootScope.industries = $rootScope.industries
    $rootScope.schools = $rootScope.schools
  else
    $rootScope.industries = []
    $rootScope.schools = []
    $scope.prepareIndustriesAndSchools()

  for i in timeZoneArray
    $scope.timeZoneList.push({ value : i, text: i})

  $scope.loadIndustries = (query) ->
    return User.searchData($rootScope.industries, query)

  $scope.loadSchools = (query) ->
    return User.searchData($rootScope.schools, query)

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
          if user.sign_in_count < 3 && memberInfo.user.avatar.url.match(/^http([s]?):\/\/.*/)
            $scope.isPhotoNotUploaded = true
          else
            $scope.isPhotoNotUploaded = false

          if $rootScope.creditCardInfo != undefined && $rootScope.creditCardInfo != null
            $rootScope.creditCardInfo = $rootScope.creditCardInfo
          else
            if user.customer_uri != null
              User.getCreditCardInfo().then((creditCardInfo) ->
                $rootScope.creditCardInfo = creditCardInfo
              )
        )
      else if user.role_type is 'Advisor'
        User.getAdvisorInfo(user.role_id).then((advisorInfo) ->
          angular.extend(user, advisorInfo)

          #prepend in missing url
          $scope.urlPrefix = 'https://' if !advisorInfo.linkedin.match(/^http([s]?):\/\/.*/)

          $scope.editIndustryModel.industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
          $scope.user_industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
          $scope.user_skills = advisorInfo.skills.split(", ") if advisorInfo.skills != null
          $scope.editSchoolModel.schools = advisorInfo.schools.split(", ") if advisorInfo.schools != null
          $scope.isApproved = false if advisorInfo.advisor_status != 'approved'
          if user.sign_in_count < 3 && advisorInfo.user.avatar.url.match(/^http([s]?):\/\/.*/)
            $scope.isPhotoNotUploaded = true
          else
            $scope.isPhotoNotUploaded = false
        )
        Workhistory.getWorkHistories(user.role_id).then((workHistoriesInfo) ->
          $scope.work_histories = workHistoriesInfo
          $scope.previousPosition = true if $scope.work_histories.length == 1
        )
        User.getReviews(user.role_id).then((reviews) ->
          $scope.reviews = reviews
        )

        if $rootScope.bankAccountInfo != undefined && $rootScope.bankAccountInfo != null
          $rootScope.bankAccountInfo = $rootScope.bankAccountInfo
        else
          if user.customer_uri != null
            User.getBankAccountInfo().then((bankAccountInfo) ->
              $rootScope.bankAccountInfo = bankAccountInfo
            )

      # display last step to upload photo for both type of user
      if (user.sign_in_count == 1 || user.sign_in_count == 2 ) && $scope.user.role_type != null && $scope.user.avatar == null
        $scope.footer_flash_message = 'Last step: Click "Edit your Profile" on the right to add a photo, and you’re all set!'
    )

  $scope.state_list = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY','LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC',
                'ND','OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']

  $scope.stateList = []

  for i in $scope.state_list
    $scope.stateList.push({ value : i, text: i})

  $scope.refresh(false)

  $scope.showMemberForm = () ->
    $scope.welcomeModel.role = 'Member'

  $scope.showAdvisorForm = () ->
    $scope.welcomeModel.role = 'Advisor'

  $scope.clearRole = () ->
    $scope.welcomeModel.role = null

  $scope.becomeMember = () ->
    $scope.loading = true
    User.becomeMember($scope.memberModel.phoneNumber, $scope.memberModel.industries, $scope.memberModel.timeZone, $scope.memberModel.city, $scope.memberModel.state).then((data)->
     $scope.user.time_zone = $scope.memberModel.timeZone
     angular.extend($scope.user, data)
     User.updateUser($scope.user)
     $scope.refresh(true)
     $scope.loading = false
    , (data) ->
      $scope.loading = false
      $scope.memberFormError = data
    )


  $scope.becomeAdvisor = () ->
    $scope.loading = true
    User.becomeAdvisor(
      $scope.advisorModel.headline,
      $scope.advisorModel.city,
      $scope.advisorModel.state,
      $scope.advisorModel.yearsOfExperience,
      $scope.advisorModel.phoneNumber,
      $scope.advisorModel.availability,
      $scope.advisorModel.linkedin,
      $scope.advisorModel.industries,
      $scope.advisorModel.schools,
      $scope.advisorModel.skills
    ).then((data) ->
      $scope.phoneNumber = $scope.advisorModel.phoneNumber
      $scope.linkedin = $scope.advisorModel.linkedin
      $scope.user.time_zone = $scope.advisorModel.timeZone
      User.updateUser($scope.user).then(()->
        Session.getCurrentUser(true).then((user)->
          $scope.user = user
          User.getAdvisorInfo(user.role_id).then((advisorInfo) ->
            angular.extend(user, advisorInfo)
            $scope.advisorModel.industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
            $scope.advisorModel.schools = advisorInfo.schools.split(", ") if advisorInfo.schools != null
          )
        )
      )
      $scope.historyModel.role = 'Advisor'
      $scope.loading = false
    , (data) ->
      $scope.loading = false
      $scope.advisorFormError = data
    )

  $scope.updateAdvisor = () ->
    $scope.loading = true
    $scope.user.industries = $scope.advisorModel.industries
    $scope.user.schools = $scope.advisorModel.schools
    $scope.phoneNumber = $scope.advisorModel.phoneNumber
    $scope.linkedin = $scope.advisorModel.linkedin
    User.updateAdvisor($scope.user).then(() ->
      User.updateUser($scope.user).then(() ->
        Session.getCurrentUser(true).then((user)->
          $scope.user = user
          User.getAdvisorInfo($scope.user.role_id).then((advisorInfo) ->
            angular.extend($scope.user, advisorInfo)
            $scope.advisorModel.industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
            $scope.advisorModel.schools = advisorInfo.schools.split(", ") if advisorInfo.schools != null
            Workhistory.getWorkHistories($scope.user.role_id).then((workHistoriesInfo) ->
              $scope.work_histories = workHistoriesInfo
              $scope.previousPosition = true if $scope.work_histories.length == 1
              if workHistoriesInfo.length == 0
                $scope.historyModel.role = 'Advisor'
              else
                $scope.historyModel.role = 'update_work_history'
              $scope.loading = false
            )
          )
        )
      , (data) ->
        $scope.loading = false
        $scope.advisorFormError = data
      )
    , (data) ->
      $scope.loading = false
      $scope.advisorFormError = data
    )

  $scope.updateWorkHistory = () ->
    $scope.loading = true
    $scope.updateWorkHistories()
    $scope.added_work_history = false
    Workhistory.getWorkHistories($scope.user.role_id).then((workHistoriesInfo) ->
      $scope.work_histories = workHistoriesInfo
      $scope.previousPosition = true if $scope.work_histories.length == 1
      $scope.historyModel = {role: 'upload_photo'}
      $scope.loading = false
    )

  $scope.createWorkHistory = () ->
    results = []
    $scope.added_work_history = false
    $scope.loading = true
    $scope.user.industries = $scope.advisorModel.industries
    $scope.user.schools = $scope.advisorModel.schools
    $scope.user.skills = $scope.advisorModel.skills
    #update industries and program of advisor
    User.updateAdvisor($scope.user).then(() ->

      #create work current and previous history of advisor
      Workhistory.createWorkHistory($scope.historyModel, $scope.user.role_id).then((data) ->
        $.each($scope.historyModel.positions, (key,valueObj) ->
          Workhistory.addWorkHistoryDetail(valueObj, $scope.user.role_id)
        )

        Workhistory.getWorkHistories($scope.user.role_id).then((workHistoriesInfo) ->
          $scope.work_histories = workHistoriesInfo
          $scope.previousPosition = true if $scope.work_histories.length == 1
          User.updateUser($scope.user)
        )
        $scope.historyModel = {role: 'upload_photo'}
        $scope.loading = false

      , (data) ->
        $scope.loading = false
        $scope.workhistoryFormError = data
      )
    )

  $scope.submitApplication = () ->
    $scope.loading = true
    $scope.refresh(true)
    $scope.loading = false
    $location.path '/thankyou/'

  $scope.password_reset = () ->
    $scope.loading = true
    User.password_reset($scope.forgotModel).then((data) ->
      $scope.loading = false
      $scope.flash_message = 'Email sent with password reset instructions.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    , (data) ->
      $scope.loading = false
      $scope.resetpasswordFormError = data
    )


  $scope.changePassword = () ->
    $scope.loading = true
    User.changePassword($scope.resetModel).then((data) ->
      $scope.loading = false
      $scope.flash_message = 'Your password has been changed.'
      $timeout (->
          $scope.flash_message = null
          $location.path '/profile/'
        ), 1500
    , (data) ->
      $scope.loading = false
      $scope.resetpasswordFormError = data
    )

  if $routeParams.token != null
    $scope.resetModel.reset_password_token = $routeParams.token

  $scope.resendconfirmation = () ->
    $scope.loading = true
    User.sendconfirmation().then((data) ->
      $scope.loading = false
      $scope.flash_message = 'Re-send confirmation link successfully.'
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    ,(data) ->
      $scope.loading = false
      $scope.flash_message = data.error
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    )

  $scope.updateAvatar = (element) ->
    $scope.loading = true
    User.updateAvatar(element.files).then((data) ->
      Session.getCurrentUser(true).then((user)->
        $scope.user.avatar = user.avatar
        $scope.user.user.avatar = user.avatar
        $scope.isPhotoNotUploaded = false
        $scope.loading = false
      )
    , (data) ->
      $scope.loading = false
      $scope.uploadphotoFormError = data.errors
    )

  $scope.updateMemberDetailModal = () ->
    $scope.loading = true
    $scope.user.industries = $scope.memberDetailModel.industries
    User.updateUser($scope.user).then((data) ->
      $scope.user.industries = $scope.user.industries.join(", ")
      User.updateMember($scope.user).then((data) ->
        $('#memberModal').modal('hide')
        $(window).scrollTop(0)
        $scope.loading = false
        $scope.flash_message = 'Your profile has been updated.'
        $timeout (->
            $scope.flash_message = null
            $scope.$digest()
          ), 5000
      , (data) ->
        $scope.loading = false
        $scope.memberModelFormError = data.errors
      )
    , (data) ->
      $scope.loading = false
      $scope.memberModelFormError = data.errors
    )

  $scope.updateUserInformation = () ->
    $scope.loading = true
    User.updateUser($scope.user).then((data) ->
      $scope.flash_message = 'Your profile has been updated.'
      $scope.refresh(false)
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
      User.updateAdvisorInfo($scope.user) if $scope.user.role_type == 'Advisor'
      User.updateMemberInfo($scope.user) if $scope.user.role_type == 'Member'
      $scope.loading = false
    , (data) ->
      $scope.loading = false
      $scope.memberFormError = data.errors
    )

  $scope.updateUserInformationModal = () ->
    $scope.loading = true
    User.updateUser($scope.user).then((data) ->
      $scope.user.title = $scope.user.current_position
      $scope.user.company = $scope.user.current_company
      $scope.user.started_month = $scope.work_histories[0].date_started.split(" ")[0]
      $scope.user.started_year = $scope.work_histories[0].date_started.split(" ")[1]
      $scope.user.ended_month = null
      $scope.user.ended_year = null
      $scope.user.schools = $scope.editSchoolModel.schools
      $scope.user.industries = $scope.editIndustryModel.industries

      Workhistory.updateWorkHistory($scope.user, $scope.user.role_id, $scope.work_histories[0].id).then((data) ->
        User.updateAdvisor($scope.user).then((data) ->
          $('#myModal').modal('hide')
          $(window).scrollTop(0)
          $scope.refresh(false)
          $scope.loading = false
          $scope.flash_message = 'Your profile has been updated.'
          $timeout (->
            $scope.flash_message = null
            $scope.$digest()
          ), 5000
        , (data) ->
          $scope.loading = false
          $scope.advisorModalFormError = data.errors
        )
      , (data) ->
        $scope.loading = false
        $scope.advisorModalFormError = data.errors
      )
    , (data) ->
      $scope.loading = false
      $scope.advisorModalFormError = data.errors
    )

  $scope.updateCallSettingModal = () ->
    $scope.loading = true
    $scope.user.schools = $scope.editSchoolModel.schools
    $scope.user.industries = $scope.editIndustryModel.industries
    User.updateUser($scope.user).then((data) ->
      User.updateAdvisor($scope.user).then((data) ->
        $('#callsettingModal').modal('hide')
        $(window).scrollTop(0)
        $scope.refresh(false)
        $scope.loading = false
        $scope.flash_message = 'Your profile has been updated.'
        $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
      , (data) ->
        $scope.loading = false
        $scope.advisorModalFormError = data.errors
      )
    , (data) ->
      $scope.loading = false
      $scope.advisorModalFormError = data.errors
    )

  $scope.updateExperienceModal = () ->
    $scope.loading = true
    $scope.user.schools = $scope.editSchoolModel.schools
    $scope.user.industries = $scope.editIndustryModel.industries

    User.updateAdvisor($scope.user).then((data) ->
      $scope.updateWorkHistories()
      $('#experienceModal').modal('hide')
      $(window).scrollTop(0)
      $scope.refresh(false)
      $scope.loading = false
      $scope.flash_message = 'Your profile has been updated.'
      $timeout (->
        $scope.flash_message = null
        $scope.$digest()
      ), 5000
    , (data) ->
      $scope.loading = false
      $scope.advisorModalFormError = data.errors
    , (data) ->
      $scope.loading = false
      $scope.advisorModalFormError = data.errors
    , (data) ->
      $scope.loading = false
      $scope.advisorModalFormError = data.errors
    )

  $scope.updatePassword = () ->
    $scope.loading = true
    User.updatePassword($scope.changePasswordModel).then((data) ->
      $scope.loading = false
      $scope.flash_message = 'Your Password has been updated!'
      $scope.changePasswordModel = null
      $timeout (->
          $scope.flash_message = null
          $scope.$digest()
        ), 5000
    , (data) ->
      $scope.loading = false
      $scope.changepasswordFormError = data.errors
    )

  $scope.addCreditCard = () ->
    $scope.loading = true
    User.addCreditCard($scope.creditCardModel).then((data) ->
      $scope.refresh(false)
      $scope.loading = false
      $scope.flash_message = 'Credit card detail added successfully!'
      $rootScope.creditCardInfo = []
      $rootScope.creditCardInfo.push(data)
      $timeout (->
          $scope.flash_message = null
          $location.path '/settings/'
        ), 5000
    , (data) ->
      $scope.loading = false
      $scope.creditCardFormError = data
    )

  $scope.addBankAccount = () ->
    $scope.loading = true
    bank_account = $scope.bankAccountModel
    User.addBankAccount(bank_account.name, bank_account.account_number, bank_account.routing_number).then((data) ->
      $scope.refresh(false)
      $scope.loading = false
      $scope.flash_message = 'Bank account detail added successfully!'
      $rootScope.bankAccountInfo = []
      $rootScope.bankAccountInfo.push(data)
      $timeout (->
          $scope.flash_message = null
          $location.path '/settings/'
        ), 5000
    , (data) ->
      $scope.loading = false
      $scope.bankAccountFormError = data
    )

  if $routeParams.user_id != undefined and $routeParams.user_id != null
    User.getUser($routeParams.user_id).then((userProfile)->
      $scope.userProfile = userProfile
      User.getAdvisorInfo(userProfile.role_id).then((advisorInfo) ->
        angular.extend(userProfile, advisorInfo)

        #prepend in missing url
        $scope.userUrlPrefix = 'https://' if !advisorInfo.linkedin.match(/^http([s]?):\/\/.*/)

        $scope.user_profile_industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
        $scope.user_profile_skills = advisorInfo.skills.split(", ") if advisorInfo.skills != null
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
      id: (Math.floor Math.random() * 55)
      title: ""
      company: ""
      started_month: "January"
      started_year: ""
      ended_month: "December"
      ended_year: ""
      current_work: false
      isNew: true
    return

  $scope.addWorkHistoryForEdit = ->
    if $scope.work_histories.length == 0
      $scope.work_histories.push
        id: (Math.floor Math.random() * 55)
        title: ""
        company: ""
        started_month: "January"
        started_year: ""
        ended_month: "December"
        ended_year: ""
        current_work: false
        isNew: true
      return

  # mark work history as deleted
  $scope.deleteWorkHistory = (id) ->
    filtered = $filter("filter")($scope.work_histories,
      id: id
    )
    if filtered.length
      filtered[0].isDeleted = true
    return

  # cancel all changes
  $scope.cancel = ->
    $scope.memberModel = {timeZone: 'Pacific Time (US & Canada)'}
    $scope.advisorModel = {timeZone: 'Pacific Time (US & Canada)'}
    $scope.advisorModalFormError = null
    $scope.memberModelFormError = null
    $scope.uploadphotoFormError = null
    $scope.refresh(false)

  $scope.updateWorkHistories = () ->
    results = []

    $.each($scope.work_histories, (key, work_history) ->
      if key == 0
        work_history.current_work = true
      else
        work_history.current_work = false

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
    )
    $q.all results

  $scope.removeFlashMessage = () ->
    $rootScope.flash_message = null

  $scope.uploadPicture = (element) ->
    $scope.loading = true
    User.updateAvatar(element.files).then((data) ->
      Session.getCurrentUser(true).then((user)->
        $scope.uploadPhotoModel.uploaded_photo = user.avatar.url
        $scope.isPhotoUploaded = true
        $scope.loading = false
        $scope.upload_photo = true
        $scope.uploadphotoFormError = null
      )
    , (data) ->
      $scope.loading = false
      $scope.uploadphotoFormError = data.errors
    )

  $scope.changePhoto = () ->
    $scope.isPhotoUploaded = false

  $scope.deleteCreditCard = () ->
    $scope.loading = true
    User.deleteCreditCard($rootScope.creditCardInfo[0].id).then((data) ->
      $scope.loading = false
      $rootScope.creditCardInfo = {}
      $scope.flash_message = 'Credit card removed successfully!'
      $timeout (->
          $scope.flash_message = null
          $location.path '/settings/'
        ), 5000
    , (data) ->
      $scope.loading = false
      $scope.CCFormError = data
    )

  $scope.deleteBankAccount = () ->
    $scope.loading = true
    User.deleteBankAccount($rootScope.bankAccountInfo[0].id).then((data) ->
      $scope.loading = false
      $rootScope.bankAccountInfo = {}
      $scope.flash_message = 'Bank account removed successfully!'
      $timeout (->
          $scope.flash_message = null
          $location.path '/settings/'
        ), 5000
    , (data) ->
      $scope.loading = false
      $scope.BAFormError = data
    )

  $scope.backToPreviousStep = (previous_page) ->
    if previous_page == 'become_advisor'
      $scope.user.phone_number = $scope.phoneNumber
      $scope.user.linkedin = $scope.linkedin

    $scope.historyModel.role = previous_page

])
