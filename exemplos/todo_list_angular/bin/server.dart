import 'package:redstone/server.dart' as app;
import 'package:shelf_static/shelf_static.dart';
import 'package:di/di.dart';

import 'package:todo_list_angular/server/authentication.dart';
import 'package:todo_list_angular/server/database.dart';

@app.Install(urlPrefix: "/services")
import 'package:todo_list_angular/server/user.dart';

@app.Install(urlPrefix: "/services")
import 'package:todo_list_angular/server/todo.dart';

main() {

  //configurando conexão com o banco de dados
  var dbUri = "mongodb://localhost/tutorial";
  var poolSize = 3;
    
  app.addModule(new Module()
                  ..bind(MongoDbPool, toValue: new MongoDbPool(dbUri, poolSize)));
  
  //configurando acesso a arquivos estáticos (html, js, css...)
  app.setShelfHandler(createStaticHandler("web", 
                                          defaultDocument: "index.html", 
                                          serveFilesOutsidePath: true));
  //configurando log
  app.setupConsoleLog();
  
  app.start();
  
}