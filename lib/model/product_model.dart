class ProductModel{
  String id;
  String productName;
  String description;
  String companyName;
  String company; //company
  String category; // category
  String categoryName;
  int price;
  int qty;
  List productImg;

  ProductModel({
    this.id = "",
    this.companyName = "",
    this.categoryName= "",
    this.productName = "",
    this.description = "",
    this.category = "", // category
    this.company = "",  // company
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
      company: json['company'] ?? "",
      category: json['category'] ?? '',
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      qty: json['qty'] ?? 0,

      productImg: json['product_img'] ?? [],);

  }

  Map<String,dynamic>tojson()=>{
    "productName" : productName,
    "companyName":   companyName,
    "categoryName" : categoryName,
    "description" : description,
    "company" : company, // company
    "category" : category,  // category
    "price" : price,
    "qty" : qty,
    "productImg" : productImg,

  };
}


class ProductImg {
  String id;
  int productId;
  String productImgg;
  String createdAt;

  ProductImg({
    this.id = "",
    this.productId = 0,
    this.productImgg = "",
    this.createdAt = "",
  });

  factory ProductImg.fromJson(Map<String, dynamic> json) {
    return ProductImg(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productImgg: json['product_img'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'product_img': productImgg,
    'created_at': createdAt,
  };
}
