import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';

class RawCenterModel {
  final int id;
  String name;
  String? city;
  String? zipCode;
  String? address;
  String? mobile;
  String? email;
  int regionId;
  String? image;
  bool show = true;
  RawCenterModel({
    required this.id,
    required this.name,
    required this.city,
    required this.zipCode,
    required this.address,
    required this.mobile,
    required this.email,
    required this.regionId,
    this.image,
  });

  factory RawCenterModel.fromJson(Map<String, dynamic> parsedJson) {
    return RawCenterModel(
      id: int.parse(parsedJson['id'].toString()),
      name: parsedJson['name'].toString(),
      city: parsedJson['city'],
      zipCode: parsedJson['zip_code'],
      address: parsedJson['address'],
      mobile: parsedJson['mobile'],
      image: parsedJson['image'],
      email: parsedJson['email'],
      regionId: int.parse(parsedJson['region_id'].toString()),
    );
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
        'image': image
      };
}
