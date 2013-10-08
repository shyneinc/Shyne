Shyne.controller('HomeCtrl', ($scope, Session) ->
  $scope.mentors = [
    {name: 'Rohan Jain', role: 'Product', company: 'Shyne', ratePerMinute: 3},
    {name: 'Jesal Gadhia', role: 'Engineer', company: 'Shyne', ratePerMinute: 5},
    {name: 'Audee Velasco', role: 'Design', company: 'Shyne', ratePerMinute: 4},
    {name: 'Tim Wong', role: 'Engineer', company: 'Shyne', ratePerMinute: 3},
    {name: 'Mr. Smith', role: 'Advisor', company: 'Google', ratePerMinute: 10 }
  ]
)