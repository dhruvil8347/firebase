class CompanyModel {
  String id;
  String companyName;

  CompanyModel({
   this.id = "" ,
   this.companyName = "",
});

  factory CompanyModel.formjson(Map<String, dynamic>json){
    return CompanyModel (
      id: json['id'] ??  "",
      companyName: json['company'] ?? "",
    );


  }

  Map<String,dynamic>tojson() => {
    'id' : id,
    'companyName' : companyName,
  };



}