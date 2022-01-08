import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';

class EmployeePlanningModel {
  final RawUserModel user;
  final List<PlanningModel> plannings;

  EmployeePlanningModel({
    required this.user,
    required this.plannings,
  });

  factory EmployeePlanningModel.fromJson(Map<String, dynamic> parsedJson) {
    return EmployeePlanningModel(
      user: RawUserModel(
        id: int.parse(parsedJson['id'].toString()),
        image: parsedJson["image"],
        mobile: parsedJson['mobile'],
        lastName: parsedJson['last_name'],
        firstName: parsedJson['first_name'],
        fullName: parsedJson['full_name'],
        zipCode: parsedJson['zip_code'],
        isSenior: int.parse(parsedJson['is_senior'].toString()),
        roleId: int.parse(
          parsedJson['role_id'].toString(),
        ),
        email: parsedJson['email'].toString(),
      ),
      plannings: getList(parsedJson['planning']),
    );
  }
  static List<PlanningModel> getList(List? data) {
    if (data != null) {
      List<PlanningModel> dd =
          data.map((e) => PlanningModel.fromJson(e)).toList();
      return dd;
    }
    return <PlanningModel>[];
  }
}
