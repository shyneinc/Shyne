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
    $.each(history_model.positions, (key,valueObj) ->
      $http.post('/api/mentors/'+mentor_id+'/work_histories',
        work_history:
          title: valueObj.previous_title_text,
          company: valueObj.previous_company_text,
          year_started: valueObj.previous_year_started_text,
          year_ended: valueObj.previous_year_ended_text,
          current_work: false,
          mentor_id: mentor_id
      )      
    )    

])