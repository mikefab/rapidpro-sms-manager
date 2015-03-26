angular.module('myApp.controllers', [])

  .controller 'rumorCtrl', [
    '$scope'
    'RumorService'
    'StatusService'
    ($scope, RumorService, StatusService) ->

      $scope.get_statuses = () ->
        StatusService.getList().then (statuses) ->            
          $scope.statuses = statuses


          $scope.groups = _.map statuses, (obj) ->
            obj.name

      $scope.get_rumors  = () ->
        RumorService.getList().then (rumors) ->
          $scope.rumors  = rumors


      $scope.get_statuses().then () ->
        $scope.get_rumors()

  ]

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