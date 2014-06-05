import 'dart:html';
import 'dart:convert';

//elementos login
var username = querySelector("#username");
var password = querySelector("#password");
var sendBtn = querySelector("#sendBtn");
var loginErrorPanel = querySelector("#loginErrorPanel");
var loginErrorMsg = querySelector("#loginErrorMsg");

//elementos novo usuário
var newUser = querySelector("#newUser");
var newUsername = querySelector("#newUsername");
var newPassword = querySelector("#newPassword");
var sendNewUserBtn = querySelector("#sendNewUserBtn");
var newUserErrorPanel = querySelector("#newUserErrorPanel");
var newUserErrorMsg = querySelector("#newUserErrorMsg");
var newUserCreated = querySelector("#newUserCreated");


main() {
  
  sendBtn.onClick.listen((MouseEvent event) {
    sendLogin();
    event.preventDefault();
  });
  
  sendNewUserBtn.onClick.listen((MouseEvent event) {
    sendNewUser();
    event.preventDefault();
  });
}

sendLogin() {
  var login = username.value.trim();
  var pass = password.value.trim();
  
  hideLoginError();
  
  if (login.isEmpty || pass.isEmpty) {
    showLoginError("Informe usuário e senha");
    return;
  }
  
  HttpRequest.request("/login", method: "POST", requestHeaders: {
    "content-type": "application/json"
  }, sendData: JSON.encode({
    "username": login,
    "password": pass
  })).then((req) {
    var resp = JSON.decode(req.response);
    if (resp["success"] != null && resp["success"]) {
      window.location.href = "/index.html";
    } else {
      showLoginError("Usuário ou senha inválidos");
    }
  });
  
}

sendNewUser() {
  var name = newUser.value.trim();
  var login = newUsername.value.trim();
  var pass = newPassword.value.trim();
  
  hideNewUserError();
  hideNewUserSuccess();
  
  if (name.isEmpty || login.isEmpty || pass.isEmpty) {
    showNewUserError("Informe nome, usuário e senha");
    return;
  }
  
  HttpRequest.request("/services/newuser", method: "POST", requestHeaders: {
    "content-type": "application/json"
  }, sendData: JSON.encode({
    "name": name,
    "username": login,
    "password": pass
  })).then((req) {
    var resp = JSON.decode(req.response);
    if (resp["success"] != null && resp["success"]) {
      showNewUserSuccess();
    } else {
      showNewUserError("Usuário existente.");
    }
  });
}

showLoginError(String msg) {
  loginErrorMsg.text = msg;
  loginErrorPanel.style.display = "block";
}

hideLoginError() {
  loginErrorPanel.style.display = "none";
}

showNewUserError(String msg) {
  newUserErrorMsg.text = msg;
  newUserErrorPanel.style.display = "block";
}

hideNewUserError() {
  newUserErrorPanel.style.display = "none";
}

showNewUserSuccess() {
  newUserCreated.style.display = "block";
}

hideNewUserSuccess() {
  newUserCreated.style.display = "none";
}