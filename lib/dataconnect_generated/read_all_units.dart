part of 'example.dart';

class ReadAllUnitsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ReadAllUnitsVariablesBuilder(this._dataConnect, );
  Deserializer<ReadAllUnitsData> dataDeserializer = (dynamic json)  => ReadAllUnitsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ReadAllUnitsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ReadAllUnitsData, void> ref() {
    
    return _dataConnect.query("ReadAllUnits", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ReadAllUnitsUnits {
  final String id;
  final String unitName;
  final String? unitLocal;
  final int? unitMacCapacity;
  final bool? unitActive;
  final ReadAllUnitsUnitsUnitManager? unitManager;
  ReadAllUnitsUnits.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  unitName = nativeFromJson<String>(json['unitName']),
  unitLocal = json['unitLocal'] == null ? null : nativeFromJson<String>(json['unitLocal']),
  unitMacCapacity = json['unitMacCapacity'] == null ? null : nativeFromJson<int>(json['unitMacCapacity']),
  unitActive = json['unitActive'] == null ? null : nativeFromJson<bool>(json['unitActive']),
  unitManager = json['unitManager'] == null ? null : ReadAllUnitsUnitsUnitManager.fromJson(json['unitManager']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllUnitsUnits otherTyped = other as ReadAllUnitsUnits;
    return id == otherTyped.id && 
    unitName == otherTyped.unitName && 
    unitLocal == otherTyped.unitLocal && 
    unitMacCapacity == otherTyped.unitMacCapacity && 
    unitActive == otherTyped.unitActive && 
    unitManager == otherTyped.unitManager;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, unitName.hashCode, unitLocal.hashCode, unitMacCapacity.hashCode, unitActive.hashCode, unitManager.hashCode]);
  

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
    if (unitActive != null) {
      json['unitActive'] = nativeToJson<bool?>(unitActive);
    }
    if (unitManager != null) {
      json['unitManager'] = unitManager!.toJson();
    }
    return json;
  }

  ReadAllUnitsUnits({
    required this.id,
    required this.unitName,
    this.unitLocal,
    this.unitMacCapacity,
    this.unitActive,
    this.unitManager,
  });
}

@immutable
class ReadAllUnitsUnitsUnitManager {
  final String userName;
  final String userEmail;
  final String id;
  ReadAllUnitsUnitsUnitManager.fromJson(dynamic json):
  
  userName = nativeFromJson<String>(json['userName']),
  userEmail = nativeFromJson<String>(json['userEmail']),
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllUnitsUnitsUnitManager otherTyped = other as ReadAllUnitsUnitsUnitManager;
    return userName == otherTyped.userName && 
    userEmail == otherTyped.userEmail && 
    id == otherTyped.id;
    
  }
  @override
  int get hashCode => Object.hashAll([userName.hashCode, userEmail.hashCode, id.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userName'] = nativeToJson<String>(userName);
    json['userEmail'] = nativeToJson<String>(userEmail);
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ReadAllUnitsUnitsUnitManager({
    required this.userName,
    required this.userEmail,
    required this.id,
  });
}

@immutable
class ReadAllUnitsData {
  final List<ReadAllUnitsUnits> units;
  ReadAllUnitsData.fromJson(dynamic json):
  
  units = (json['units'] as List<dynamic>)
        .map((e) => ReadAllUnitsUnits.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllUnitsData otherTyped = other as ReadAllUnitsData;
    return units == otherTyped.units;
    
  }
  @override
  int get hashCode => units.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['units'] = units.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAllUnitsData({
    required this.units,
  });
}

