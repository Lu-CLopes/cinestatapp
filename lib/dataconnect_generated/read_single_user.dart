part of 'example.dart';

class ReadSingleUserVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  ReadSingleUserVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ReadSingleUserData> dataDeserializer = (dynamic json)  => ReadSingleUserData.fromJson(jsonDecode(json));
  Serializer<ReadSingleUserVariables> varsSerializer = (ReadSingleUserVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ReadSingleUserData, ReadSingleUserVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ReadSingleUserData, ReadSingleUserVariables> ref() {
    ReadSingleUserVariables vars= ReadSingleUserVariables(id: id,);
    return _dataConnect.query("ReadSingleUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ReadSingleUserUser {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime userCreatedAt;
  ReadSingleUserUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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

    final ReadSingleUserUser otherTyped = other as ReadSingleUserUser;
    return id == otherTyped.id && 
    userId == otherTyped.userId && 
    userName == otherTyped.userName && 
    userEmail == otherTyped.userEmail && 
    userCreatedAt == otherTyped.userCreatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, userId.hashCode, userName.hashCode, userEmail.hashCode, userCreatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['userId'] = nativeToJson<String>(userId);
    json['userName'] = nativeToJson<String>(userName);
    json['userEmail'] = nativeToJson<String>(userEmail);
    json['userCreatedAt'] = nativeToJson<DateTime>(userCreatedAt);
    return json;
  }

  ReadSingleUserUser({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userCreatedAt,
  });
}

@immutable
class ReadSingleUserData {
  final ReadSingleUserUser? user;
  ReadSingleUserData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : ReadSingleUserUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadSingleUserData otherTyped = other as ReadSingleUserData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  ReadSingleUserData({
    this.user,
  });
}

@immutable
class ReadSingleUserVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ReadSingleUserVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadSingleUserVariables otherTyped = other as ReadSingleUserVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ReadSingleUserVariables({
    required this.id,
  });
}

