#= require jquery.min
#= require suggest.min
#= require twitter/bootstrap
#= require jquery.ui.datepicker
#= require jquery.timepicker
#= require underscore
#= require moment.min
#= require angular
#= require angular-route
#= require angular-moment
#= require ng-tags-input
#= require ui-utils
#= require angular-resource
#= require angular-blocks
#= require angular-sanitize
#= require setup
#= require_directory ./controllers
#= require_directory ./services
#= require_directory ./filters
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

Shyne.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider.when("/",
    templateUrl: "/home/index.html"
    controller: 'HomeCtrl'
  ).when("/profile/",
    templateUrl: "/profile/index.html"
    controller: 'ProfileCtrl'
  ).when("/profile/:user_id",
    templateUrl: "/profile/user_profile.html"
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
  ).when("/resetpassword",
    templateUrl: "/profile/resetpassword.html"
    controller: 'ProfileCtrl'
  ).when("/resetpassword/:token",
    templateUrl: "/profile/updatepassword.html"
    controller: 'ProfileCtrl'
  ).when("/our-mission",
    templateUrl: "/home/our_mission.html"
    controller: 'HomeBaseCtrl'
  ).when("/search",
    templateUrl: "/home/search_mentors.html"
    controller: 'SearchCtrl'
  ).when("/search/:q",
    templateUrl: "/home/search_mentors.html"
    controller: 'SearchCtrl'
  ).when("/confirmation",
    templateUrl: "/users/confirmation.html"
    controller: 'ProfileCtrl'
  ).when("/settings",
    templateUrl: "/profile/settings.html"
    controller: 'ProfileCtrl'
  ).when("/basicinfo",
    templateUrl: "/settings/basic_information.html"
    controller: 'ProfileCtrl'
  ).when("/changepassword",
    templateUrl: "/settings/changepassword.html"
    controller: 'ProfileCtrl'
  ).when("/creditcard",
    templateUrl: "/settings/creditcard.html"
    controller: 'ProfileCtrl'
  ).when("/bankaccount",
    templateUrl: "/settings/bank_account.html"
    controller: 'ProfileCtrl'
  ).when("/emailnotification",
    templateUrl: "/settings/emailnotifications.html"
    controller: 'ProfileCtrl'
  ).when("/account",
    templateUrl: "/settings/account_status.html"
    controller: 'ProfileCtrl'
  ).when("/call_request/:mentor_id",
    templateUrl: "/call_request/index.html"
    controller: 'CallRequestCtrl'
  ).when("/conversation",
    templateUrl: "/conversations/index.html"
    controller: 'ConversationsCtrl'
  ).when("/conversation/:conversation_id",
    templateUrl: "/conversations/show.html"
    controller: 'ConversationsCtrl'
  ).when("/call_requests",
    templateUrl: "/call_request/call_requests.html"
    controller: 'CallCtrl'
  ).when("/call_requests/:id",
    templateUrl: "/call_request/call_detail.html"
    controller: 'CallCtrl'
  ).when("/call_requests/:id/suggest",
    templateUrl: "/call_request/reschedule.html"
    controller: 'CallCtrl'
  ).when("/thankyou",
    templateUrl: "/users/thankyou.html"
    controller: 'ThankYouCtrl'
  ).when("/contactus",
    templateUrl: "/footer/contactus.html"
    controller: 'HomeCtrl'
  ).when("/blog",
    templateUrl: "/footer/blog.html"
    controller: 'HomeCtrl'
  ).when("/faq",
    templateUrl: "/footer/faq.html"
    controller: 'HomeCtrl'
  ).when("/terms",
    templateUrl: "/footer/terms.html"
    controller: 'HomeCtrl'
  )

]

Shyne.run ($rootScope, $route, $window) ->
  #get previous route and assign before page load
  $rootScope.$on "$locationChangeStart", (e, currentRoute, previousRoute) ->
    $rootScope.oldUrl = previousRoute
    $rootScope.oldHash = $window.location.hash
    return

  #assign in routescope variable after success
  $rootScope.$on "$routeChangeSuccess", (e, currentRoute, previousRoute) ->
    $rootScope.previousUrl = $rootScope.oldHash
    return

  return
