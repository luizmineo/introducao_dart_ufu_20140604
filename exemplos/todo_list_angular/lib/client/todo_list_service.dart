library todo_list_service;

import 'dart:async';
import 'dart:convert';

import 'package:angular/angular.dart';

import 'package:todo_list_angular/client/task.dart';

@Injectable()
class TodoListService {
  
  final Http _http;
  
  TodoListService(this._http);
  
  Future<List<Task>> getList() {
    return _http.get("/services/todo/list").then((HttpResponse resp) {
      return new List.from(resp.data.map((t) {
        var task = new Task();
        task.fromJson(t);
        return task;
      }));
    });
  }
  
  Future<String> addTask(String description) {
    return _http.post("/services/todo/add", JSON.encode({
      "task": description
    })).then((HttpResponse resp) {
      return resp.data["id"];
    });
  }
  
  Future<Task> setState(Task task) {
    return _http.post("/services/todo/setstate", 
        JSON.encode(task.toJson())).then((resp) => task);
  }
}