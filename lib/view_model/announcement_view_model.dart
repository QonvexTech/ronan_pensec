import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/global/user_raw_data.dart';
import 'package:ronan_pensec/models/notification_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';

class AnnouncementViewModel {
  AnnouncementViewModel._private();

  static final AnnouncementViewModel _instance =
      AnnouncementViewModel._private();
  static final Auth _auth = Auth.instance;
  static final UserRawData _userRawData = UserRawData.instance;

  UserRawData get userRawDataControl => _userRawData;

  static AnnouncementViewModel get instance {
    _instance.title.addListener(() {
      if (_instance.title.text.isNotEmpty) {
        _instance.appendToBody = {"title": _instance.title.text};
      } else {
        _instance.body.remove('title');
      }
    });
    _instance.message.addListener(() {
      if (_instance.message.text.isNotEmpty) {
        _instance.appendToBody = {"message": _instance.message.text};
      } else {
        _instance.body.remove('message');
      }
    });
    _instance.appendToBody = {'sender_id': _auth.loggedUser!.id.toString(), "type" : "0"};
    return _instance;
  }

  final TextEditingController title = new TextEditingController();
  final TextEditingController message = new TextEditingController();

  Map _body = {};

  Map get body => _body;

  set appendToBody(Map data) => _body.addAll(data);

  void clearDataBody() {
    _instance._body.clear();
    _instance.appendToBody = {'sender_id': _auth.loggedUser!.id.toString(), "type" : "0"};
  }

  RawUserModel? _receiver;

  RawUserModel? get receiver => _receiver;

  set setReceiver(RawUserModel? user) {
    _receiver = user;
    if (user != null) {
      _instance.appendToBody = {'receiver_id': user.id.toString()};
    } else {
      _instance.body.remove('receiver_id');
    }
  }

  String? _base64Image;

  String? get base64Image => _base64Image;

  String? setImage(String? b64) {
    _base64Image = b64;
    if (b64 != null) {
      _instance.appendToBody = {"image": "data:image/jpg;base64,$b64"};
    } else {
      _instance.body.remove('image');
    }
  }
  void dispose() {
    _instance.clearDataBody();
    _instance.setDropdownValue = _dropdownMenu[0];
    _instance.setReceiver = null;
    _instance.setImage(null);
    _instance.title.clear();
    _instance.message.clear();
  }
  GlobalKey<FormState> titleFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> messageFormKey = new GlobalKey<FormState>();
  Widget get titleField => Theme(
        data: ThemeData(primaryColor: Palette.gradientColor[0]),
        child: Form(
          key: titleFormKey,
          child: TextFormField(
            validator: (text){
              if(text!.isEmpty){
                return "Ce champ est obligatoire, merci de renseigner";
              }
            },
            controller: _instance.title,
            cursorColor: Palette.gradientColor[0],
            decoration: InputDecoration(
              labelText: "Titre de l'annonce *",
              hintText: "Votre titre",
              prefixIcon: Icon(Icons.title)
            ),
          ),
        )
      );
  Widget get messageField => Theme(
      data: ThemeData(primaryColor: Palette.gradientColor[0]),
      child: Form(
        key: messageFormKey,
        child: TextFormField(
          maxLines: null,
          minLines: 4,
          validator: (text){
            if(text!.isEmpty){
              return "Ce champ est obligatoire, merci de renseigner";
            }
          },
          controller: _instance.message,
          cursorColor: Palette.gradientColor[0],
          decoration: InputDecoration(
              labelText: "Contenu de l'annonce *",
              hintText: "Contenu",
              prefixIcon: Icon(Icons.content_copy)
          ),
        ),
      )
  );

  bool validateTexts(){
    bool titleIsValid = titleFormKey.currentState!.validate();
    bool messageIsValid = messageFormKey.currentState!.validate();
    return titleIsValid && messageIsValid;
  }
  List<Map> _dropdownMenu = [
    {
      "value" : 0,
      "title" : "Basse",
      "description" : "Ceci est un avis de base, pas d'interruptions et pas de données à voir"
    },
    {
      "value" : 1,
      "title" : "Moyen",
      "description" : "Une importance moyenne vous montrera des données"
    },
    {
      "value" : 2,
      "title" : "Haut",
      "description" : "Cela provoquera des interruptions dans le récepteur et des détails flash à l'écran"
    }
  ];
  late Map _dropdownValue = _dropdownMenu[0];
  Map get dropdownValue => _dropdownValue;
  set setDropdownValue(Map data) {
    _dropdownValue = data;
    _instance.appendToBody = {'type' : data['value'].toString()};
  }
  DropdownButton dropdownButtonType({required ValueChanged<Map> chosen, required Map value}) => DropdownButton(
    value: value,
      isExpanded: true,
      hint: Text("Importance de l'annonce"),
      onChanged: (val){
        if(val != null){
          chosen(val);
        }
      },
      items: _dropdownMenu.map<DropdownMenuItem>((e) => DropdownMenuItem(
        child: Text("${e['title']}"),
        value: e,
      )).toList()
  );

  void showNotice(context, Size size, {required NotificationModel notification}) {
    GeneralTemplate.showDialog(
      context,
      child: notification.data?['image'] != null ?  ListView(
        children: [
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text("${notification.data?['message']}",style: TextStyle(
              fontSize: 17,
            ),),
          ),
          Container(
            width: double.infinity,
            child: Image(
              fit: BoxFit.fitWidth,
              image: NetworkImage("${notification.data?['image']}"),
            ),
          ),
        ],
      ) : Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text("${notification.data?['message']}",style: TextStyle(
          fontSize: 17,
        ),),
      ),
      width: size.width,
      height:
      notification.data?['image'] != null
          ? 300
          : 100,
      title: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          child: Image.asset(
            "assets/images/info.png",
            color: notification
                .data?['type'] ==
                2
                ? Colors.red
                : notification
                .data?['type'] ==
                1
                ? Colors.orange
                : Colors.green,
          ),
        ),
        title: Text(
          notification.title,
          // notification.data?['type'] == 2
          //     ? "Avis très important !"
          //     : notification.data?['type'] ==
          //     1
          //     ? "Attention"
          //     : "Remarquer",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        subtitle: Text(
          "${notification.message}",
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
