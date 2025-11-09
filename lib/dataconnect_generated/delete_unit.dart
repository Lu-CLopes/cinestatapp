part of 'example.dart';

class DeleteUnitVariablesBuilder {
  String unitId;

  final FirebaseDataConnect _dataConnect;
  DeleteUnitVariablesBuilder(this._dataConnect, {required  this.unitId,});
  Deserializer<DeleteUnitData> dataDeserializer = (dynamic json)  => DeleteUnitData.fromJson(jsonDecode(json));
  Serializer<DeleteUnitVariables> varsSerializer = (DeleteUnitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteUnitData, DeleteUnitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteUnitData, DeleteUnitVariables> ref() {
    DeleteUnitVariables vars= DeleteUnitVariables(unitId: unitId,);
    return _dataConnect.mutation("DeleteUnit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteUnitUnitDelete {
  final String id;
  DeleteUnitUnitDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteUnitUnitDelete otherTyped = other as DeleteUnitUnitDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteUnitUnitDelete({
    required this.id,
  });
}

@immutable
class DeleteUnitData {
  final DeleteUnitUnitDelete? unit_delete;
  DeleteUnitData.fromJson(dynamic json):
  
  unit_delete = json['unit_delete'] == null ? null : DeleteUnitUnitDelete.fromJson(json['unit_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteUnitData otherTyped = other as DeleteUnitData;
    return unit_delete == otherTyped.unit_delete;
    
  }
  @override
  int get hashCode => unit_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (unit_delete != null) {
      json['unit_delete'] = unit_delete!.toJson();
    }
    return json;
  }

  DeleteUnitData({
    this.unit_delete,
  });
}

@immutable
class DeleteUnitVariables {
  final String unitId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteUnitVariables.fromJson(Map<String, dynamic> json):
  
  unitId = nativeFromJson<String>(json['unitId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteUnitVariables otherTyped = other as DeleteUnitVariables;
    return unitId == otherTyped.unitId;
    
  }
  @override
  int get hashCode => unitId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['unitId'] = nativeToJson<String>(unitId);
    return json;
  }

  DeleteUnitVariables({
    required this.unitId,
  });
}

