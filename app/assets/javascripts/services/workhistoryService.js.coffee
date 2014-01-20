ShyneService.factory('Workhistory', ['$location','$http','$q',($location, $http, $q) ->

  createWorkHistory: (history_model, mentor_id) ->
    deferred = $q.defer()

    $http.post('/api/mentors/'+mentor_id+'/work_histories',
      work_history:
        title: history_model.current_title,
        company: history_model.current_company,
        year_started: history_model.current_year_started,
        current_work: true,
        mentor_id: mentor_id
    )
    
    $http.post('/api/mentors/'+mentor_id+'/work_histories',
      work_history:
        title: history_model.previous_title,
        company: history_model.previous_company,
        year_started: history_model.previous_year_started,
        year_ended: history_model.previous_year_ended,
        current_work: false,
        mentor_id: mentor_id
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