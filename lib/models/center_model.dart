import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';

class CenterModel {
  final int id;
  String name;
  String? city;
  String? zipCode;
  String? address;
  String? mobile;
  String? email;
  int regionId;
  List<UserModel> users;
  String? image;
  RegionModel? region;
  UserModel? accountant;
  bool show = true;
  CenterModel(
      {required this.id,
      required this.name,
      required this.city,
      required this.zipCode,
      required this.address,
      required this.mobile,
      required this.email,
      required this.regionId,
      required this.users,
      this.region,
      this.image,
      this.accountant});

  factory CenterModel.fromJson(Map<String, dynamic> parsedJson) {
    return CenterModel(
        id: parsedJson['id'],
        name: parsedJson['name'],
        city: parsedJson['city'],
        zipCode: parsedJson['zip_code'],
        address: parsedJson['address'],
        mobile: parsedJson['mobile'],
        image: parsedJson['image'],
        email: parsedJson['email'],
        regionId: int.parse(parsedJson['region_id'].toString()),
        users: dataToList(parsedJson['users']),
        region: parsedJson['region'] != null
            ? RegionModel.fromJson(parsedJson['region'])
            : null,
        accountant: parsedJson['manager'] != null
            ? UserModel.fromJson(parsedJson: parsedJson['manager'])
            : null);
  }
  static List<UserModel> dataToList(List? data) {
    if (data != null) {
      return data.map((e) => UserModel.fromJson(parsedJson: e)).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'zip_code': zipCode,
        'address': address,
        'mobile': mobile,
        'email': email,
        'region_id': regionId,
        'users': users,
        'manager': accountant,
        'region': region,
        'image': image
      };
}
