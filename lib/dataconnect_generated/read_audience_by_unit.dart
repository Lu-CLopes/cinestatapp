part of 'example.dart';

class ReadAudienceByUnitVariablesBuilder {
  String unitId;

  final FirebaseDataConnect _dataConnect;
  ReadAudienceByUnitVariablesBuilder(this._dataConnect, {required  this.unitId,});
  Deserializer<ReadAudienceByUnitData> dataDeserializer = (dynamic json)  => ReadAudienceByUnitData.fromJson(jsonDecode(json));
  Serializer<ReadAudienceByUnitVariables> varsSerializer = (ReadAudienceByUnitVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ReadAudienceByUnitData, ReadAudienceByUnitVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ReadAudienceByUnitData, ReadAudienceByUnitVariables> ref() {
    ReadAudienceByUnitVariables vars= ReadAudienceByUnitVariables(unitId: unitId,);
    return _dataConnect.query("ReadAudienceByUnit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ReadAudienceByUnitAudiences {
  final String id;
  final int? audienceAge;
  final String? audienceGender;
  final String? audienceFormat;
  ReadAudienceByUnitAudiences.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  audienceAge = json['audienceAge'] == null ? null : nativeFromJson<int>(json['audienceAge']),
  audienceGender = json['audienceGender'] == null ? null : nativeFromJson<String>(json['audienceGender']),
  audienceFormat = json['audienceFormat'] == null ? null : nativeFromJson<String>(json['audienceFormat']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAudienceByUnitAudiences otherTyped = other as ReadAudienceByUnitAudiences;
    return id == otherTyped.id && 
    audienceAge == otherTyped.audienceAge && 
    audienceGender == otherTyped.audienceGender && 
    audienceFormat == otherTyped.audienceFormat;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, audienceAge.hashCode, audienceGender.hashCode, audienceFormat.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (audienceAge != null) {
      json['audienceAge'] = nativeToJson<int?>(audienceAge);
    }
    if (audienceGender != null) {
      json['audienceGender'] = nativeToJson<String?>(audienceGender);
    }
    if (audienceFormat != null) {
      json['audienceFormat'] = nativeToJson<String?>(audienceFormat);
    }
    return json;
  }

  ReadAudienceByUnitAudiences({
    required this.id,
    this.audienceAge,
    this.audienceGender,
    this.audienceFormat,
  });
}

@immutable
class ReadAudienceByUnitData {
  final List<ReadAudienceByUnitAudiences> audiences;
  ReadAudienceByUnitData.fromJson(dynamic json):
  
  audiences = (json['audiences'] as List<dynamic>)
        .map((e) => ReadAudienceByUnitAudiences.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAudienceByUnitData otherTyped = other as ReadAudienceByUnitData;
    return audiences == otherTyped.audiences;
    
  }
  @override
  int get hashCode => audiences.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audiences'] = audiences.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAudienceByUnitData({
    required this.audiences,
  });
}

@immutable
class ReadAudienceByUnitVariables {
  final String unitId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ReadAudienceByUnitVariables.fromJson(Map<String, dynamic> json):
  
  unitId = nativeFromJson<String>(json['unitId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAudienceByUnitVariables otherTyped = other as ReadAudienceByUnitVariables;
    return unitId == otherTyped.unitId;
    
  }
  @override
  int get hashCode => unitId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['unitId'] = nativeToJson<String>(unitId);
    return json;
  }

  ReadAudienceByUnitVariables({
    required this.unitId,
  });
}

