angular.module('myApp.controllers', [])

  .controller "ModalInstanceCtrl", [
    '$scope'
    '$modalInstance'
    'rumor'
    'flash'

    ($scope, $modalInstance, rumor, flash) ->
      $scope.rumor = rumor
      $scope.ok = ->
        $modalInstance.close $scope.selected.item

      $scope.cancel = ->
        $modalInstance.dismiss "cancel"

      $scope.update_rumor = () ->
        $scope.rumor.put().then (response) ->
          if response
            flash.success = 'Rumor updated!'

    ]


  .controller 'rumorCtrl', [
    '$scope'
    'RumorService'
    'StatusService'
    ($scope, RumorService, StatusService) ->

      $scope.get_statuses = () ->
        StatusService.getList().then (statuses) ->            
          $scope.statuses  = statuses[[0]]
          $scope.urgencies = statuses[[1]]

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
      $scope.loader = loading: false
      $scope.instructions = true
      $scope.get_surveys  = () ->
        SurveyService.getList().then (surveys) ->
          $scope.surveys  = surveys
          if !!surveys[0]
            $scope.selected = surveys[0].node
            $scope.get_diagram surveys[0].node

      $scope.get_diagram = (node) ->
        $scope.loader.loading = true
        $scope.selected  = node
        DiagramService.getList(node: node).then (diagram) ->
          $scope.loader.loading = false
          $scope.nodes   = diagram[0]
          $scope.node    = node

      $scope.get_surveys()

  ]