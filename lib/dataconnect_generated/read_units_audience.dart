part of 'example.dart';

class ReadUnitsAudienceVariablesBuilder {
  String unitId;

  final FirebaseDataConnect _dataConnect;
  ReadUnitsAudienceVariablesBuilder(this._dataConnect, {required  this.unitId,});
  Deserializer<ReadUnitsAudienceData> dataDeserializer = (dynamic json)  => ReadUnitsAudienceData.fromJson(jsonDecode(json));
  Serializer<ReadUnitsAudienceVariables> varsSerializer = (ReadUnitsAudienceVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ReadUnitsAudienceData, ReadUnitsAudienceVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ReadUnitsAudienceData, ReadUnitsAudienceVariables> ref() {
    ReadUnitsAudienceVariables vars= ReadUnitsAudienceVariables(unitId: unitId,);
    return _dataConnect.query("ReadUnitsAudience", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ReadUnitsAudienceAudiences {
  final int? audienceAge;
  final String? audienceGender;
  final String? audienceFormat;
  ReadUnitsAudienceAudiences.fromJson(dynamic json):
  
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

    final ReadUnitsAudienceAudiences otherTyped = other as ReadUnitsAudienceAudiences;
    return audienceAge == otherTyped.audienceAge && 
    audienceGender == otherTyped.audienceGender && 
    audienceFormat == otherTyped.audienceFormat;
    
  }
  @override
  int get hashCode => Object.hashAll([audienceAge.hashCode, audienceGender.hashCode, audienceFormat.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
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

  ReadUnitsAudienceAudiences({
    this.audienceAge,
    this.audienceGender,
    this.audienceFormat,
  });
}

@immutable
class ReadUnitsAudienceData {
  final List<ReadUnitsAudienceAudiences> audiences;
  ReadUnitsAudienceData.fromJson(dynamic json):
  
  audiences = (json['audiences'] as List<dynamic>)
        .map((e) => ReadUnitsAudienceAudiences.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadUnitsAudienceData otherTyped = other as ReadUnitsAudienceData;
    return audiences == otherTyped.audiences;
    
  }
  @override
  int get hashCode => audiences.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audiences'] = audiences.map((e) => e.toJson()).toList();
    return json;
  }

  ReadUnitsAudienceData({
    required this.audiences,
  });
}

@immutable
class ReadUnitsAudienceVariables {
  final String unitId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ReadUnitsAudienceVariables.fromJson(Map<String, dynamic> json):
  
  unitId = nativeFromJson<String>(json['unitId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadUnitsAudienceVariables otherTyped = other as ReadUnitsAudienceVariables;
    return unitId == otherTyped.unitId;
    
  }
  @override
  int get hashCode => unitId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['unitId'] = nativeToJson<String>(unitId);
    return json;
  }

  ReadUnitsAudienceVariables({
    required this.unitId,
  });
}

