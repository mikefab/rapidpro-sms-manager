angular.module('myApp.controllers', [])

  .controller "ModalInstanceCtrl", [
    '$scope'
    '$modalInstance'
    'rumor'

    ($scope, $modalInstance, rumor) ->
      console.log rumor
      $scope.rumor = rumor
      $scope.ok = ->
        $modalInstance.close $scope.selected.item

      $scope.cancel = ->
        $modalInstance.dismiss "cancel"
    ]



  .controller "oneCtrl", ($scope, $timeout) ->
    $scope.list1 = []
    $scope.list2 = []
    $scope.list3 = []
    $scope.list4 = []
    $scope.list5 = [
      title: "Item 1"
      drag: true
    ,
      title: "Item 2"
      drag: true
    ,
      title: "Item 3"
      drag: true
    ,
      title: "Item 4"
      drag: true
    ,
      title: "Item 5"
      drag: true
    ,
      title: "Item 6"
      drag: true
    ,
      title: "Item 7"
      drag: true
    ,
      title: "Item 8"
      drag: true
     ]
    
    # # Limit items to be dropped in list1
    # $scope.optionsList1 = accept: (dragEl) ->
    #   if $scope.list1.length >= 2
    #     false
    #   else
    #     true




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