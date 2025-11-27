part of 'example.dart';

class ReadAllSessionsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ReadAllSessionsVariablesBuilder(this._dataConnect, );
  Deserializer<ReadAllSessionsData> dataDeserializer = (dynamic json)  => ReadAllSessionsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ReadAllSessionsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ReadAllSessionsData, void> ref() {
    
    return _dataConnect.query("ReadAllSessions", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ReadAllSessionsSessions {
  final String id;
  final DateTime sessionDate;
  final DateTime sessionHour;
  final double? sessionNetValue;
  final int? sessionTicketsSold;
  final ReadAllSessionsSessionsSessionMovie sessionMovie;
  final ReadAllSessionsSessionsSessionUnit sessionUnit;
  ReadAllSessionsSessions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  sessionDate = nativeFromJson<DateTime>(json['sessionDate']),
  sessionHour = nativeFromJson<DateTime>(json['sessionHour']),
  sessionNetValue = json['sessionNetValue'] == null ? null : nativeFromJson<double>(json['sessionNetValue']),
  sessionTicketsSold = json['sessionTicketsSold'] == null ? null : nativeFromJson<int>(json['sessionTicketsSold']),
  sessionMovie = ReadAllSessionsSessionsSessionMovie.fromJson(json['sessionMovie']),
  sessionUnit = ReadAllSessionsSessionsSessionUnit.fromJson(json['sessionUnit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllSessionsSessions otherTyped = other as ReadAllSessionsSessions;
    return id == otherTyped.id && 
    sessionDate == otherTyped.sessionDate && 
    sessionHour == otherTyped.sessionHour && 
    sessionNetValue == otherTyped.sessionNetValue && 
    sessionTicketsSold == otherTyped.sessionTicketsSold && 
    sessionMovie == otherTyped.sessionMovie && 
    sessionUnit == otherTyped.sessionUnit;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, sessionDate.hashCode, sessionHour.hashCode, sessionNetValue.hashCode, sessionTicketsSold.hashCode, sessionMovie.hashCode, sessionUnit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['sessionDate'] = nativeToJson<DateTime>(sessionDate);
    json['sessionHour'] = nativeToJson<DateTime>(sessionHour);
    if (sessionNetValue != null) {
      json['sessionNetValue'] = nativeToJson<double?>(sessionNetValue);
    }
    if (sessionTicketsSold != null) {
      json['sessionTicketsSold'] = nativeToJson<int?>(sessionTicketsSold);
    }
    json['sessionMovie'] = sessionMovie.toJson();
    json['sessionUnit'] = sessionUnit.toJson();
    return json;
  }

  ReadAllSessionsSessions({
    required this.id,
    required this.sessionDate,
    required this.sessionHour,
    this.sessionNetValue,
    this.sessionTicketsSold,
    required this.sessionMovie,
    required this.sessionUnit,
  });
}

@immutable
class ReadAllSessionsSessionsSessionMovie {
  final String id;
  final String movieTitle;
  ReadAllSessionsSessionsSessionMovie.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  movieTitle = nativeFromJson<String>(json['movieTitle']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllSessionsSessionsSessionMovie otherTyped = other as ReadAllSessionsSessionsSessionMovie;
    return id == otherTyped.id && 
    movieTitle == otherTyped.movieTitle;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, movieTitle.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['movieTitle'] = nativeToJson<String>(movieTitle);
    return json;
  }

  ReadAllSessionsSessionsSessionMovie({
    required this.id,
    required this.movieTitle,
  });
}

@immutable
class ReadAllSessionsSessionsSessionUnit {
  final String id;
  final String unitName;
  ReadAllSessionsSessionsSessionUnit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  unitName = nativeFromJson<String>(json['unitName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllSessionsSessionsSessionUnit otherTyped = other as ReadAllSessionsSessionsSessionUnit;
    return id == otherTyped.id && 
    unitName == otherTyped.unitName;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, unitName.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['unitName'] = nativeToJson<String>(unitName);
    return json;
  }

  ReadAllSessionsSessionsSessionUnit({
    required this.id,
    required this.unitName,
  });
}

@immutable
class ReadAllSessionsData {
  final List<ReadAllSessionsSessions> sessions;
  ReadAllSessionsData.fromJson(dynamic json):
  
  sessions = (json['sessions'] as List<dynamic>)
        .map((e) => ReadAllSessionsSessions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllSessionsData otherTyped = other as ReadAllSessionsData;
    return sessions == otherTyped.sessions;
    
  }
  @override
  int get hashCode => sessions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessions'] = sessions.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAllSessionsData({
    required this.sessions,
  });
}

