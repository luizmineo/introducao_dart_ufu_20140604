import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:todo_list_angular/client/todo_list_service.dart';
import 'package:todo_list_angular/client/todo_list_controller.dart';

class TodoListModule extends Module {
  
  TodoListModule() {
    bind(TodoListService);
    bind(TodoListController);
  }
}

main() {
  
  applicationFactory()
      .addModule(new TodoListModule())
      .run();
  
  setLogoutHandler();
  
}

setLogoutHandler() {
  var logoutBtn = querySelector("#logoutBtn");
  logoutBtn.onClick.listen((MouseEvent event) {
    HttpRequest.request("/logout").then((req) {
      window.location.href = "/login.html";
    });
    event.preventDefault();
  });
}