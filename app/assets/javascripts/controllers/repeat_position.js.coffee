Shyne.controller('RepeatPositionCtrl', ['$location', '$scope', '$rootScope', '$timeout', '$routeParams', 'Session', 'User', 'Workhistory',($location, $scope, $rootScope, $timeout, $routeParams, Session, User, Workhistory) ->

  count = 2

  $scope.historyModel.positions = []

  $scope.addPosition = () ->
    $scope.historyModel.positions.push({previous_title_text:"", previous_company_text:"", previous_year_started_text:"", previous_year_ended_text:""})
    count += 1

  $scope.remaining = () ->
    angular.forEach($scope.historyModel.positions, (todo) ->
      count += todo.done ? 0 : 1
    )
    return count

  $scope.removePosition = (index) ->
    $scope.historyModel.positions.splice(index, 1)
])
