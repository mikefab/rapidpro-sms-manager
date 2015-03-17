angular.module('myApp.controllers', [])
  .controller 'surveyCtrl', [
    '$scope'
    '$http'
    'SurveyService'
    'DiagramService'
    ($scope, $http, SurveyService, DiagramService) ->

      $scope.instructions = true
      $scope.get_surveys  = () ->
        SurveyService.getList().then (surveys) ->
          $scope.surveys  = surveys
          if !!surveys[0]
            $scope.selected = surveys[0].node
            $scope.get_diagram surveys[0].node

      $scope.get_diagram = (node) ->
        $scope.selected  = node
        DiagramService.getList(node: node).then (diagram) ->
          $scope.nodes   = diagram[0]
          $scope.node    = node

      $scope.get_surveys()

  ]