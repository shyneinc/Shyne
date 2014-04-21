Shyne.controller('ThankYouCtrl', ['$http', '$location', '$scope', '$rootScope','$timeout', '$routeParams', '$filter', '$q', 'Session', 'User', 'Workhistory',($http, $location, $scope, $rootScope, $timeout, $routeParams, $filter, $q, Session, User, Workhistory) ->
  $rootScope.location = $location
  $scope.user = null
  $scope.work_history = null
  $scope.editIndustryModel = {}
  $scope.editSchoolModel = {}

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
          $scope.editIndustryModel.industries = mentorInfo.industries.split(", ") if mentorInfo.industries != null
          $scope.user_industries = mentorInfo.industries.split(", ") if mentorInfo.industries != null
          $scope.user_skills = mentorInfo.skills.split(", ") if mentorInfo.skills != null
          $scope.editSchoolModel.schools = mentorInfo.schools.split(", ") if mentorInfo.schools != null
          angular.extend(user, mentorInfo)
        )
        Workhistory.getWorkHistories(user.role_id).then((workHistoriesInfo) ->
          $scope.work_histories = workHistoriesInfo
        )
        User.getReviews(user.role_id).then((reviews) ->
          $scope.reviews = reviews
        )
    )

  $scope.refresh(false)
])