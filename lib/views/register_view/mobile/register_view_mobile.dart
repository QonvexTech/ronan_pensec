import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/global/templates/register_template.dart';
import 'package:ronan_pensec/services/data_validator.dart';
import 'package:ronan_pensec/services/register_service.dart';

class RegisterViewMobile extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController address;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController city;
  final TextEditingController zipCode;
  final TextEditingController mobile;

  RegisterViewMobile(
      {required this.email,
      required this.password,
      required this.address,
      required this.firstName,
      required this.lastName,
      required this.city,
      required this.zipCode,
      required this.mobile});

  @override
  _RegisterViewMobileState createState() => _RegisterViewMobileState();
}

class _RegisterViewMobileState extends State<RegisterViewMobile> {
  bool _obscure = true;
  DateTime? _selectedDate;
  final RegisterService _service = RegisterService.instance;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: size.height,
          color: Colors.grey.shade200,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: Palette.gradientColor,
                        stops: Palette.colorStops)),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      // leading: IconButton(
                      //   icon: Icon(Platform.isAndroid || kIsWeb ? Icons.arrow_back : Icons.arrow_back_ios, color: Colors.white,),
                      //   onPressed: () => Navigator.of(context).pop(),
                      // ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "S'inscrire",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              RegisterTemplate.customField(controller: widget.email),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTemplate.customField(
                                  controller: widget.firstName,
                                  label: "Prénom",
                                  hintText: "Entrer votre prénom",
                                  iconData: Icons.details,
                                  type: TextInputType.name),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTemplate.customField(
                                  controller: widget.lastName,
                                  label: "Nom",
                                  hintText: "Entrer votre nom",
                                  iconData: Icons.details,
                                  type: TextInputType.name),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTemplate.customField(
                                  controller: widget.address,
                                  label: "Adresse",
                                  minLine: 1,
                                  hintText: "Entrez votre adresse",
                                  iconData: Icons.location_city,
                                  type: TextInputType.multiline),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: RegisterTemplate.customField(
                                          controller: widget.city,
                                          label: "Ville",
                                          hintText: "Ville",
                                          iconData: Icons.location_city,
                                          type: TextInputType.streetAddress),
                                    ),
                                    SizedBox(
                                      width: size.width * .03,
                                    ),
                                    Expanded(
                                      child: RegisterTemplate.customField(
                                          controller: widget.zipCode,
                                          label: "Code postal",
                                          hintText: "Code postal",
                                          iconData: Icons.location_city,
                                          type: TextInputType.numberWithOptions(decimal: true)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTemplate.pickDate(context,callback: (date){
                                setState(() {
                                  _selectedDate = date;
                                });
                              },date: _selectedDate),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTemplate.customField(
                                  controller: widget.mobile,
                                  label: "Numéro",
                                  hintText: "Numéro de téléphone",
                                  iconData: Icons.phone,
                                  type: TextInputType.phone,),
                              const SizedBox(
                                height: 20,
                              ),
                              RegisterTemplate.passwordField((value) {
                                setState(() {
                                  _obscure = value;
                                });
                              }, _obscure, widget.password),
                              const SizedBox(
                                height: 30,
                              ),
                              RegisterTemplate.registerBtn(() async {
                                if(DataValidator.isValidEmail(widget.email.text)){
                                  if(DataValidator.isValidPhoneNumber(widget.mobile.text)){

                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _isLoading= true;
                                    });
                                    Map body = {
                                      "email" : widget.email.text,
                                      "password" : widget.password.text,
                                      "address" : widget.address.text,
                                      "first_name" : widget.firstName.text,
                                      "last_name" : widget.lastName.text,
                                      "city" : widget.city.text,
                                      "zip_code" : widget.zipCode.text,
                                      "birth_date" : _selectedDate.toString(),
                                      "mobile" : widget.mobile.text
                                    };
                                    await _service.register(body,context).whenComplete(() => setState(() => _isLoading = false));
                                  }else{
                                    print("INVALID PHONE");
                                  }
                                }else{
                                  print("EMAIL NOT VALID");
                                }

                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading ? GeneralTemplate.loader(size) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
