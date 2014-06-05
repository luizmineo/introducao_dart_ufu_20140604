import 'dart:html';
import 'dart:convert';

var logoutBtn = querySelector("#logoutBtn");

var newtask = querySelector("#newtask");
var newtaskBtn = querySelector("#newtaskBtn");
var taskList = querySelector("#taskList");

Map<String, bool> tasks = {};

main() {
  
  newtaskBtn.onClick.listen((MouseEvent event) {
    addNewTask();
    event.preventDefault();
  });
  
  listTasks();
  
  logoutBtn.onClick.listen((MouseEvent event) {
    HttpRequest.request("/logout").then((req) {
      window.location.href = "/login.html";
    });
    event.preventDefault();
  });
}

listTasks() {
  HttpRequest.request("/services/todo/list").then((req) {
    var taskList = JSON.decode(req.response);
    taskList.forEach((task) {
      createTaskElement(task["id"], task["task"], task["checked"]);
    });
  });
}

addNewTask() {
  var task = newtask.value.trim();
  if (!task.isEmpty) {
    HttpRequest.request("/services/todo/add", method: "POST", requestHeaders: {
      "content-type": "application/json"
    }, sendData: JSON.encode({
      "task": task
    })).then((req) {
      var resp = JSON.decode(req.response);
      createTaskElement(resp["id"], task, false);
    });
  }
}

checkTask(String taskId, String taskElementId, String task) {
  bool checked = !tasks[taskElementId];
  
  HttpRequest.request("/services/todo/setstate", method: "POST", requestHeaders: {
    "content-type": "application/json"
  }, sendData: JSON.encode({
    "id": taskId,
    "checked": checked
  }));
  
  var status = getStatusElement(checked);
  querySelector("#$taskElementId").innerHtml = "$task$status";
  
  tasks[taskElementId] = checked;
}

int nextElementId = 0;

createTaskElement(String taskId, String task, bool checked) {
  var taskElementId = "task${nextElementId++}";
  var status = getStatusElement(checked);
  
  tasks[taskElementId] = checked;
  
  taskList.appendHtml('<li class="list-group-item" id="$taskElementId">$task$status </li>');
  
  querySelector("#$taskElementId").onClick.listen((_) {
    checkTask(taskId, taskElementId, task);
  });
}

getStatusElement(bool checked) {
  if (checked) {
    return '<span class="pull-right glyphicon glyphicon-ok-sign checked"></span>';
  } else {
    return '<span class="pull-right glyphicon glyphicon-question-sign unchecked"></span>';
  }
}