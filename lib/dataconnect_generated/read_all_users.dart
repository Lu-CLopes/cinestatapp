part of 'example.dart';

class ReadAllUsersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ReadAllUsersVariablesBuilder(this._dataConnect, );
  Deserializer<ReadAllUsersData> dataDeserializer = (dynamic json)  => ReadAllUsersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ReadAllUsersData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ReadAllUsersData, void> ref() {
    
    return _dataConnect.query("ReadAllUsers", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ReadAllUsersUsers {
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime userCreatedAt;
  ReadAllUsersUsers.fromJson(dynamic json):
  
  userId = nativeFromJson<String>(json['userId']),
  userName = nativeFromJson<String>(json['userName']),
  userEmail = nativeFromJson<String>(json['userEmail']),
  userCreatedAt = nativeFromJson<DateTime>(json['userCreatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllUsersUsers otherTyped = other as ReadAllUsersUsers;
    return userId == otherTyped.userId && 
    userName == otherTyped.userName && 
    userEmail == otherTyped.userEmail && 
    userCreatedAt == otherTyped.userCreatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, userName.hashCode, userEmail.hashCode, userCreatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['userName'] = nativeToJson<String>(userName);
    json['userEmail'] = nativeToJson<String>(userEmail);
    json['userCreatedAt'] = nativeToJson<DateTime>(userCreatedAt);
    return json;
  }

  ReadAllUsersUsers({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userCreatedAt,
  });
  get id => null;
}

@immutable
class ReadAllUsersData {
  final List<ReadAllUsersUsers> users;
  ReadAllUsersData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => ReadAllUsersUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllUsersData otherTyped = other as ReadAllUsersData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAllUsersData({
    required this.users,
  });
}

