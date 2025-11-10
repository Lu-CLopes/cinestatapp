part of 'example.dart';

class CreateProductVariablesBuilder {
  String productName;
  String productType;
  double productPrice;
  bool productActive;

  final FirebaseDataConnect _dataConnect;
  CreateProductVariablesBuilder(this._dataConnect, {required  this.productName,required  this.productType,required  this.productPrice,required  this.productActive,});
  Deserializer<CreateProductData> dataDeserializer = (dynamic json)  => CreateProductData.fromJson(jsonDecode(json));
  Serializer<CreateProductVariables> varsSerializer = (CreateProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateProductData, CreateProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateProductData, CreateProductVariables> ref() {
    CreateProductVariables vars= CreateProductVariables(productName: productName,productType: productType,productPrice: productPrice,productActive: productActive,);
    return _dataConnect.mutation("createProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateProductProductInsert {
  final String id;
  CreateProductProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateProductProductInsert otherTyped = other as CreateProductProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateProductProductInsert({
    required this.id,
  });
}

@immutable
class CreateProductData {
  final CreateProductProductInsert product_insert;
  CreateProductData.fromJson(dynamic json):
  
  product_insert = CreateProductProductInsert.fromJson(json['product_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateProductData otherTyped = other as CreateProductData;
    return product_insert == otherTyped.product_insert;
    
  }
  @override
  int get hashCode => product_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_insert'] = product_insert.toJson();
    return json;
  }

  CreateProductData({
    required this.product_insert,
  });
}

@immutable
class CreateProductVariables {
  final String productName;
  final String productType;
  final double productPrice;
  final bool productActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateProductVariables.fromJson(Map<String, dynamic> json):
  
  productName = nativeFromJson<String>(json['productName']),
  productType = nativeFromJson<String>(json['productType']),
  productPrice = nativeFromJson<double>(json['productPrice']),
  productActive = nativeFromJson<bool>(json['productActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateProductVariables otherTyped = other as CreateProductVariables;
    return productName == otherTyped.productName && 
    productType == otherTyped.productType && 
    productPrice == otherTyped.productPrice && 
    productActive == otherTyped.productActive;
    
  }
  @override
  int get hashCode => Object.hashAll([productName.hashCode, productType.hashCode, productPrice.hashCode, productActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productName'] = nativeToJson<String>(productName);
    json['productType'] = nativeToJson<String>(productType);
    json['productPrice'] = nativeToJson<double>(productPrice);
    json['productActive'] = nativeToJson<bool>(productActive);
    return json;
  }

  CreateProductVariables({
    required this.productName,
    required this.productType,
    required this.productPrice,
    required this.productActive,
  });
}

