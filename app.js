
/**
 * Module dependencies.
 */


var  express = require('express'),
     routes = require('./routes'),
     user = require('./routes/user'),
     http = require('http'),
     path = require('path'),
     supervisor = require('supervisor');

//var restify = require('restify');
//var masterplaydb = require('./db/masterplaydb');






var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(express.cookieParser('your secret here'));
app.use(express.session());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));
app.use(supervisor);


// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', routes.index);

app.get('/users', user.userFindAll);
app.get('/users/:id([0-9a-f]{24})',user.findUserById);
app.patch('/users/:id([0-9a-f]{24})',user.updateUser);
app.post('/users',user.addUser);
app.delete('/users/:id([0-9a-f]{24})',user.deleteUser);

app.get('/chat', function(request, response, next){
    "use strict";
    response.render('chat/index');
});



var server = http.createServer(app).listen(app.get('port'), function(error){
  if(error){
      throw error;
  }else{
      console.log('Express server listening on port ' + app.get('port'));

  }
});
var phrases = ["Greet socket.io testing", "Bon, on peut dire que l'on s'amuse","Mais tout ceci, reste du web"];

var IO = require('socket.io').listen(server);

IO.sockets.on('connection', function(socket){
    "use strict";
    var sendChat = function(title, text){
        socket.emit('chat', {title: title, content: text});
    };
    setInterval(function(){
        var randomNumber = Math.floor(Math.random()*phrases.length);
        sendChat('Message de jarode', phrases[randomNumber]);
    }, 5000);
    sendChat('message de vincent','Les dévlooppeurs Web, sont en tout cas heureux.');
    socket.on('chat', function(data){
        sendChat('You', data.text);
    });
});


