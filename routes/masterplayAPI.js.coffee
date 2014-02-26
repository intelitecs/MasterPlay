mongoose  = require('mongoose')
mongo     = require('mongodb')

mongoose.connect("mongodb://localhost:27017/masterplay")
db = mongoose.connection;
db.on 'error', console.error.bind(console, "connection error")
db.on 'open', ->
    console.log("connection success")


#schemas definitions

# 1: userSchema
userSchema = mongoose.Schema({
  nom     :  {type  : String, default : '', trim: true},
  prenom  :  {type  : String, default : '', trim: true},
  pays    :  {type  : String, default : '', trim: true},
  region  :  {type  : String, default : '', trim: true},
  passion :  {type  : String, default : '', trim: true}
})

#user model
User = mongoose.model('User',userSchema);



# do all requests with the User model

#GET: /users
exports.allUsers = (request, response) ->
  User.find(null, (error, users) ->
    if(error)
      console.error(error)
    else
      response.render('users/index',{title: 'Liste des utilisateurs', users: users})
  )


# POST: /users
exports.addUser = (request, response) ->
  response.header("Access-Control-Allow-Origin","*")
  response.header("Access-Control-Allow-Headers","X-Requested-With")
  user = new User({
    nom     :  request.body.nom,
    prenom  :  request.body.prenom,
    pays    :  request.body.pays,
    region  :  request.body.region,
    passion :  request.body.passion
  })
  user.save (error,result) ->
    if error
      console.error(error)
    else
      console.log(result[0])
      response.render('users/index', {title: "User saved successfully", user: result[0]})


# GET : /users/:nom
exports.findByByName = (request, response) ->
  User.find({nom: request.params.nom}, (error, users) ->
    if error
      console.error(error.message);
    else
      response.send({title: "User found successfully", user: users[0]})
  )




# and finally close the connection
mongoose.connection.close();

