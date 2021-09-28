class RawUserModel {
  final int id;
  final String image;
  final String? mobile;
  final String lastName;
  final String firstName;
  final String fullName;
  final String? zipCode;
  int isActive;
  final int roleId;
  final int isSenior;
  RawUserModel({
    required this.id,
    required this.image,
    required this.mobile,
    this.isActive = 1,
    required this.lastName,
    required this.firstName,
    required this.fullName,
    required this.zipCode,
    required this.isSenior,
    required this.roleId,
  });
  factory RawUserModel.fromJson(Map<String, dynamic> parsedJson) {
    return RawUserModel(
        id: int.parse(parsedJson['id'].toString()),
        image: parsedJson['image'],
        mobile: parsedJson['mobile'],
        lastName: parsedJson['last_name'],
        firstName: parsedJson['first_name'],
        fullName: parsedJson['full_name'],
        zipCode: parsedJson['zip_code'],
        isActive: int.parse(parsedJson['isActive'].toString()),
        isSenior: int.parse(parsedJson['is_senior'].toString()),
        roleId: int.parse(parsedJson['role_id'].toString()));
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'mobile': mobile,
        'last_name': lastName,
        'first_name': firstName,
        'full_name': fullName,
        'zip_code': zipCode,
        'is_senior': isSenior,
        'role_id': roleId,
        'isActive': isActive,
      };
}
