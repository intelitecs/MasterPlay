
# GET: /  ---- index home page
exports.index = (request, response) ->
  response.render('index',{title: 'MasterPlay application'})

