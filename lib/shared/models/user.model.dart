class User {
  static bool? isLoggedIn = false;
  static String userId = '';
  static String email = '';
  static String password = '';
  static String authToken = '';
  static String loginType = '';
  static String name = '';
  static Map<String, dynamic>? lastAssessment;

  User.map(dynamic obj) {
    userId = obj["user_id"];
    email = obj["email"];
    password = obj["password"];
    authToken = obj["auth_token"];
    loginType = obj["login_type"];
    name = obj["name"];
    isLoggedIn = true;
  }

  static Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["email"] = email;
    map["password"] = password;
    map["authToken"] = authToken;
    map['loginType'] = loginType;
    map["name"] = name;
    return map;
  }

  static setUserParams(Map<dynamic, dynamic>? oauthResp) {
    if (oauthResp != null) {
      userId = oauthResp['data']['profile']['id'].toString();
      email = oauthResp['data']['profile']['email'];
      password = '';
      name = oauthResp["data"]["profile"]["name"];
      authToken = oauthResp['data']['token'];
      email = oauthResp["data"]["user"]["email"];
      isLoggedIn = true;
    }
  }

  static deleteUser() {
    userId = '';
    email = '';
    password = '';
    authToken = '';
    loginType = '';
    isLoggedIn = false;
  }

  static saveUserParamsFromDatabase(Map<String, dynamic> map) {
    userId = map["userId"];
    email = map["email"];
    password = map["password"];
    authToken = map["authToken"];
    loginType = map['loginType'];
    name = map["name"];
    isLoggedIn = true;
  }
}
