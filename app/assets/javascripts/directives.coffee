angular.module('myApp.directives', [])
  .directive 'diagram', () ->
    restrict: 'E'
    scope:
      nodes: '=',
    link: ($scope, $el, $attrs) ->



      # Helpers.
      # --------

      buildGraph = (data) ->
        elements = []
        links = []
        _.each data.nodes, (node) ->
          elements.push makeElement(node)
          return
        _.each data.links, (edge) ->
          links.push makeLink(edge)
          return
        elements.concat links

      joint.layout.DirectedGraph =
        layout: (graph, opt) ->
          opt = opt or {}
          dGraph = new (dagre.graphlib.Graph)

          ###    var dGraph = new dagre.graphlib.Graph({ multigraph: true })###

          inputGraph = @_prepareData(graph, dGraph)
          runner = dGraph.setGraph({})
          if opt.debugLevel
            runner.debugLevel opt.debugLevel
          if opt.rankDir
            inputGraph.graph().rankdir = opt.rankDir
          if opt.rankSep
            inputGraph.graph().rankSep = opt.rankSep
          if opt.edgeSep
            inputGraph.graph().edgeSep = opt.edgeSep
          if opt.nodeSep
            inputGraph.graph().nodeSep = opt.nodeSep
          if opt.rankSep
            inputGraph.graph().rankSep = opt.rankSep
          layoutGraph = dagre.layout(inputGraph)
          inputGraph.nodes().forEach (u) ->
            value = inputGraph.node(u)
            if !value.dummy
              cell = graph.getCell(u)
              if opt.setPosition then opt.setPosition(cell, value) else graph.get('cells').get(u).set('position',
                x: value.x - (value.width / 2)
                y: value.y - (value.height / 2))
            return
          if opt.setLinkVertices
            inputGraph.edges().forEach (e) ->
              e_label = inputGraph.edge(e.v, e.w)
              link = graph.getCell(e_label)
              if link
                if opt.setVertices then opt.setVertices(link, value.points) else link.set('vertices', value.points)
              return
          {
            width: runner.graph().width
            height: runner.graph().height
          }
        _prepareData: (graph, dagre_graph) ->
          dagreGraph = dagre_graph
          # For each element.
          _.each graph.getElements(), (cell) ->
            if dagreGraph.hasNode(cell.id)
              return
            dagreGraph.setNode cell.id.toString(),
              width: cell.get('size').width
              height: cell.get('size').height
              rank: cell.get('rank')
            return
          # For each link.
          _.each graph.getLinks(), (cell) ->
            if dagreGraph.hasEdge(cell.id)
              return
            sourceId = cell.get('source').id.toString()
            targetId = cell.get('target').id.toString()
            dagreGraph.setEdge sourceId, targetId,
              label: cell.id
              minLen: cell.get('minLen') or 1
            return
          dagreGraph

      makeLink = (edge) ->

        ###  if (edge.source.toString() == "2") {
            var lnk = new joint.dia.Link({
              source: { id: edge.source.toString() },
              target: { x: 25, y: 25 },
              attrs: {
                '.marker-target': { d: 'M 4 0 L 0 2 L 4 4 z' }
              },
              labels: [{
                position: 0.5,
                attrs: {
                  text: {
                    text: "on"
                  }
                }
              }],
              connector: {name: 'smooth'}
          });
            lnk.transition('target', { x: 250, y: 250 }, {
              delay: 100,
              duration: 1000,
              timingFunction: joint.util.timing.bounce,
              valueFunction: joint.util.interpolate.object
            });
          } else {
        ###

        lnk = new (joint.dia.Link)(
          source: id: edge.source.toString()
          target: id: edge.target.toString()
          attrs: '.marker-target': d: 'M 4 0 L 0 2 L 4 4 z'
          labels: [ {
            position: 0.5
            attrs: text: text: 'on'
          } ]
          connector: name: 'smooth')
        #}
        lnk

      makeElement = (node) ->
        maxLineLength = _.max(node.name.split('\n'), (l) ->
          l.length
        ).length
        # Compute width/height of the rectangle based on the number
        # of lines in the label and the letter size. 0.6 * letterSize is
        # an approximation of the monospace font letter width.
        letterSize = 12
        width = 2 * letterSize * (0.6 * maxLineLength + 1)
        height = 2 * (node.name.split('\n').length + 1) * letterSize
        new (joint.shapes.basic.Rect)(
          id: node.id.toString()
          size:
            width: 100
            height: height
          attrs:
            text:
              text: node.label + " " + node.hits 
              'font-size': letterSize
              'font-family': 'monospace'
            rect:
              width: width
              height: height
              rx: 5
              ry: 5
              stroke: '#555')

      # ---
      # generated by js2coffee 2.0.1



      # Main.
      # -----
      graph = new (joint.dia.Graph)
      paper = new (joint.dia.Paper)(
        el: $el[0]
        width: 1900
        height: 400
        gridSize: 1
        model: graph)
      # Just give the viewport a little padding.

      layout = (nodes) ->
        try
          dataList = nodes
        catch e
          alert e
        cells = buildGraph(dataList)
        graph.resetCells cells
        joint.layout.DirectedGraph.layout graph,
          setLinkVertices: false
          rankDir: 'lr'
          nodeSep: 50
          rankSep: 50
        return

      V(paper.viewport).translate 20, 20

      $scope.$watch 'nodes', (nodes) -> #I change here
        layout(nodes) if !!nodes


      #layout($scope.xxx)
      # ---
      # generated by js2coffee 2.0.1