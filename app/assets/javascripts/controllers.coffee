angular.module('myApp.controllers', [])
  .controller 'surveyCtrl', [
    '$scope'
    '$http'
    'SurveyService'
    'DiagramService'
    ($scope, $http, SurveyService, DiagramService) ->
      $scope.get_surveys = () ->
        SurveyService.getList().then (surveys) ->
          $scope.surveys = surveys

      $scope.get_diagram = (node) ->
        DiagramService.getList(node: node).then (diagram) ->
          $scope.nodes = diagram[0]

      $scope.get_surveys()
  ]