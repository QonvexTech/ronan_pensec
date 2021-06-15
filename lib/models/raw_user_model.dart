class RawUserModel {
  final int id;
  final String image;
  final String address;
  final String city;
  final DateTime birthday;
  final String mobile;
  final String lastName;
  final String firstName;
  final String fullName;
  final String zipCode;
  final int isSenior;
  RawUserModel({
    required this.id,
    required this.image,
    required this.address,
    required this.city,
    required this.birthday,
    required this.mobile,
    required this.lastName,
    required this.firstName,
    required this.fullName,
    required this.zipCode,
    required this.isSenior,
  });
  factory RawUserModel.fromJson(Map<String,dynamic> parsedJson){
    return RawUserModel(
      id : parsedJson['id'],
      image : parsedJson['image'],
      address : parsedJson['address'],
      city : parsedJson['city'],
      birthday : DateTime.parse(parsedJson['birth_date']),
      mobile : parsedJson['mobile'],
      lastName : parsedJson['last_name'],
      firstName : parsedJson['first_name'],
      fullName : parsedJson['full_name'],
      zipCode : parsedJson['zip_code'],
      isSenior : parsedJson['is_senior'],
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'image' : image,
    'address' : address,
    'city' : city,
    'birth_date' : birthday,
    'mobile' : mobile,
    'last_name' : lastName,
    'first_name' : firstName,
    'full_name' : fullName,
    'zip_code' : zipCode,
    'is_senior' : isSenior,
  };
}