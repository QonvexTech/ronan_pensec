class CenterModel{
  final int id;
  String name;
  String city;
  String zipCode;
  String address;
  String mobile;
  String email;
  int regionId;

  CenterModel({
    required this.id,
    required this.name,
    required this.city,
    required this.zipCode,
    required this.address,
    required this.mobile,
    required this.email,
    required this.regionId,
  });


  factory CenterModel.fromJson(Map<String,dynamic> parsedJson){
    return CenterModel(
      id : parsedJson['id'],
      name : parsedJson['name'],
      city : parsedJson['city'],
      zipCode : parsedJson['zip_code'],
      address : parsedJson['address'],
      mobile : parsedJson['mobile'],
      email : parsedJson['email'],
      regionId : int.parse(parsedJson['region_id'].toString()),
    );
  }

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'name' : name,
    'city' : city,
    'zip_code' : zipCode,
    'address' : address,
    'mobile' : mobile,
    'email' : email,
    'region_id' : regionId,
  };

}