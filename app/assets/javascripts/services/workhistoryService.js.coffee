ShyneService.factory('Workhistory', ['$location','$http','$q',($location, $http, $q) ->

  createWorkHistory: (history_model, mentor_id) ->
    deferred = $q.defer()

    $http.post('/api/mentors/'+mentor_id+'/work_histories',
      work_history:
        title: history_model.current_title,
        company: history_model.current_company,
        date_started: "#{history_model.startedCurrentMonthOption.id} #{history_model.startedCurrentYearOption}",
        current_work: true,
        mentor_id: mentor_id
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  addWorkHistoryDetail: (history_model, mentor_id) ->
    deferred = $q.defer()

    $http.post('/api/mentors/'+mentor_id+'/work_histories',
      work_history:
        title: history_model.previous_title_text,
        company: history_model.previous_company_text,
        date_started: "#{history_model.startedPreviousMonthOption.id} #{history_model.startedPreviousYearOption}",
        date_ended: "#{history_model.endedPreviousMonthOption.id} #{history_model.endedPreviousYearOption}",
        current_work: false,
        mentor_id: mentor_id
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  getWorkHistories: (mentor_id) ->
    deferred = $q.defer()

    $http.get('/api/mentors/'+mentor_id+'/work_histories').success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  getIndustries: () ->
    deferred = $q.defer()

    $http.get('/api/industries').success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  addWorkHistory: (history_model, mentor_id) ->
    deferred = $q.defer()

    $http.post('/api/mentors/'+mentor_id+'/work_histories',
      work_history:
        title: history_model.title,
        company: history_model.company,
        date_started: "#{history_model.started_month} #{history_model.started_year}",
        date_ended: (if history_model.current_work == false then "#{history_model.ended_month} #{history_model.ended_year}" else ""),
        current_work: history_model.current_work,
        mentor_id: mentor_id
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  updateWorkHistory: (history_model, mentor_id, work_id) ->
    deferred = $q.defer()

    $http.put('/api/mentors/' + mentor_id + '/work_histories/' + work_id,
      work_history:
        title: history_model.title,
        company: history_model.company,
        date_started: "#{history_model.started_month} #{history_model.started_year}",
        date_ended: (if history_model.ended_month then "#{history_model.ended_month} #{history_model.ended_year}" else ""),
        current_work: history_model.current_work,
        mentor_id: mentor_id
    ).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise

  deleteWorkHistory: (mentor_id, work_id) ->
    deferred = $q.defer()

    $http.delete('/api/mentors/' + mentor_id + '/work_histories/' + work_id).success((data) ->
      deferred.resolve(data)
    ).error((data) ->
      deferred.reject(data.error)
    )
    deferred.promise
])