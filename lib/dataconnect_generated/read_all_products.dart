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
  final List<ReadAllProductsProductsSalesOnSaleProduct> sales_on_saleProduct;
  ReadAllProductsProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  productName = nativeFromJson<String>(json['productName']),
  productType = json['productType'] == null ? null : nativeFromJson<String>(json['productType']),
  productPrice = json['productPrice'] == null ? null : nativeFromJson<double>(json['productPrice']),
  productActive = json['productActive'] == null ? null : nativeFromJson<bool>(json['productActive']),
  sales_on_saleProduct = (json['sales_on_saleProduct'] as List<dynamic>)
        .map((e) => ReadAllProductsProductsSalesOnSaleProduct.fromJson(e))
        .toList();
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
    productActive == otherTyped.productActive && 
    sales_on_saleProduct == otherTyped.sales_on_saleProduct;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productName.hashCode, productType.hashCode, productPrice.hashCode, productActive.hashCode, sales_on_saleProduct.hashCode]);
  

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
    json['sales_on_saleProduct'] = sales_on_saleProduct.map((e) => e.toJson()).toList();
    return json;
  }

  ReadAllProductsProducts({
    required this.id,
    required this.productName,
    this.productType,
    this.productPrice,
    this.productActive,
    required this.sales_on_saleProduct,
  });
}

@immutable
class ReadAllProductsProductsSalesOnSaleProduct {
  final int? saleQuant;
  final double? saleNetValue;
  ReadAllProductsProductsSalesOnSaleProduct.fromJson(dynamic json):
  
  saleQuant = json['saleQuant'] == null ? null : nativeFromJson<int>(json['saleQuant']),
  saleNetValue = json['saleNetValue'] == null ? null : nativeFromJson<double>(json['saleNetValue']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ReadAllProductsProductsSalesOnSaleProduct otherTyped = other as ReadAllProductsProductsSalesOnSaleProduct;
    return saleQuant == otherTyped.saleQuant && 
    saleNetValue == otherTyped.saleNetValue;
    
  }
  @override
  int get hashCode => Object.hashAll([saleQuant.hashCode, saleNetValue.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (saleQuant != null) {
      json['saleQuant'] = nativeToJson<int?>(saleQuant);
    }
    if (saleNetValue != null) {
      json['saleNetValue'] = nativeToJson<double?>(saleNetValue);
    }
    return json;
  }

  ReadAllProductsProductsSalesOnSaleProduct({
    this.saleQuant,
    this.saleNetValue,
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

