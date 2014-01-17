ShyneService.factory('Workhistory', ['$location','$http','$q',($location, $http, $q) ->

  createWorkHistory: (current_title, current_company, current_date_started, previous_title, previous_company, previous_date_started, previous_date_ended, industries, programs, user) ->
    deferred = $q.defer()

    $http.post('/api/mentors/'+user.role_id+'/work_histories',
      work_history:
        title: current_title,
        company: current_company,
        current_work: true,
        mentor_id: user.role_id,
    )
    
    $http.post('/api/mentors/'+user.role_id+'/work_histories',
      work_history:
        title: previous_title,
        company: previous_company,
        current_work: false,
        mentor_id: user.role_id,
    ).success((data)->
      if data.id
        deferred.resolve(angular.extend(data))
      else
        deferred.reject(data.errors)
    ).error((data)->
      deferred.reject(data.errors)
    )    

    deferred.promise

])