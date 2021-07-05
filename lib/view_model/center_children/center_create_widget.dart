import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/raw_region_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';

class CenterCreateWidget {
  CenterCreateWidget._private();

  static final CenterCreateWidget _instance = CenterCreateWidget._private();
  static final RawRegionController _regionController =
      RawRegionController.instance;
  static final CenterDataControl _control = CenterDataControl.instance;
  static final CenterService _service = CenterService.instance(_control);
  // static final CalendarDataControl _calendarDataControl = CalendarDataControl.instance;
  // static final RegionDataControl _control = RegionDataControl.instance(_calendarDataControl);
  RawRegionController get rawRegionController => _regionController;
  // RegionService _regionService = RegionService.instance(_control);

  List<String> _address = ['', '', ''];

  static CenterCreateWidget get instance {
    _instance.setRegion = _regionController.regionData.regions[0];
    _instance._name.addListener(() {
      if (_instance._name.text.isNotEmpty) {
        _instance.appendToBody = {"name": _instance._name.text};
      } else {
        _instance.body.remove('name');
      }
    });
    _instance._street.addListener(() {
      _instance._address[0] = _instance._street.text;
    });
    _instance._city.addListener(() {
      _instance._address[2] = _instance._city.text;
      if (_instance._city.text.isNotEmpty) {
        _instance.appendToBody = {"city": _instance._city.text};
      } else {
        _instance.body.remove('city');
      }
    });
    _instance._zipCode.addListener(() {
      _instance._address[1] = _instance._zipCode.text;
      if (_instance._zipCode.text.isNotEmpty) {
        _instance.appendToBody = {"zip_code": _instance._zipCode.text};
      } else {
        _instance.body.remove('zip_code');
      }
    });
    _instance._mobile.addListener(() {
      if(_instance._mobile.text.isNotEmpty){
        _instance.appendToBody = {"mobile" : _instance._mobile.text};
      }else{
        _instance.body.remove('mobile');
      }
    });
    return _instance;
  }
  void dispose(){
    _name.clear();
    _street.clear();
    _city.clear();
    _zipCode.clear();
    _mobile.clear();
    _body.clear();
    _instance._address = ['', '', ''];
    _instance.setRegion = _regionController.regionData.regions[0];
  }
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _street = new TextEditingController();
  final TextEditingController _city = new TextEditingController();
  final TextEditingController _zipCode = new TextEditingController();
  final TextEditingController _mobile = new TextEditingController();

  Map _body = {};

  Map get body => _body;

  set appendToBody(Map data) => _body.addAll(data);
  late RegionModel? _chosenRegion;
  RegionModel? get chosenRegion => _chosenRegion;
  set setRegion(RegionModel? data) {
    _chosenRegion = data;
    _instance.appendToBody = {'region_id': "${data!.id}"};

  }
  // int? _regionId;
  //
  // set setRegion(int i) => _regionId = i;
  //
  // int? get regionId => _regionId;

  Theme themedField(
          {required TextEditingController controller,
          required String label,
          required IconData icon}) =>
      Theme(
        data: ThemeData(primaryColor: Palette.gradientColor[0]),
        child: TextField(
          controller: controller,
          cursorColor: Palette.gradientColor[0],
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: "$label",
              hintText: "$label",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(3))),
        ),
      );
  bool showErrorText = false;
  create(context, {required Size size, required loadingCallback}) => GeneralTemplate.showDialog(
        context,
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text("Obligatoire",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Palette.gradientColor[0],
                          letterSpacing: 1.5
                      ),),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.black45,
                    ),
                    this.themedField(
                        controller: _name,
                        label: "Nom",
                        icon: Icons.drive_file_rename_outline),
                    const SizedBox(
                      height: 5,
                    ),
                    this.themedField(
                        controller: _street,
                        label: "Rue",
                        icon: Icons.streetview),
                    const SizedBox(
                      height: 5,
                    ),
                    this.themedField(
                        controller: _city,
                        label: "Ville",
                        icon: Icons.location_city_outlined),
                    const SizedBox(
                      height: 5,
                    ),
                    this.themedField(
                        controller: _zipCode,
                        label: "Code de postal",
                        icon: Icons.mail_outline_rounded),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text("Optionnel",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Palette.gradientColor[0],
                          letterSpacing: 1.5
                      ),),
                    ),
                    Divider(
                      color: Colors.black45,
                      thickness: 0.5,
                    ),
                    this.themedField(controller: _mobile, label: "Numéro de contact", icon: Icons.phone_outlined),
                    Divider(
                      color: Colors.black45,
                      thickness: 0.5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      child: Text("Choisissez la région",style: TextStyle(
                        fontWeight: FontWeight.w600,
                          color: Palette.gradientColor[0],
                        fontSize: 16,
                        letterSpacing: 1.5
                      ),),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3)
                      ),
                      width: double.infinity,
                      height: 50,
                      child: this.dropdown(regionCallback: (RegionModel? region){
                        setState((){
                          _instance.setRegion = region;
                        });
                      }, currentRegion: _instance.chosenRegion!),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              if(showErrorText)...{
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,color: Colors.red,),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text("Veuillez remplir tous les champs obligatoires",style: TextStyle(
                              color: Colors.red,
                              letterSpacing: 1.5
                          ),),
                        )
                      ],
                    )
                ),
              },
              Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(
                            "ANNULER",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () async {
                          _instance.appendToBody = {
                            "address": _address.join(', ')
                          };
                          if(checkBody){
                            Navigator.of(context).pop(null);
                            print("PROCEED");
                            loadingCallback(true);
                            await _service.create(context, _instance.body).then((value) {
                              if(value){
                                _instance.dispose();
                              }
                            }).whenComplete(() => loadingCallback(false));
                          }else{
                            print("FILL ALL THE REQUIRED FIELDS");
                            setState((){
                              showErrorText = true;
                            });
                          }
                        },
                        color: Palette.gradientColor[0],
                        child: Center(
                          child: Text(
                            "SOUMETTRE",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        width: size.width,
        height: 500,
        title: ListTile(
          title: Text("Créer une centre",style: TextStyle(
            color: Palette.gradientColor[0],
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5
          ),),
          subtitle: Text("L'action ne peut pas être annulée"),
        ),
      );

  DropdownButtonHideUnderline dropdown(
          {required ValueChanged<RegionModel> regionCallback, required RegionModel currentRegion}) =>
      DropdownButtonHideUnderline(
        child: DropdownButton<RegionModel>(
          isExpanded: true,
          value: currentRegion,
          onChanged: (RegionModel? region){
            regionCallback(region!);
          },
          items: _instance.rawRegionController.regionData.regions
              .map<DropdownMenuItem<RegionModel>>(
                (e) => DropdownMenuItem<RegionModel>(child: Text("${e.name}"), value: e,),
              )
              .toList(),
        ),
      );
  List<String> _requiredFields = [
    "name",
    "region_id",
    "address",
    "city",
    "zip_code"
  ];
  bool get checkBody {
    bool checker = false;
    int counter = 0;
    _instance.body.map((key, value){
      print(key);
      if(_requiredFields.contains(key)){
        counter++;
      }

      checker = _requiredFields.contains(key) && counter == 5;
      return MapEntry(key, value);
    });
    return checker;
  }
}
