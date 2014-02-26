
 express = require('express')
 routes  = require('./routes/index.js.coffee')
 masterplayAPI = require('./routes/masterplayAPI.js.coffee')
 http = require('http')
 path = require('path')
 supervisor = require('supervisor')

 application = express();

 # all environments
 application.set('port', process.env.PORT || 3000);
 application.set('views', path.join(__dirname, 'views'));
 application.set('view engine', 'jade');
 application.use(express.favicon());
 application.use(express.logger('dev'));
 application.use(express.json());
 application.use(express.urlencoded());
 application.use(express.methodOverride());
 application.use(express.cookieParser('your secret here'));
 application.use(express.session());
 application.use(application.router);
 application.use(express.static(path.join(__dirname, 'public')));
 application.use(supervisor)


 # development only

 if 'development' is application.get('env')
    application.use(express.errorHandler())

 application.get('/', routes.index)
 application.get('/users', masterplayAPI.allUsers)
 application.get('/users/:nom',masterplayAPI.findByByName)
 application.post('/users',masterplayAPI.addUser)

 ###

 application.get('/users/:id([0-9a-f]{24})',user.findUserById);
 application.patch('/users/:id([0-9a-f]{24})',user.updateUser);
 application.delete('/users/:id([0-9a-f]{24})',user.deleteUser);

 application.get '/chat',  (request, response, next) ->
   response.render 'chat/index'
###

 server = http.createServer(application).listen(application.get('port'), (error) ->
      if error
        throw error
      else
        console.log "Express server listening on port #{application.get('port')}"

 )


