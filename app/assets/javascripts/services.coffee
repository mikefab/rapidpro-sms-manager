angular.module('myApp.services', [])

  .factory 'SurveyService', [
    'Restangular'
    (Restangular) ->
      Restangular.service 'surveys'
  ]

  .factory 'DiagramService', [
    'Restangular'
    (Restangular) ->
      Restangular.service 'diagrams'
  ]

  .factory 'RumorService', [
    'Restangular'
    (Restangular) ->
      Restangular.service 'rumors'
  ]  

  .factory 'StatusService', [
    'Restangular'
    (Restangular) ->
      Restangular.service 'statuses'
  ] 