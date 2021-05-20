import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';

class CenterViewWidgetHelper {
  final CenterDataControl _control = CenterDataControl.instance;
  late final CenterService _service = CenterService.instance(_control);
  CenterViewWidgetHelper._singleton();
  static final CenterViewWidgetHelper _instance = CenterViewWidgetHelper._singleton();
  static CenterViewWidgetHelper get instance => _instance;
  TextEditingController _name = new TextEditingController();
  TextEditingController _address=  new TextEditingController();
  TextEditingController _number= new TextEditingController();
  TextEditingController _email = new TextEditingController();


  void showEditDialog(context, {required CenterModel center, required double width, bool isMobile = false, required ValueChanged<bool> callback}){
    _email.text = center.email;
    _name.text = center.name;
    _address.text = center.address;
    _number.text = center.mobile;
    GeneralTemplate.showDialog(context,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          hintText: "Entrez nouveau nom",
                          prefixIcon: Icon(Icons.drive_file_rename_outline),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => _name.clear(),
                          )
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            hintText: "Entrez nouveau email",
                            prefixIcon: Icon(Icons.email),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _email.clear(),
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _address,
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            hintText: "Entrez nouveau addressé",
                            alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.location_city_outlined)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                        child: MaterialButton(
                          color: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          onPressed: (){
                            Navigator.of(context).pop(null);
                          },
                          child: Center(
                            child: Text("Annuler".toUpperCase(), style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                        )
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: MaterialButton(
                          color: Palette.gradientColor[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          onPressed: (){

                            Navigator.of(context).pop(null);
                            // callback(true);
                            // _service.delete(context, centerId: centerId).whenComplete(() => callback(false));
                          },
                          child: Center(
                            child: Text("Mettre à jour".toUpperCase(), style: TextStyle(
                                letterSpacing: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        width: width,
        height: 320,
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              child: Image.asset("assets/images/info.png"),
            ),
            Expanded(
                child: ListTile(
                  title: Text("Vous êtes en train de mettre à jour un centre"),
                  subtitle: Text("Cette action ne peut pas être annulée"),
                )
            )
          ],
        )
    );
    return ;
  }
  void showDialog(context,{required String centerName, required int centerId, required double width, bool isMobile = false, required ValueChanged<bool> callback}) {
    GeneralTemplate.showDialog(context,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text("[$centerName], est sur le point d'être supprimé, voulez-vous continuer?",style: TextStyle(
                    color: Colors.grey.shade800,
                    fontStyle: FontStyle.italic,
                    fontSize: 14
                ),textAlign: TextAlign.left,),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                        child: MaterialButton(
                          color: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          onPressed: (){
                            Navigator.of(context).pop(null);
                          },
                          child: Center(
                            child: Text("Annuler".toUpperCase(), style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                        )
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: MaterialButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          onPressed: (){

                            Navigator.of(context).pop(null);
                            callback(true);
                            _service.delete(context, centerId: centerId).whenComplete(() => callback(false));
                          },
                          child: Center(
                            child: Text("Effacer".toUpperCase(), style: TextStyle(
                                letterSpacing: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        width: width,
        height: isMobile ? 120 : 100,
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              child: Image.asset("assets/images/warning.png"),
            ),
            Expanded(
                child: ListTile(
                  title: Text("Supprimer le centre"),
                  subtitle: Text("Cette action ne peut pas être annulée"),
                )
            )
          ],
        )
    );
  }
}