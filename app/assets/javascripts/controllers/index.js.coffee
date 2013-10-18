Shyne.controller('IndexCtrl', ($location, $scope, Session) ->

  $scope.showIndex = true

  $scope.mentors = [
    {name: 'Rohan Jain', role: 'Product', company: 'Shyne', ratePerMinute: 3, photoUrl: '/assets/sample/rohan.jpg'},
    {name: 'Jesal Gadhia', role: 'Engineer', company: 'Shyne', ratePerMinute: 5, photoUrl: '/assets/sample/jesal.jpg'},
    {name: 'Audee Velasco', role: 'Design', company: 'Shyne', ratePerMinute: 4, photoUrl: '/assets/sample/audee.jpg'},
    {name: 'Tim Wong', role: 'Engineer', company: 'Shyne', ratePerMinute: 3, photoUrl: '/assets/sample/tim.jpg'},
    {name: 'Snowy', role: 'Security', company: 'Shyne', ratePerMinute: 10, photoUrl: '/assets/sample/snowy.jpg'},
    {name: 'Mr. Smith', role: 'Manger', company: 'Smith Co.', ratePerMinute: 20, photoUrl: '/assets/sample/smith.jpg'}
  ]

  $scope.home = () ->
    $scope.showIndex = true

  Session.requestCurrentUser().then((user)->
    $scope.user = user
  ()->
    $scope.user = null
  )

)