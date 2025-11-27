part of 'example.dart';

class CreateSessionVariablesBuilder {
  String sessionMovieId;
  String sessionUnitId;
  DateTime sessionDate;
  DateTime sessionHour;
  Optional<int> _sessionTicketsSold = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _sessionNetValue = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateSessionVariablesBuilder sessionTicketsSold(int? t) {
   _sessionTicketsSold.value = t;
   return this;
  }
  CreateSessionVariablesBuilder sessionNetValue(double? t) {
   _sessionNetValue.value = t;
   return this;
  }

  CreateSessionVariablesBuilder(this._dataConnect, {required  this.sessionMovieId,required  this.sessionUnitId,required  this.sessionDate,required  this.sessionHour,});
  Deserializer<CreateSessionData> dataDeserializer = (dynamic json)  => CreateSessionData.fromJson(jsonDecode(json));
  Serializer<CreateSessionVariables> varsSerializer = (CreateSessionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateSessionData, CreateSessionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateSessionData, CreateSessionVariables> ref() {
    CreateSessionVariables vars= CreateSessionVariables(sessionMovieId: sessionMovieId,sessionUnitId: sessionUnitId,sessionDate: sessionDate,sessionHour: sessionHour,sessionTicketsSold: _sessionTicketsSold,sessionNetValue: _sessionNetValue,);
    return _dataConnect.mutation("CreateSession", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateSessionSessionInsert {
  final String id;
  CreateSessionSessionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSessionSessionInsert otherTyped = other as CreateSessionSessionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateSessionSessionInsert({
    required this.id,
  });
}

@immutable
class CreateSessionData {
  final CreateSessionSessionInsert session_insert;
  CreateSessionData.fromJson(dynamic json):
  
  session_insert = CreateSessionSessionInsert.fromJson(json['session_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSessionData otherTyped = other as CreateSessionData;
    return session_insert == otherTyped.session_insert;
    
  }
  @override
  int get hashCode => session_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['session_insert'] = session_insert.toJson();
    return json;
  }

  CreateSessionData({
    required this.session_insert,
  });
}

@immutable
class CreateSessionVariables {
  final String sessionMovieId;
  final String sessionUnitId;
  final DateTime sessionDate;
  final DateTime sessionHour;
  late final Optional<int>sessionTicketsSold;
  late final Optional<double>sessionNetValue;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateSessionVariables.fromJson(Map<String, dynamic> json):
  
  sessionMovieId = nativeFromJson<String>(json['sessionMovieId']),
  sessionUnitId = nativeFromJson<String>(json['sessionUnitId']),
  sessionDate = nativeFromJson<DateTime>(json['sessionDate']),
  sessionHour = nativeFromJson<DateTime>(json['sessionHour']) {
  
  
  
  
  
  
    sessionTicketsSold = Optional.optional(nativeFromJson, nativeToJson);
    sessionTicketsSold.value = json['sessionTicketsSold'] == null ? null : nativeFromJson<int>(json['sessionTicketsSold']);
  
  
    sessionNetValue = Optional.optional(nativeFromJson, nativeToJson);
    sessionNetValue.value = json['sessionNetValue'] == null ? null : nativeFromJson<double>(json['sessionNetValue']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSessionVariables otherTyped = other as CreateSessionVariables;
    return sessionMovieId == otherTyped.sessionMovieId && 
    sessionUnitId == otherTyped.sessionUnitId && 
    sessionDate == otherTyped.sessionDate && 
    sessionHour == otherTyped.sessionHour && 
    sessionTicketsSold == otherTyped.sessionTicketsSold && 
    sessionNetValue == otherTyped.sessionNetValue;
    
  }
  @override
  int get hashCode => Object.hashAll([sessionMovieId.hashCode, sessionUnitId.hashCode, sessionDate.hashCode, sessionHour.hashCode, sessionTicketsSold.hashCode, sessionNetValue.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessionMovieId'] = nativeToJson<String>(sessionMovieId);
    json['sessionUnitId'] = nativeToJson<String>(sessionUnitId);
    json['sessionDate'] = nativeToJson<DateTime>(sessionDate);
    json['sessionHour'] = nativeToJson<DateTime>(sessionHour);
    if(sessionTicketsSold.state == OptionalState.set) {
      json['sessionTicketsSold'] = sessionTicketsSold.toJson();
    }
    if(sessionNetValue.state == OptionalState.set) {
      json['sessionNetValue'] = sessionNetValue.toJson();
    }
    return json;
  }

  CreateSessionVariables({
    required this.sessionMovieId,
    required this.sessionUnitId,
    required this.sessionDate,
    required this.sessionHour,
    required this.sessionTicketsSold,
    required this.sessionNetValue,
  });
}

