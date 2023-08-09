class ProductModel{
  String id;
  String productName;
  String description;
  String companyName;
  String categoryName;
  int price;
  int qty;
  List<String> productImg;

  ProductModel({
    this.id = "",
    this.companyName = "",
    this.categoryName= "",
    this.productName = "",
    this.description = "",
    this.price = 0,
    this.qty = 0,
    this.productImg = const [],
});

  factory ProductModel.formjson(Map<String,dynamic>json){
    return ProductModel(
      id: json['id'] ?? "",
      productName: json['productName'] ?? "",
      companyName: json['companyName'] ?? "",
      categoryName:json['categoryName'] ?? "",
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      qty: json['qty'] ?? 0,
      productImg: json['productImage'] ?? [],
    );
  }

  Map<String,dynamic>tojson()=>{
    "productName" : productName,
    "companyName ": companyName,
    "categoryName" : categoryName,
    "description" : description,
    "price" : price,
    "qty" : qty,
    "productImg" : productImg,

  };

}
