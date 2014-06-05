library task;

class Task {
  
  String id;
  String description;
  bool checked;
  
  Task([this.id, this.description, this.checked]);
  
  toJson() => {
    "id": id,
    "task": description,
    "checked": checked
  };
  
  fromJson(Map json) {
    id = json["id"];
    description = json["task"];
    checked = json["checked"];
  }
  
}