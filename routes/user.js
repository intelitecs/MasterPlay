var mongo = require('mongodb'),
    format = require('util').format,
    ObjectID = require('mongodb').ObjectID;
console.log("Mongo version: "+mongo.version);

var Server = mongo.Server,
	Db = mongo.Db,
	BSON = mongo.BSONPure;
var server = new Server('localhost',27017,{auto_reconnect: true})
db = new Db('masterplay',server,{safe: false});

db.open(function(error, db){
	"use strict";
	if(error){
		console.log(error.message);
	}else{
		console.log("connected to database masterplay.");
		var users = [
			{nom: "Saccareau", prenom: "Alexandre", pays: "France", region: "Midi Pyrénés", passion:"Développement jeux video, sous les plateformes windows"},
			{nom: "Zago", prenom:"Jarode", pays: "Côte d'ivoire", region: "Région des lac",passion:"Algorimique"},
			{nom: "Dare", prenom: "Alaric", pays: "France", region: "Pyrénés Ariègeoise", passion: "Développement .NET"},
			{nom: "Le Fourn", prenom: "Alexandre", pays: "France", region: "Midi Pyrénés", passion: "Développement .NET"}
		];
		var collection = db.collection('users');
		collection.insert(users, function(error, documents){
			if(error){
				console.log(error.message);
			}
			collection.count(function(error, count){
				console.log(format("count: %s", count));
				//db.close();
			});
		});

		//db.close();

	}
});



exports.userFindAll = function(request, response){
    "use strict";

	db.collection("users",{},function(error, collection){
		collection.find().toArray(function(error,users){
			if(error){
				console.log(error.message);
			}else{
				response.render('users/index',{title: "Membres de l'équipe développement" ,users: users});
			}
		});
	});


}


exports.findUserById = function(request, response){
    "use strict";
    var id = ObjectID.createFromHexString(request.params.id);
    //console.log();
    console.log("retrieving user: "+ id);
    db.collection('users',{'_id': id}, function(error, user){
        if(error){
            console.log(error.message);
        }else{
            response.send({user: user});
        }
    });
}


exports.addUser = function(request, response){
    "use strict";
    response.header("Access-Control-Allow-Origin","*");
    response.header("Access-Control-Allow-Headers","X-Requested-With");
    var nom = request.body.nom,
        prenom = request.body.prenom,
        pays = request.body.pays,
        region = request.body.region,
        passion = request.body.passion;

    //on pourrait faire de la validation ici


    var user = {nom: nom, prenom: prenom, pays: pays, region: region, passion: passion};
    console.log("Creating user: "+ JSON.stringify(user,function(err,result){
        if(err){
            throw err;
        }
    }));
    db.collection('users', {}, function(error, collection){
        collection.insert(user, {safe: true}, function(error, result){
            if(error){
                response.send({'error':'An error has occurred -> '+ error.message});
            }else{
                console.log('Success: '+ JSON.stringify(result[0]));
                response.send({user: result[0]});
            }
        });
    });
};


exports.updateUser = function(request,response){
    "use strict";
    var id    =  request.params.id,
        user  =  {nom: request.body.nom, prenom: request.body.prenom,
                  pays: request.body.pays, region: request.body.region, passion: request.body.passion};
    console.log("Updating user: "+ id);
    console.log(JSON.stringify(user));

    db.collection("users",{},function(error, collection){
         collection.update({'__id':new BSON.ObjectID(id)},user,{safe: true},function(error, result){
             if(error){
                 console.log("Error updating user: "+error.message);
                 response.send({'error': error.message, 'code':error.code});
             }else{
                 console.log('' + result + 'document (s) updated');
                 response.send(user);
             }
         });
    });

}

exports.deleteUser = function(request,response){
    "use strict";
    var id = request.params.id;
    console.log("Deleting user: "+ id);
    db.collection('users',{},function(error, collection){
        if(error){
            console.log("Error to find the collection");
        }else{
            collection.remove({_id: BSON.ObjectID(id)},{safe: true},function(error, result){
                if(error){
                    console.log("Error occurred when deleting document");
                    response.send({'error': error.message, 'code': error.code});
                }else{
                    console.log(''+result + ' document(s) deleted');
                    response.send(request.body);
                }
            });
        }
    });
}






/*
exports.create = function(request, response) {
    response.header("Access-Control-Allow-Origin","*");
    response.header("Access-Control-Allow-Headers","X-Requested-With");
    // Create a new User model fill it up and save it to Mongodb
    var user = new User();
    user.pseudo = request.params.pseudo;
    user.resume = request.params.resume;
    user.date   = request.params.date;

    user.save(function(error){
        "use strict";
        if(error){
            response.send(request.body, error.code, error.message);
        }else{
            response.send(request.body);
        }
    });

}

*/
