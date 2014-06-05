library authentication;

import 'dart:io';

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todo_list/utils.dart';

@app.Interceptor(r'/services/todo/.+')
authServicesFilter() {
  if (app.request.session["username"] == null) {
    app.chain.interrupt(statusCode: HttpStatus.UNAUTHORIZED, responseValue: {"error": "NOT_AUTHENTICATED"});
  } else {
    app.chain.next();
  }
}

@app.Interceptor(r'/')
authViewFilter() {
  if (app.request.session["username"] == null) {
    app.redirect("/login.html");
  } else {
    app.chain.next();
  }
}

@app.Route("/login", methods: const[app.POST])
login(@app.Attr() Db dbConn, @app.Body(app.JSON) Map body) {
  var userCollection = dbConn.collection("user");
  if (body["username"] == null || body["password"] == null) {
    return {"success": false, "error": "WRONG_USER_OR_PASSWORD"};
  }
  var pass = encryptPassword(body["password"].trim());
  return userCollection.findOne({"username": body["username"], "password": pass})
      .then((user) {
        if (user == null) {
          return {
            "success": false,
            "error": "WRONG_USER_OR_PASSWORD"
          };
        }
        
        var session = app.request.session;
        session["username"] = user["username"];
        
        return {"success": true};
      });
}

@app.Route("/logout")
logout() {
  app.request.session.destroy();
  return {"success": true};
}