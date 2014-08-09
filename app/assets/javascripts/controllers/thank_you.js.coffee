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
      else if user.role_type is 'Advisor'
        User.getAdvisorInfo(user.role_id).then((advisorInfo) ->
          $scope.editIndustryModel.industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
          $scope.user_industries = advisorInfo.industries.split(", ") if advisorInfo.industries != null
          $scope.user_skills = advisorInfo.skills.split(", ") if advisorInfo.skills != null
          $scope.editSchoolModel.schools = advisorInfo.schools.split(", ") if advisorInfo.schools != null
          angular.extend(user, advisorInfo)
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