part of 'example.dart';

class CreateUnitVariablesBuilder {
  String unitName;
  String unitLocal;
  int unitMacCapacity;
  String unitManagerId;
  bool unitActive;

  final FirebaseDataConnect _dataConnect;
  CreateUnitVariablesBuilder(this._dataConnect, {required  this.unitName,required  this.unitLocal,required  this.unitMacCapacity,required  this.unitManagerId,required  this.unitActive,});
  Deserializer<CreateUnitData> dataDeserializer = (dynamic json)  => CreateUnitData.fromJson(jsonDecode(json));
  Serializer<CreateUnitVariables> varsSerializer = (CreateUnitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateUnitData, CreateUnitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateUnitData, CreateUnitVariables> ref() {
    CreateUnitVariables vars= CreateUnitVariables(unitName: unitName,unitLocal: unitLocal,unitMacCapacity: unitMacCapacity,unitManagerId: unitManagerId,unitActive: unitActive,);
    return _dataConnect.mutation("CreateUnit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateUnitUnitInsert {
  final String id;
  CreateUnitUnitInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateUnitUnitInsert otherTyped = other as CreateUnitUnitInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateUnitUnitInsert({
    required this.id,
  });
}

@immutable
class CreateUnitData {
  final CreateUnitUnitInsert unit_insert;
  CreateUnitData.fromJson(dynamic json):
  
  unit_insert = CreateUnitUnitInsert.fromJson(json['unit_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateUnitData otherTyped = other as CreateUnitData;
    return unit_insert == otherTyped.unit_insert;
    
  }
  @override
  int get hashCode => unit_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['unit_insert'] = unit_insert.toJson();
    return json;
  }

  const CreateUnitData({
    required this.unit_insert,
  });
}

@immutable
class CreateUnitVariables {
  final String unitName;
  final String unitLocal;
  final int unitMacCapacity;
  final String unitManagerId;
  final bool unitActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateUnitVariables.fromJson(Map<String, dynamic> json):
  
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

    final CreateUnitVariables otherTyped = other as CreateUnitVariables;
    return unitName == otherTyped.unitName && 
    unitLocal == otherTyped.unitLocal && 
    unitMacCapacity == otherTyped.unitMacCapacity && 
    unitManagerId == otherTyped.unitManagerId && 
    unitActive == otherTyped.unitActive;
    
  }
  @override
  int get hashCode => Object.hashAll([unitName.hashCode, unitLocal.hashCode, unitMacCapacity.hashCode, unitManagerId.hashCode, unitActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['unitName'] = nativeToJson<String>(unitName);
    json['unitLocal'] = nativeToJson<String>(unitLocal);
    json['unitMacCapacity'] = nativeToJson<int>(unitMacCapacity);
    json['unitManagerId'] = nativeToJson<String>(unitManagerId);
    json['unitActive'] = nativeToJson<bool>(unitActive);
    return json;
  }

  const CreateUnitVariables({
    required this.unitName,
    required this.unitLocal,
    required this.unitMacCapacity,
    required this.unitManagerId,
    required this.unitActive,
  });
}

