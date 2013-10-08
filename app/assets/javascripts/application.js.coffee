#= require jquery.min
#= require suggest.min
#= require angular
#= require twitter/bootstrap
#= require angular-strap.min
#= require angular-resource
#= require setup
#= require_tree .

Shyne.config(["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
  interceptor = ["$location", "$rootScope", "$q", ($location, $rootScope, $q) ->
    success = (response) ->
      response
    error = (response) ->
      if response.status is 401
        $rootScope.$broadcast "event:unauthorized"
        $location.path "/users/login"
        return response
      $q.reject response
    (promise) ->
      promise.then success, error
  ]
  $httpProvider.responseInterceptors.push interceptor
])

Shyne.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when("/",
    controller: 'HomeCtrl'
    templateUrl: "/home/index.html"
  ).when("/profile",
    templateUrl: "/profile/index.html"
    controller: 'ProfileCtrl'
  ).when("/users/login",
    templateUrl: "/users/login.html"
    controller: 'UsersCtrl'
  ).when "/users/register",
    templateUrl: "/users/register.html"
    controller: 'UsersCtrl'

]