library user;

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_list_angular/server/utils.dart';

@app.Route("/newuser", methods: const[app.POST])
addUser(@app.Attr() Db dbConn, @app.Body(app.JSON) Map json) {
  
  String name = json["name"].trim();
  String username = json["username"].trim();
  String password = json["password"].trim();
  
  var userCollection = dbConn.collection("user");
  return userCollection.findOne({"username": username}).then((value) {
    if (value != null) {
      return {"success": false, "error": "USER_EXISTS"};
    }
    
    var user = {
      "name": name,
      "username": username,
      "password": encryptPassword(password)
    };
    
    return userCollection.insert(user).then((resp) => {"success": true});
  });
}