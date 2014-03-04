
 express       = require('express')
 routes        = require('./routes/index.js.coffee')
 masterplayAPI = require('./routes/masterplayAPI.js.coffee')
 http          = require('http')
 path          = require('path')
 supervisor    = require('supervisor')
 events        = require('events')
 fs            = require('fs')
 eventsEmitter = new events.EventEmitter();

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
 application.get('/users/:id', masterplayAPI.user)
 application.post('/users',masterplayAPI.addUser)
 application.patch('/users/:id',masterplayAPI.updateUser)
 application.delete('/users/:id',masterplayAPI.removeUser)

 mainLoop = ->
    console.log("Starting application")
    eventsEmitter.emit('ApplicationStart')
    console.log "Running application"
    eventsEmitter.emit('ApplicationRun')
    console.log "Stoping application"
    eventsEmitter.emit('ApplicationStop')


 createDatabaseDirCallback = (exception) ->
   if exception
     console.error(exception)
     console.log(exception.message)
   else
     console.log('Directory created')

 onApplicationStart = ->
   console.log "Handling application start events"
   fs.exists('databases.conf',(value) ->
     if value is true
       console.log("File database.conf already exists")
     else
       fs.mkdir('databases.conf',createDatabaseDirCallback)
   )



 onApplicationRun = ->
   console.log "Handling application running events"

 onApplicationStop = ->
   console.log "Handling application stop events"

 eventsEmitter.on "ApplicationStart", onApplicationStart
 eventsEmitter.on "ApplicationRun",   onApplicationRun
 eventsEmitter.on "ApplicationStop",  onApplicationStop

 workingapp = ->
   console.log("This application is working perfectly")

 server = http.createServer(application).listen(application.get('port'), (error) ->
      if error
        throw error
      else
        console.log "Express server listening on port #{application.get('port')}"
        mainLoop()
        setInterval(workingapp,30000)

 )


