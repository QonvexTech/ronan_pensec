import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/center_endpoint.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/raw_center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class CenterService {
  late CenterDataControl _centerDataControl;
  CenterService._singleton();

  static final CenterService _instance = CenterService._singleton();
  late final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final Auth _auth = Auth.instance;

  static CenterService instance(CenterDataControl control) {
    _instance._centerDataControl = control;
    return _instance;
  }

  bool userIsAssigned({required List<UserModel> sauce, required int id}) {
    for (UserModel user in sauce) {
      if (user.id == id) {
        return true;
      }
    }
    return false;
  }

  Future<List<CenterModel>?> fetchAssignedCenter({required int userId}) async {
    try {
      return await http.get(
        Uri.parse(
            "${BaseEnpoint.URL}${CenterEndpoint.getMyCenters(userId: userId)}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
        },
      ).then((response) {
        var data = json.decode(response.body);
        print(data);
        if (response.statusCode == 200) {
          print("CENTER DATA : $data");
          List<CenterModel> centers = [];
          for (var d in data) {
            centers.add(CenterModel.fromJson(d));
          }
          return centers;
        }
        notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> update(context,
      {required Map body, required int centerId}) async {
    try {
      print(body);
      return await http.put(
          Uri.parse(
              "${BaseEnpoint.URL}${CenterEndpoint.update(centerId: centerId)}"),
          body: body,
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((respo) {
        if (respo.statusCode == 200 || respo.statusCode == 201) {
          _notifier.showContextedBottomToast(context,
              msg: "Mise à jour réussie");
          return true;
        }
        _notifier.showContextedBottomToast(context,
            msg:
                "Une erreur s'est produite (${respo.statusCode}), veuillez réessayer plus tard ou contacter l'administrateur");
        return false;
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context,
          msg: "UPDATE ERROR Erreur $e");
      return false;
    }
  }

  Future<String?> updateImage(
      {required int centerId, required String base64Image}) async {
    try {
      return await http.post(
          Uri.parse(
              "${BaseEnpoint.URL}${CenterEndpoint.base}/update_center_photo/$centerId"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          },
          body: {
            "image": "data:image/jpg;base64,$base64Image"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "Misé a hour reussie");
          return data['data'];
        }
        _notifier.showUnContextedBottomToast(
            msg:
                "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard ou contacter l'administrateur");
        return null;
      });
    } catch (e) {
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
      return null;
    }
  }

  Future<bool> fetch(context) async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.viewAll}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (data is List) {
            _centerDataControl.populateAll(data);
          } else {
            _centerDataControl.populateAll([data]);
          }
          return true;
        } else {
          _notifier.showContextedBottomToast(context,
              msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }

  Future delete(context, {required int centerId}) async {
    try {
      await http.delete(
          Uri.parse(
              "${BaseEnpoint.URL}${CenterEndpoint.deleteCenter(centerId: centerId)}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        if (response.statusCode == 200) {
          _centerDataControl.remove(centerId);
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }

  Future<bool> create(context, Map body) async {
    try {
      return await http
          .post(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.create}"),
              headers: {
                "Accept": "application/json",
                HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
              },
              body: body)
          .then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          _notifier.showUnContextedBottomToast(msg: "Ajout réussi");
          _centerDataControl.append(data);
          return true;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return false;
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }

  Future<bool> removeAssignment(context,
      {required int userId, required centerId}) async {
    try {
      return await http.post(
          Uri.parse(
              "${BaseEnpoint.URL}${CenterEndpoint.removeAssignedUser(centerId)}"),
          body: {
            "user_id": userId.toString()
          },
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((value) {
        if (value.statusCode == 200) {
          notifier.showWebContextedBottomToast(context,
              msg: "Supprimer le succès");
          return true;
        } else {
          notifier.showWebContextedBottomToast(context,
              msg: "La suppression a échoué");
          return false;
        }
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> assignManager(context,
      {required int centerId, required int userId}) async {
    try {
      return await http.post(
          Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.assignManager}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          },
          body: {
            "center_ids": centerId.toString(),
            "user_id": userId.toString()
          }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          _notifier.showContextedBottomToast(context,
              msg: "Un nouveau manager a été affecté");
          return true;
        }
        _notifier.showContextedBottomToast(context,
            msg:
                "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard");
        return false;
      });
    } catch (e) {
      print("$e");
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }

  Future<bool> updateRegion(context,
      {required regionId, required centerId}) async {
    try {
      return await http.post(
          Uri.parse(
              "${BaseEnpoint.URL}${CenterEndpoint.updateRegion(centerId: centerId)}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          },
          body: {
            "region_id": regionId.toString(),
          }).then((respo) {
        if (respo.statusCode == 200 || respo.statusCode == 201) {
          _notifier.showContextedBottomToast(context,
              msg: "Mise à jour réussie");
          return true;
        }
        _notifier.showContextedBottomToast(context,
            msg:
                "Une erreur s'est produite (${respo.statusCode}), veuillez réessayer plus tard");
        return false;
      });
    } catch (e) {
      print("$e");
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }
}
