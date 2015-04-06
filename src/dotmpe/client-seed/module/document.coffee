# jrc:export dotmpe/client-seed/document
# jrc:import jquery

( $ ) ->

  m = title: 'Client Seed .mpe - Document'

  console.log m.title

  getDocHeight = (doc) ->
    doc = doc || document
    body = doc.body
    html = doc.documentElement
    Math.max( body.scrollHeight, body.offsetHeight,
      html.clientHeight, html.scrollHeight, html.offsetHeight )

  setSource = ->
    docpath = $('[name=docpath]').val()
    format = $('[name=format]').val()
    url = '/data/project/document?' +
      $.param docpath: docpath, format: format

    $('#viewer')
      .attr('src', url)
      .height('25em')

  $(document).ready ->

    $('[name=format]').on('change', ->
      console.log('format change')
      setSource()
    )

    setSource()

  m

