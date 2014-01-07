#= require jquery.min
#= require suggest.min
#= require twitter/bootstrap
#= require angular
#= require angular-resource
#= require setup
#= require_directory ./controllers
#= require_directory ./services
#= require directives/bootstrapDirectives
#= require directives/formDirectives
#= require directives/jQueryDirectives

Shyne.config(["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
  interceptor = ["$location", "$rootScope", "$q", ($location, $rootScope, $q) ->
    success = (response) ->
      response
    error = (response) ->
      if response.status is 401
        $rootScope.$broadcast "event:unauthorized"
        $q.reject response
    (promise) ->
      promise.then success, error
  ]
  $httpProvider.responseInterceptors.push interceptor
])

Shyne.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "/home/index.html"
    controller: 'HomeCtrl'
  ).when("/profile/",
    templateUrl: "/profile/index.html"
    controller: 'ProfileCtrl'
  ).when("/login",
    templateUrl: "/home/login.html"
    controller: 'HomeBaseCtrl'
  ).when("/signup",
    templateUrl: "/home/signup.html"
    controller: 'HomeBaseCtrl'
  ).when("/logout",
    templateUrl: "/home/logout.html"
    controller: 'LogoutCtrl'
  ).when("/mentors",
    templateUrl: "/home/become_mentors.html"
    controller: 'HomeBaseCtrl'
  ).when("/how",
    templateUrl: "/home/how_it_works.html"
    controller: 'HomeBaseCtrl'
  ).when("/verify",
    templateUrl: "/home/verify.html"
    controller: 'HomeBaseCtrl'
  ).when("/verify/:token",
    templateUrl: "/home/verify.html"
    controller: 'HomeBaseCtrl'
  )

]