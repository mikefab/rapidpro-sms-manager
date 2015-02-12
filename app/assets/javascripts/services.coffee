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