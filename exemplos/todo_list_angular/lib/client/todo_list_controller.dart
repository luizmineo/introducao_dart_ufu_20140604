library todo_list_controller;

import 'dart:html';

import 'package:angular/angular.dart';

import 'package:todo_list_angular/client/todo_list_service.dart';
import 'package:todo_list_angular/client/task.dart';

@Controller(selector: '[todo-list]',
            publishAs: 'ctrl')
class TodoListController {
  
  final TodoListService service;
  
  String newTask = "";
  
  List<Task> tasks = [];
  
  TodoListController(this.service) {
    service.getList().then((tasks) => this.tasks = tasks);
  }
  
  addTask(MouseEvent event) {
    if (!newTask.isEmpty) {
      service.addTask(newTask).then((id) {
        tasks.add(new Task(id, newTask, false));
      });
    }
    event.preventDefault();
  }
  
  changeState(Task task) {
    task.checked = !task.checked;
    service.setState(task);
  }
}