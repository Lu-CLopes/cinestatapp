part of 'example.dart';

class ReadManagerUnitsByAuthVariablesBuilder {
  String authId;

  final FirebaseDataConnect _dataConnect;
  ReadManagerUnitsByAuthVariablesBuilder(this._dataConnect, {required  this.authId,});
  Deserializer<ReadManagerUnitsByAuthData> dataDeserializer = (dynamic json)  => ReadManagerUnitsByAuthData.fromJson(jsonDecode(json));
  Serializer<ReadManagerUnitsByAuthVariables> varsSerializer = (ReadManagerUnitsByAuthVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ReadManagerUnitsByAuthData, ReadManagerUnitsByAuthVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ReadManagerUnitsByAuthData, ReadManagerUnitsByAuthVariables> ref() {
    ReadManagerUnitsByAuthVariables vars= ReadManagerUnitsByAuthVariables(authId: authId,);
    return _dataConnect.query("ReadManagerUnitsByAuth", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ReadManagerUnitsByAuthUnits {
  final String id;
  final String unitName;
  final String? unitLocal;
  final int? unitMacCapacity;
  final ReadManagerUnitsByAuthUnitsUnitManager? unitManager;
  final bool? unitActive;
  ReadManagerUnitsByAuthUnits.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  unitName = nativeFromJson<String>(json['unitName']),
  unitLocal = json['unitLocal'] == null ? null : nativeFromJson<String>(json['unitLocal']),
  unitMacCapacity = json['unitMacCapacity'] == null ? null : nativeFromJson<int>(json['unitMacCapacity']),
  unitManager = json['unitManager'] == null ? null : ReadManagerUnitsByAuthUnitsUnitManager.fromJson(json['unitManager']),
  unitActive = json['unitActive'] == null ? null : nativeFromJson<bool>(json['unitActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsByAuthUnits otherTyped = other as ReadManagerUnitsByAuthUnits;
    return id == otherTyped.id && 
    unitName == otherTyped.unitName && 
    unitLocal == otherTyped.unitLocal && 
    unitMacCapacity == otherTyped.unitMacCapacity && 
    unitManager == otherTyped.unitManager && 
    unitActive == otherTyped.unitActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, unitName.hashCode, unitLocal.hashCode, unitMacCapacity.hashCode, unitManager.hashCode, unitActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['unitName'] = nativeToJson<String>(unitName);
    if (unitLocal != null) {
      json['unitLocal'] = nativeToJson<String?>(unitLocal);
    }
    if (unitMacCapacity != null) {
      json['unitMacCapacity'] = nativeToJson<int?>(unitMacCapacity);
    }
    if (unitManager != null) {
      json['unitManager'] = unitManager!.toJson();
    }
    if (unitActive != null) {
      json['unitActive'] = nativeToJson<bool?>(unitActive);
    }
    return json;
  }

  ReadManagerUnitsByAuthUnits({
    required this.id,
    required this.unitName,
    this.unitLocal,
    this.unitMacCapacity,
    this.unitManager,
    this.unitActive,
  });
}

@immutable
class ReadManagerUnitsByAuthUnitsUnitManager {
  final String userName;
  ReadManagerUnitsByAuthUnitsUnitManager.fromJson(dynamic json):
  
  userName = nativeFromJson<String>(json['userName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsByAuthUnitsUnitManager otherTyped = other as ReadManagerUnitsByAuthUnitsUnitManager;
    return userName == otherTyped.userName;
    
  }
  @override
  int get hashCode => userName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userName'] = nativeToJson<String>(userName);
    return json;
  }

  ReadManagerUnitsByAuthUnitsUnitManager({
    required this.userName,
  });
}

@immutable
class ReadManagerUnitsByAuthData {
  final List<ReadManagerUnitsByAuthUnits> units;
  ReadManagerUnitsByAuthData.fromJson(dynamic json):
  
  units = (json['units'] as List<dynamic>)
        .map((e) => ReadManagerUnitsByAuthUnits.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsByAuthData otherTyped = other as ReadManagerUnitsByAuthData;
    return units == otherTyped.units;
    
  }
  @override
  int get hashCode => units.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['units'] = units.map((e) => e.toJson()).toList();
    return json;
  }

  ReadManagerUnitsByAuthData({
    required this.units,
  });
}

@immutable
class ReadManagerUnitsByAuthVariables {
  final String authId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ReadManagerUnitsByAuthVariables.fromJson(Map<String, dynamic> json):
  
  authId = nativeFromJson<String>(json['authId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsByAuthVariables otherTyped = other as ReadManagerUnitsByAuthVariables;
    return authId == otherTyped.authId;
    
  }
  @override
  int get hashCode => authId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['authId'] = nativeToJson<String>(authId);
    return json;
  }

  ReadManagerUnitsByAuthVariables({
    required this.authId,
  });
}

