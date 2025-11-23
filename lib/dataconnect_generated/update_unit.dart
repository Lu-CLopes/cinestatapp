part of 'example.dart';

class UpdateUnitVariablesBuilder {
  String unitId;
  String unitName;
  String unitLocal;
  int unitMacCapacity;
  String unitManagerId;
  bool unitActive;

  final FirebaseDataConnect _dataConnect;
  UpdateUnitVariablesBuilder(this._dataConnect, {required  this.unitId,required  this.unitName,required  this.unitLocal,required  this.unitMacCapacity,required  this.unitManagerId,required  this.unitActive,});
  Deserializer<UpdateUnitData> dataDeserializer = (dynamic json)  => UpdateUnitData.fromJson(jsonDecode(json));
  Serializer<UpdateUnitVariables> varsSerializer = (UpdateUnitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUnitData, UpdateUnitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateUnitData, UpdateUnitVariables> ref() {
    UpdateUnitVariables vars= UpdateUnitVariables(unitId: unitId,unitName: unitName,unitLocal: unitLocal,unitMacCapacity: unitMacCapacity,unitManagerId: unitManagerId,unitActive: unitActive,);
    return _dataConnect.mutation("updateUnit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateUnitUnitUpdate {
  final String id;
  UpdateUnitUnitUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUnitUnitUpdate otherTyped = other as UpdateUnitUnitUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateUnitUnitUpdate({
    required this.id,
  });
}

@immutable
class UpdateUnitData {
  final UpdateUnitUnitUpdate? unit_update;
  UpdateUnitData.fromJson(dynamic json):
  
  unit_update = json['unit_update'] == null ? null : UpdateUnitUnitUpdate.fromJson(json['unit_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUnitData otherTyped = other as UpdateUnitData;
    return unit_update == otherTyped.unit_update;
    
  }
  @override
  int get hashCode => unit_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (unit_update != null) {
      json['unit_update'] = unit_update!.toJson();
    }
    return json;
  }

  UpdateUnitData({
    this.unit_update,
  });
}

@immutable
class UpdateUnitVariables {
  final String unitId;
  final String unitName;
  final String unitLocal;
  final int unitMacCapacity;
  final String unitManagerId;
  final bool unitActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateUnitVariables.fromJson(Map<String, dynamic> json):
  
  unitId = nativeFromJson<String>(json['unitId']),
  unitName = nativeFromJson<String>(json['unitName']),
  unitLocal = nativeFromJson<String>(json['unitLocal']),
  unitMacCapacity = nativeFromJson<int>(json['unitMacCapacity']),
  unitManagerId = nativeFromJson<String>(json['unitManagerId']),
  unitActive = nativeFromJson<bool>(json['unitActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUnitVariables otherTyped = other as UpdateUnitVariables;
    return unitId == otherTyped.unitId && 
    unitName == otherTyped.unitName && 
    unitLocal == otherTyped.unitLocal && 
    unitMacCapacity == otherTyped.unitMacCapacity && 
    unitManagerId == otherTyped.unitManagerId && 
    unitActive == otherTyped.unitActive;
    
  }
  @override
  int get hashCode => Object.hashAll([unitId.hashCode, unitName.hashCode, unitLocal.hashCode, unitMacCapacity.hashCode, unitManagerId.hashCode, unitActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['unitId'] = nativeToJson<String>(unitId);
    json['unitName'] = nativeToJson<String>(unitName);
    json['unitLocal'] = nativeToJson<String>(unitLocal);
    json['unitMacCapacity'] = nativeToJson<int>(unitMacCapacity);
    json['unitManagerId'] = nativeToJson<String>(unitManagerId);
    json['unitActive'] = nativeToJson<bool>(unitActive);
    return json;
  }

  UpdateUnitVariables({
    required this.unitId,
    required this.unitName,
    required this.unitLocal,
    required this.unitMacCapacity,
    required this.unitManagerId,
    required this.unitActive,
  });
}

