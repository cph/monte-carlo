class @Histogram

  constructor: (@data) ->

  render: ->
    formatCount = d3.format(",.0f")

    svg = d3.select("svg")
    margin =
      top: 10
      right: 30
      bottom: 30
      left: 30
    width = +svg.attr("width") - (margin.left) - (margin.right)
    height = +svg.attr("height") - (margin.top) - (margin.bottom)

    g = svg.append("g").attr("transform", "translate(#{margin.left},#{margin.top})")
    x = d3.scaleLinear()
      .rangeRound([0, width])
      .domain(d3.extent(@data))

    bins = d3.histogram()
      .domain(x.domain())
      .thresholds(x.ticks(20))(@data)

    y = d3.scaleLinear()
      .domain([0, d3.max(bins, (d) -> d.length)])
      .range([height, 0])

    y2 = d3.scaleLinear()
      .domain([0, 1])
      .range([height, 0])

    lineData = []
    total = 0
    for { x0, x1, length } in bins
      lineData.push
        x: x0 + (x1 - x0) / 2
        value: (total += length) / @data.length

    line = d3.line()
      .x((d)-> x(d.x))
      .y((d)-> y2(d.value))

    bar = g.selectAll(".bar")
      .data(bins)
      .enter()
        .append("g")
        .attr("class", "bar")
        .attr("transform", (d) -> "translate(#{x(d.x0)},#{y(d.length)})")

    bar.append("rect")
      .attr("x", 1)
      .attr("width", (d) => x(d.x1) - x(d.x0) - 1)
      .attr "height", (d) -> height - y(d.length)

    bar.append("text")
      .attr("dy", ".75em")
      .attr("y", 6)
      .attr("x", (x(bins[0].x1) - x(bins[0].x0)) / 2)
      .attr("text-anchor", "middle").text((d) -> formatCount(d.length))

    g.append("path")
      .datum(lineData)
      .attr("fill", "none")
      .attr("stroke", "orange")
      .attr("stroke-linejoin", "round")
      .attr("stroke-linecap", "round")
      .attr("stroke-width", 1.5)
      .attr("d", line)

    g.append("g")
      .attr("class", "axis axis--x")
      .attr("transform", "translate(0,#{height})").call d3.axisBottom(x)
