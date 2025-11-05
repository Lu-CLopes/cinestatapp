part of 'example.dart';

class CreateAudienceVariablesBuilder {
  String audienceUnitId;
  int audienceAge;
  String audienceGender;
  String audienceFormat;

  final FirebaseDataConnect _dataConnect;
  CreateAudienceVariablesBuilder(this._dataConnect, {required  this.audienceUnitId,required  this.audienceAge,required  this.audienceGender,required  this.audienceFormat,});
  Deserializer<CreateAudienceData> dataDeserializer = (dynamic json)  => CreateAudienceData.fromJson(jsonDecode(json));
  Serializer<CreateAudienceVariables> varsSerializer = (CreateAudienceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateAudienceData, CreateAudienceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateAudienceData, CreateAudienceVariables> ref() {
    CreateAudienceVariables vars= CreateAudienceVariables(audienceUnitId: audienceUnitId,audienceAge: audienceAge,audienceGender: audienceGender,audienceFormat: audienceFormat,);
    return _dataConnect.mutation("CreateAudience", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateAudienceAudienceInsert {
  final String id;
  CreateAudienceAudienceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAudienceAudienceInsert otherTyped = other as CreateAudienceAudienceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAudienceAudienceInsert({
    required this.id,
  });
}

@immutable
class CreateAudienceData {
  final CreateAudienceAudienceInsert audience_insert;
  CreateAudienceData.fromJson(dynamic json):
  
  audience_insert = CreateAudienceAudienceInsert.fromJson(json['audience_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAudienceData otherTyped = other as CreateAudienceData;
    return audience_insert == otherTyped.audience_insert;
    
  }
  @override
  int get hashCode => audience_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audience_insert'] = audience_insert.toJson();
    return json;
  }

  CreateAudienceData({
    required this.audience_insert,
  });
}

@immutable
class CreateAudienceVariables {
  final String audienceUnitId;
  final int audienceAge;
  final String audienceGender;
  final String audienceFormat;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateAudienceVariables.fromJson(Map<String, dynamic> json):
  
  audienceUnitId = nativeFromJson<String>(json['audienceUnitId']),
  audienceAge = nativeFromJson<int>(json['audienceAge']),
  audienceGender = nativeFromJson<String>(json['audienceGender']),
  audienceFormat = nativeFromJson<String>(json['audienceFormat']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAudienceVariables otherTyped = other as CreateAudienceVariables;
    return audienceUnitId == otherTyped.audienceUnitId && 
    audienceAge == otherTyped.audienceAge && 
    audienceGender == otherTyped.audienceGender && 
    audienceFormat == otherTyped.audienceFormat;
    
  }
  @override
  int get hashCode => Object.hashAll([audienceUnitId.hashCode, audienceAge.hashCode, audienceGender.hashCode, audienceFormat.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audienceUnitId'] = nativeToJson<String>(audienceUnitId);
    json['audienceAge'] = nativeToJson<int>(audienceAge);
    json['audienceGender'] = nativeToJson<String>(audienceGender);
    json['audienceFormat'] = nativeToJson<String>(audienceFormat);
    return json;
  }

  CreateAudienceVariables({
    required this.audienceUnitId,
    required this.audienceAge,
    required this.audienceGender,
    required this.audienceFormat,
  });
}

