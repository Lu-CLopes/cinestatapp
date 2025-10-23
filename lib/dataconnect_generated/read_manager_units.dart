part of 'example.dart';

class ReadManagerUnitsVariablesBuilder {
  String managerId;

  final FirebaseDataConnect _dataConnect;
  ReadManagerUnitsVariablesBuilder(this._dataConnect, {required  this.managerId,});
  Deserializer<ReadManagerUnitsData> dataDeserializer = (dynamic json)  => ReadManagerUnitsData.fromJson(jsonDecode(json));
  Serializer<ReadManagerUnitsVariables> varsSerializer = (ReadManagerUnitsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ReadManagerUnitsData, ReadManagerUnitsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ReadManagerUnitsData, ReadManagerUnitsVariables> ref() {
    ReadManagerUnitsVariables vars= ReadManagerUnitsVariables(managerId: managerId,);
    return _dataConnect.query("ReadManagerUnits", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ReadManagerUnitsUnits {
  final String unitName;
  final String? unitLocal;
  final int? unitMacCapacity;
  final ReadManagerUnitsUnitsUnitManager? unitManager;
  final bool? unitActive;
  ReadManagerUnitsUnits.fromJson(dynamic json):
  
  unitName = nativeFromJson<String>(json['unitName']),
  unitLocal = json['unitLocal'] == null ? null : nativeFromJson<String>(json['unitLocal']),
  unitMacCapacity = json['unitMacCapacity'] == null ? null : nativeFromJson<int>(json['unitMacCapacity']),
  unitManager = json['unitManager'] == null ? null : ReadManagerUnitsUnitsUnitManager.fromJson(json['unitManager']),
  unitActive = json['unitActive'] == null ? null : nativeFromJson<bool>(json['unitActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsUnits otherTyped = other as ReadManagerUnitsUnits;
    return unitName == otherTyped.unitName && 
    unitLocal == otherTyped.unitLocal && 
    unitMacCapacity == otherTyped.unitMacCapacity && 
    unitManager == otherTyped.unitManager && 
    unitActive == otherTyped.unitActive;
    
  }
  @override
  int get hashCode => Object.hashAll([unitName.hashCode, unitLocal.hashCode, unitMacCapacity.hashCode, unitManager.hashCode, unitActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
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

  const ReadManagerUnitsUnits({
    required this.unitName,
    this.unitLocal,
    this.unitMacCapacity,
    this.unitManager,
    this.unitActive,
  });
}

@immutable
class ReadManagerUnitsUnitsUnitManager {
  final String userName;
  ReadManagerUnitsUnitsUnitManager.fromJson(dynamic json):
  
  userName = nativeFromJson<String>(json['userName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsUnitsUnitManager otherTyped = other as ReadManagerUnitsUnitsUnitManager;
    return userName == otherTyped.userName;
    
  }
  @override
  int get hashCode => userName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userName'] = nativeToJson<String>(userName);
    return json;
  }

  const ReadManagerUnitsUnitsUnitManager({
    required this.userName,
  });
}

@immutable
class ReadManagerUnitsData {
  final List<ReadManagerUnitsUnits> units;
  ReadManagerUnitsData.fromJson(dynamic json):
  
  units = (json['units'] as List<dynamic>)
        .map((e) => ReadManagerUnitsUnits.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsData otherTyped = other as ReadManagerUnitsData;
    return units == otherTyped.units;
    
  }
  @override
  int get hashCode => units.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['units'] = units.map((e) => e.toJson()).toList();
    return json;
  }

  const ReadManagerUnitsData({
    required this.units,
  });
}

@immutable
class ReadManagerUnitsVariables {
  final String managerId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ReadManagerUnitsVariables.fromJson(Map<String, dynamic> json):
  
  managerId = nativeFromJson<String>(json['managerId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadManagerUnitsVariables otherTyped = other as ReadManagerUnitsVariables;
    return managerId == otherTyped.managerId;
    
  }
  @override
  int get hashCode => managerId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['managerId'] = nativeToJson<String>(managerId);
    return json;
  }

  const ReadManagerUnitsVariables({
    required this.managerId,
  });
}

