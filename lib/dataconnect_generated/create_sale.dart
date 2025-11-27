part of 'example.dart';

class CreateSaleVariablesBuilder {
  String saleProductId;
  String saleSessionId;
  DateTime saleDate;
  int saleQuant;
  Optional<double> _saleNetValue = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateSaleVariablesBuilder saleNetValue(double? t) {
   _saleNetValue.value = t;
   return this;
  }

  CreateSaleVariablesBuilder(this._dataConnect, {required  this.saleProductId,required  this.saleSessionId,required  this.saleDate,required  this.saleQuant,});
  Deserializer<CreateSaleData> dataDeserializer = (dynamic json)  => CreateSaleData.fromJson(jsonDecode(json));
  Serializer<CreateSaleVariables> varsSerializer = (CreateSaleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateSaleData, CreateSaleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateSaleData, CreateSaleVariables> ref() {
    CreateSaleVariables vars= CreateSaleVariables(saleProductId: saleProductId,saleSessionId: saleSessionId,saleDate: saleDate,saleQuant: saleQuant,saleNetValue: _saleNetValue,);
    return _dataConnect.mutation("CreateSale", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateSaleSaleInsert {
  final String id;
  CreateSaleSaleInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSaleSaleInsert otherTyped = other as CreateSaleSaleInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateSaleSaleInsert({
    required this.id,
  });
}

@immutable
class CreateSaleData {
  final CreateSaleSaleInsert sale_insert;
  CreateSaleData.fromJson(dynamic json):
  
  sale_insert = CreateSaleSaleInsert.fromJson(json['sale_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSaleData otherTyped = other as CreateSaleData;
    return sale_insert == otherTyped.sale_insert;
    
  }
  @override
  int get hashCode => sale_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sale_insert'] = sale_insert.toJson();
    return json;
  }

  CreateSaleData({
    required this.sale_insert,
  });
}

@immutable
class CreateSaleVariables {
  final String saleProductId;
  final String saleSessionId;
  final DateTime saleDate;
  final int saleQuant;
  late final Optional<double>saleNetValue;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateSaleVariables.fromJson(Map<String, dynamic> json):
  
  saleProductId = nativeFromJson<String>(json['saleProductId']),
  saleSessionId = nativeFromJson<String>(json['saleSessionId']),
  saleDate = nativeFromJson<DateTime>(json['saleDate']),
  saleQuant = nativeFromJson<int>(json['saleQuant']) {
  
  
  
  
  
  
    saleNetValue = Optional.optional(nativeFromJson, nativeToJson);
    saleNetValue.value = json['saleNetValue'] == null ? null : nativeFromJson<double>(json['saleNetValue']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSaleVariables otherTyped = other as CreateSaleVariables;
    return saleProductId == otherTyped.saleProductId && 
    saleSessionId == otherTyped.saleSessionId && 
    saleDate == otherTyped.saleDate && 
    saleQuant == otherTyped.saleQuant && 
    saleNetValue == otherTyped.saleNetValue;
    
  }
  @override
  int get hashCode => Object.hashAll([saleProductId.hashCode, saleSessionId.hashCode, saleDate.hashCode, saleQuant.hashCode, saleNetValue.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['saleProductId'] = nativeToJson<String>(saleProductId);
    json['saleSessionId'] = nativeToJson<String>(saleSessionId);
    json['saleDate'] = nativeToJson<DateTime>(saleDate);
    json['saleQuant'] = nativeToJson<int>(saleQuant);
    if(saleNetValue.state == OptionalState.set) {
      json['saleNetValue'] = saleNetValue.toJson();
    }
    return json;
  }

  CreateSaleVariables({
    required this.saleProductId,
    required this.saleSessionId,
    required this.saleDate,
    required this.saleQuant,
    required this.saleNetValue,
  });
}

