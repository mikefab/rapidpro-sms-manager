angular.module('myApp.directives', [])

  .directive 'diagram', () ->
    restrict: 'E'
    scope:
      nodes: '=',
    link: ($scope, $el, $attrs) ->

      $scope.$watch 'nodes', (nodes) -> #I change here
        buildGraph nodes if !!nodes


      # Helpers.
      # --------

      buildGraph = (data) ->

        flare = get_flare data.links


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
            attrs: text: text: ''
          } ]
          connector: name: 'smooth')
        #}
        lnk


      break_lines = (text) ->
        text  = text.split(/\s+/)
        str = ""
        i = 0

        while i < text.length
          str += "\n"  if (i + 1) % 5 is 0
          str += " " + text[i]
          i++
 
        return str

      makeElement = (node) ->
        text = (node.label || ( if node.text then node.text) || "") 
        text = break_lines text
        text = text + "\n\nhits: " + node.hits + "\n\n"
        if !!node.responses
          text = text + "Responses:\n\n"
          _.each node.responses, (r) ->
            text = text + break_lines(r[0]) + ", " + r[1] + "\n\n"

        maxLineLength = _.max(text.split('\n'), (l) ->
          l.length
        ).length
        # Compute width/height of the rectangle based on the number
        # of lines in the label and the letter size. 0.6 * letterSize is
        # an approximation of the monospace font letter width.
        letterSize = 12

        width = 2 * letterSize * (0.3 * maxLineLength + 1)
        height = 1 * (text.split('\n').length + 1) * letterSize



        new joint.shapes.basic.Rect(
          id: node.id
          size:
            width: width
            height: height
          attrs:
            name:      node.name
            label:     node.label
            hits:      node.hits
            message:   node.text
            responses: node.responses
            text:
              text: text
              'font-size': letterSize
              'font-family': 'monospace'
            rect:
              width: width
              height: height
              rx: 5
              ry: 5
              stroke: '#555')



      # Main.
      # -----
      graph = new (joint.dia.Graph)
      paper = new (joint.dia.Paper)(
        el: $el[0]
        width: 1500
        height: 5000
        gridSize: 1
        model: graph)
      # Just give the viewport a little padding.

      # paper.on "cell:mouseover", (cellView, evt, x, y) ->
      #   $scope.$apply("")
      #   $scope.$parent.node    = cellView.model.attributes.attrs.name
      #   $scope.$parent.message = cellView.model.attributes.attrs.message
      #   $scope.$parent.label   = cellView.model.attributes.attrs.label
      #   $scope.$parent.hits    = cellView.model.attributes.attrs.hits
      #   $scope.$parent.responses = cellView.model.attributes.attrs.responses
      #   $scope.$parent.instructions = false

      layout = (nodes) ->
        try
          dataList = nodes
        catch e
          alert e
        cells = buildGraph(dataList)
        graph.resetCells cells
        joint.layout.DirectedGraph.layout graph,
          setLinkVertices: false

          nodeSep: 20
          rankSep: 20
        return

      V(paper.viewport).translate 20, 20

      $scope.$watch 'nodes', (nodes) -> #I change here
        layout(nodes) if !!nodes


      # generated by js2coffee 2.0.1

      get_flare = (links) ->
        source_h = {} # hash of source nodes
        target_h = {} # hash of target nodes


        _.each links, (l) ->
          target_h[l.target] = 1
          if source_h[l.source]
            source_h[l.source].push l.target
          else
            source_h[l.source] = [l.target]

        root = get_root(source_h, target_h)

        flare = {name: root, children: [_.uniq source_h[root]]}
        # console.log flare
        # _.each _.keys(source_h), (k) ->
        #   _.each _.keys(source_h), (k2) ->
        #     #console.log $.inArray(k, source_h[k2])        console.log root


      get_root = (sources, targets) ->
        root = String
        _.each _.keys(sources), (k) ->
          root = k unless targets[k]
        root