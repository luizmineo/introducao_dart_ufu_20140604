library todo;

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';
import 'package:uuid/uuid_server.dart';

@app.Group("/todo")
class TodoServices {
  
  Uuid uuid = new Uuid();
  
  @app.Route("/list")
  list(@app.Attr() Db dbConn) {
    var todoCollection = dbConn.collection("todo");
    return todoCollection.find({"user": app.request.session["username"]}).toList();
  }
  
  @app.Route("/add", methods: const [app.POST])
  add(@app.Attr() Db dbConn, @app.Body(app.JSON) Map json) {
    var todoCollection = dbConn.collection("todo");
    var id = uuid.v1();
    var todo = {
      "id": id,
      "user": app.request.session["username"],
      "task": json["task"],
      "checked": false
    };
    return todoCollection.insert(todo).then((_) => {"success": true, "id": id});
  }
  
  @app.Route("/setstate", methods: const [app.POST])
  setState(@app.Attr() Db dbConn, @app.Body(app.JSON) Map json) {
    var todoCollection = dbConn.collection("todo");
    var selector = {
      "user": app.request.session["username"],
      "id": json["id"]
    };
    var query = modify.set("checked", json["checked"]);
    return todoCollection.update(selector, query).then((_) => {"success": true});
  }
  
}