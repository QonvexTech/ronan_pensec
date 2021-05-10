class UserModel {
  final int id;
  String first_name;
  String last_name;
  String email;
  String address;
  DateTime birthdate;
  String city;
  String zip_code;
  String mobile;
  String image;
  int? roleId;
  int? workDays;
  int? consumableHolidays;
  // List<int>? centerIds;

  UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.address,
    required this.birthdate,
    required this.city,
    required this.zip_code,
    required this.mobile,
    required this.image,
    this.roleId,
    required this.workDays,
    required this.consumableHolidays,
    // this.centerIds,
  });

  factory UserModel.fromJson({required Map<String, dynamic> parsedJson}) {
    return UserModel(
      id: int.parse(parsedJson['id'].toString()),
      first_name: parsedJson['first_name'],
      last_name: parsedJson['last_name'],
      email: parsedJson['email'],
      address: parsedJson['address'],
      birthdate: DateTime.parse(parsedJson['birth_date'].toString()),
      city: parsedJson['city'],
      zip_code: parsedJson['zip_code'],
      mobile: parsedJson['mobile'],
      image: parsedJson['image'],
      roleId: parsedJson['roleId'],
      workDays: parsedJson['workDays'],
      consumableHolidays: parsedJson['consumableHolidays'],
      // centerIds: stringListToInt(parsedJson['centerIds']),
    );
  }

  static List<int>? stringListToInt(List data) {
    List<int>? centerIds = data.map((e) => int.parse(e.toString())).toList();
    return centerIds;
  }

  Map<String, dynamic> toJson() => {
        'int': int,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'address': address,
        'birthdate': birthdate,
        'city': city,
        'zip_code': zip_code,
        'mobile': mobile,
        'image': image,
        'roleId': roleId,
        'workDays': workDays,
        'consumableHolidays': consumableHolidays,
        // 'centerIds': centerIds,
      };
}
