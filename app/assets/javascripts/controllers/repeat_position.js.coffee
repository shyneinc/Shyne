Shyne.controller('RepeatPositionCtrl', ['$location', '$scope','$timeout', '$routeParams', 'Session', 'User', 'Workhistory',($location, $scope, $timeout, $routeParams, Session, User, Workhistory) ->

  count = 2
 
  $scope.positions = [{previous_title_text:"previous_title_1", previous_company_text:"previous_company_1", previous_year_started_text:"previous_year_started_1", previous_year_ended_text:"previous_year_ended_1"}]
 
  $scope.addPosition = () ->
    $scope.positions.push({previous_title_text:"previous_title_"+count, previous_company_text:"previous_company_"+count, previous_year_started_text:"previous_year_started_"+count, previous_year_ended_text:"previous_year_ended_"+count})
    count += 1
    
  $scope.remaining = () ->
    angular.forEach($scope.positions, (todo) ->
      count += todo.done ? 0 : 1
    )
    return count
 
])
