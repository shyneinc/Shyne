Shyne.controller('AppCtrl', ($scope) ->
  $scope.$on "event:unauthorized", (event) ->
    console.log "unauthorized"

  $scope.$on "event:authenticated", (event) ->
    console.log "authenticated"
)