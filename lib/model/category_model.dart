class CategoryModel {
  String id;
  String categoryName;

  CategoryModel({
    this.id = "" ,
    this.categoryName = "",
  });

  factory CategoryModel.formjson(Map<String, dynamic>json){
    return CategoryModel (
      id: json['id'] ??  "",
      categoryName: json['company'] ?? "",
    );
  }

  Map<String,dynamic>tojson() => {
    'id' : id,
    'categoryName' : categoryName,
  };
}