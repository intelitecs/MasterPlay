mongoose  = require('mongoose')
mongo     = require('mongodb')
BSON     = require('bson')

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
      response.json({error: true})
    else
      #response.render('users/index',{title: 'Liste des utilisateurs', users: users})

      response.json(users)
  )

#GET: /users/:id
exports.userByIdInArray = (request,response) ->
  User.find(null, (error,users) ->
    if(error)
      response.json({erro: true})
    else
      response.json(users[request.params.id])


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
    ##mongoose.connection.close()



#GET  /users/:id
exports.user = (request, response) ->
  User.findById(request.params.id,(error,user) ->
    if error
      console.error(error)
    else
      response.json(user)

  )


# PUT : /users/:id
exports.updateUser = (request, response) ->
  User.find(null, (error, users) ->
    if error
      console.error(error.message);
    else
      userToUpdate = users[request.params.id]
      userToUpdate.nom     = request.body.nom
      userToUpdate.prenom  = request.body.prenom
      userToUpdate.pays    = request.body.pays
      userToUpdate.region  = request.body.region
      userToUpdate.passion = request.body.passion

      User.update(userToUpdate,(error,user) ->
        if error
          console.error(error)
        else
          response.json(user);
      )
      #response.send({title: "User found successfully", user: users[0]})
  )


#Delete : /users/:1
exports.removeUser = (request, response) ->
  User.find(null, (error, users) ->
    if(error)
      console.error(error)
    else
      User.remove(users[request.params.id], (error, result) ->
        if error
          console.error(error)
        else
          response.json({success: true})
      )

  )





