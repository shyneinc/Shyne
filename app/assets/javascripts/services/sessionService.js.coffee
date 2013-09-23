ShyneService.factory('Session', ($location, $http, $q) ->
  # Redirect to the given url (defaults to '/')
  redirect = (url) ->
    url = url or "/"
    $location.path url
  service =
    login: (email, password) ->
      $http.post("/api/login",
        user:
          email: email
          password: password
      ).then (response) ->
        service.currentUser = response.data.user

        #$location.path(response.data.redirect);
        $location.path "/profile"  if service.isAuthenticated()


    logout: (redirectTo) ->
      $http.post("/api/logout").then ->
        service.currentUser = null
        redirect redirectTo


    register: (email, password, confirm_password) ->
      $http.post("/users.json",
        user:
          email: email
          password: password
          password_confirmation: confirm_password
      ).then (response) ->
        service.currentUser = response.data
        $location.path "/profile"  if service.isAuthenticated()


    requestCurrentUser: ->
      if service.isAuthenticated()
        $q.when service.currentUser
      else
        $http.get("/api/current_user").then (response) ->
          service.currentUser = response.data.user
          service.currentUser


    currentUser: null
    isAuthenticated: ->
      !!service.currentUser

  service
)