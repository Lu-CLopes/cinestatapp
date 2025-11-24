part of 'example.dart';

class ReadAllProductsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ReadAllProductsVariablesBuilder(this._dataConnect, );
  Deserializer<ReadAllProductsData> dataDeserializer = (dynamic json)  => ReadAllProductsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ReadAllProductsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ReadAllProductsData, void> ref() {
    
    return _dataConnect.query("ReadAllProducts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ReadAllProductsProducts {
  final String id;
  final String productName;
  final String? productType;
  final double? productPrice;
  final bool? productActive;
  ReadAllProductsProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  productName = nativeFromJson<String>(json['productName']),
  productType = json['productType'] == null ? null : nativeFromJson<String>(json['productType']),
  productPrice = json['productPrice'] == null ? null : nativeFromJson<double>(json['productPrice']),
  productActive = json['productActive'] == null ? null : nativeFromJson<bool>(json['productActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllProductsProducts otherTyped = other as ReadAllProductsProducts;
    return id == otherTyped.id && 
    productName == otherTyped.productName && 
    productType == otherTyped.productType && 
    productPrice == otherTyped.productPrice && 
    productActive == otherTyped.productActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productName.hashCode, productType.hashCode, productPrice.hashCode, productActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productName'] = nativeToJson<String>(productName);
    if (productType != null) {
      json['productType'] = nativeToJson<String?>(productType);
    }
    if (productPrice != null) {
      json['productPrice'] = nativeToJson<double?>(productPrice);
    }
    if (productActive != null) {
      json['productActive'] = nativeToJson<bool?>(productActive);
    }
    return json;
  }

  ReadAllProductsProducts({
    required this.id,
    required this.productName,
    this.productType,
    this.productPrice,
    this.productActive,
  });
}

@immutable
class ReadAllProductsData {
  final List<ReadAllProductsProducts> products;
  ReadAllProductsData.fromJson(dynamic json):
  
  products = (json['products'] as List<dynamic>)
        .map((e) => ReadAllProductsProducts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllProductsData otherTyped = other as ReadAllProductsData;
    return products == otherTyped.products;
    
  }
  @override
  int get hashCode => products.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['products'] = products.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAllProductsData({
    required this.products,
  });
}

