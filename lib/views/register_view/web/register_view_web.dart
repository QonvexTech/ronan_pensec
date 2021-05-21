import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/animated_widget.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/global/templates/register_template.dart';
import 'package:ronan_pensec/services/data_validator.dart';
import 'package:ronan_pensec/services/register_service.dart';

class RegisterViewWeb extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController address;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController city;
  final TextEditingController zipCode;
  final TextEditingController mobile;

  RegisterViewWeb(
      {required this.email,
      required this.password,
      required this.address,
      required this.firstName,
      required this.lastName,
      required this.city,
      required this.zipCode,
      required this.mobile});

  @override
  _RegisterViewWebState createState() => _RegisterViewWebState();
}

class _RegisterViewWebState extends State<RegisterViewWeb> {
  DateTime? _selectedDate;
  bool _obscure = true;
  bool _isLoading = false;
  final RegisterService _service = RegisterService.instance;
  Duration duration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool _kMobile = size.width < 900;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Row(
          children: [
            if (!_kMobile) ...{
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: Palette.gradientColor,
                        // stops: Palette.colorStops,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/images/background.jpeg")
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        AnimatedWidgetX(
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                "Sécur AUTO".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .fontSize! -
                                        1,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            delay: 1,
                            duration: duration),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedWidgetX(
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Planning & Gestion d'équipe",
                              style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .fontSize! -
                                      5,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          delay: 2,
                          duration: duration,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            },
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedWidgetX(
                    delay: 0.5,
                    duration: duration,
                    child: Container(
                      width: double.infinity,
                      child: Scrollbar(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * .06, vertical: 15),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_kMobile) ...{
                                  AnimatedWidgetX(
                                    child: Container(
                                      width: double.infinity,
                                      height: size.height * .2,
                                      child: Center(
                                        child: Image.asset("assets/images/logo.png"),
                                      ),
                                    ),
                                    duration: duration,
                                    delay: 0.5,
                                  )
                                },
                                AnimatedWidgetX(
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        top: 45,bottom: 30),
                                    child: Text(
                                      "Faites partie de nous",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .fontSize,
                                          color: Palette.textFieldColor,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  delay: 1,
                                  duration: duration,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                AnimatedWidgetX(
                                    child: RegisterTemplate.customField(
                                        controller: widget.email),
                                    delay: 1.3,
                                    duration: duration),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                    child: RegisterTemplate.customField(
                                        controller: widget.firstName,
                                        label: "Prénom",
                                        hintText: "Entrer votre prénom",
                                        iconData: Icons.details,
                                        type: TextInputType.name),
                                    delay: 1.5,
                                    duration: duration),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                    child: RegisterTemplate.customField(
                                        controller: widget.lastName,
                                        label: "Nom",
                                        hintText: "Entrer votre nom",
                                        iconData: Icons.details,
                                        type: TextInputType.name),
                                    delay: 1.8,
                                    duration: duration),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                    child: RegisterTemplate.customField(
                                        controller: widget.address,
                                        label: "Adresse",
                                        minLine: 2,
                                        hintText: "Entrez votre adresse",
                                        iconData: Icons.location_city,
                                        type: TextInputType.multiline),
                                    delay: 2,
                                    duration: duration),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                  child: Container(
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: RegisterTemplate.customField(
                                              controller: widget.city,
                                              label: "Ville",
                                              hintText: "Ville",
                                              iconData: Icons.location_city,
                                              type:
                                                  TextInputType.streetAddress),
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
                                              type: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  delay: 2.3,
                                  duration: duration,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                  child: RegisterTemplate.customField(
                                    controller: widget.mobile,
                                    label: "Numéro",
                                    hintText: "Numéro de téléphone",
                                    iconData: Icons.phone,
                                    type: TextInputType.phone,
                                  ),
                                  delay: 2.5,
                                  duration: duration,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                  child: RegisterTemplate.pickDate(context,
                                      callback: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                  }, date: _selectedDate),
                                  delay: 2.8,
                                  duration: duration,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedWidgetX(
                                    child:
                                        RegisterTemplate.passwordField((value) {
                                      setState(() {
                                        _obscure = value;
                                      });
                                    }, _obscure, widget.password),
                                    delay: 3,
                                    duration: duration),
                                const SizedBox(
                                  height: 30,
                                ),
                                AnimatedWidgetX(
                                    child:
                                        RegisterTemplate.registerBtn(() async {
                                      if (DataValidator.isValidEmail(
                                          widget.email.text)) {
                                        if (DataValidator.isValidPhoneNumber(
                                            widget.mobile.text)) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          FocusScope.of(context).unfocus();
                                          Map body = {
                                            "email": widget.email.text,
                                            "password": widget.password.text,
                                            "address": widget.address.text,
                                            "first_name": widget.firstName.text,
                                            "last_name": widget.lastName.text,
                                            "city": widget.city.text,
                                            "zip_code": widget.zipCode.text,
                                            "birth_date":
                                                _selectedDate.toString(),
                                            "mobile": widget.mobile.text
                                          };
                                          await _service
                                              .register(body, context)
                                              .whenComplete(() => setState(
                                                  () => _isLoading = false));
                                        } else {
                                          _service.notifier
                                              .showContextedBottomToast(context,msg: "Invalid phone number");
                                        }
                                      } else {
                                        _service.notifier
                                            .showContextedBottomToast(context,msg: "Invalid email");
                                      }
                                    }),
                                    delay: 3.3,
                                    duration: duration),
                                AnimatedWidgetX(
                                    child: RegisterTemplate.orLoginText,
                                    delay: 3.5,
                                    duration: duration),
                                AnimatedWidgetX(
                                    child: Container(
                                      width: double.infinity,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          border: Border.all(
                                              color: Palette.textFieldColor, width: 2)),
                                      child: MaterialButton(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        splashColor: Colors.grey.shade200,
                                        hoverColor: Colors.transparent,
                                        minWidth: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Center(
                                          child: Text(
                                            "S'IDENTIFIER",
                                            style: TextStyle(
                                              color: Palette.textFieldColor,
                                              letterSpacing: 2.0,
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    delay: 3.5,
                                    duration: duration)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _isLoading ? GeneralTemplate.loader(size) : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: Palette.gradientColor,
    //         stops: Palette.colorStops),
    //   ),
    //   child: Stack(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(
    //             horizontal: size.width * .2, vertical: size.height * .1),
    //         child: Center(
    //           child: Container(
    //             width: double.infinity,
    //             height: size.height,
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(10),
    //                 gradient: LinearGradient(
    //                     begin: Alignment.topCenter,
    //                     end: Alignment.bottomCenter,
    //                     colors: Palette.gradientColor,
    //                     stops: Palette.colorStops),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: Colors.black26,
    //                       blurRadius: 5,
    //                       offset: Offset(3, 2))
    //                 ]),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.symmetric(
    //             horizontal: size.width * .3, vertical: size.height * .1),
    //         child: Center(
    //           child: Container(
    //             width: double.infinity,
    //             height: size.height,
    //             child: Container(
    //               height: double.infinity,
    //               width: double.infinity,
    //               child: SingleChildScrollView(
    //                 physics: AlwaysScrollableScrollPhysics(),
    //                 padding:
    //                     EdgeInsets.symmetric(horizontal: 40, vertical: 120),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       "S'inscrire",
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 30,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                     const SizedBox(
    //                       height: 30,
    //                     ),
    //                     RegisterTemplate.customField(controller: widget.email),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     RegisterTemplate.customField(
    //                         controller: widget.firstName,
    //                         label: "Prénom",
    //                         hintText: "Entrer votre prénom",
    //                         iconData: Icons.details,
    //                         type: TextInputType.name),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     RegisterTemplate.customField(
    //                         controller: widget.lastName,
    //                         label: "Nom",
    //                         hintText: "Entrer votre nom",
    //                         iconData: Icons.details,
    //                         type: TextInputType.name),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     RegisterTemplate.customField(
    //                         controller: widget.address,
    //                         label: "Adresse",
    //                         minLine: 3,
    //                         hintText: "Entrez votre adresse",
    //                         iconData: Icons.location_city,
    //                         type: TextInputType.multiline),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     Container(
    //                       width: size.width,
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: RegisterTemplate.customField(
    //                                 controller: widget.city,
    //                                 label: "Ville",
    //                                 hintText: "Ville",
    //                                 iconData: Icons.location_city,
    //                                 type: TextInputType.streetAddress),
    //                           ),
    //                           SizedBox(
    //                             width: size.width * .03,
    //                           ),
    //                           Expanded(
    //                             child: RegisterTemplate.customField(
    //                                 controller: widget.zipCode,
    //                                 label: "Code postal",
    //                                 hintText: "Code postal",
    //                                 iconData: Icons.location_city,
    //                                 type: TextInputType.numberWithOptions(
    //                                     decimal: true)),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     RegisterTemplate.pickDate(context, callback: (date) {
    //                       setState(() {
    //                         _selectedDate = date;
    //                       });
    //                     }, date: _selectedDate),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     RegisterTemplate.customField(
    //                       controller: widget.mobile,
    //                       label: "Numéro",
    //                       hintText: "Numéro de téléphone",
    //                       iconData: Icons.phone,
    //                       type: TextInputType.phone,
    //                     ),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     RegisterTemplate.passwordField((value) {
    //                       setState(() {
    //                         _obscure = value;
    //                       });
    //                     }, _obscure, widget.password),
    //                     const SizedBox(
    //                       height: 30,
    //                     ),
    //                     RegisterTemplate.registerBtn(() async {
    //                       if (DataValidator.isValidEmail(widget.email.text)) {
    //                         if (DataValidator.isValidPhoneNumber(
    //                             widget.mobile.text)) {
    //                           setState(() {
    //                             _isLoading= true;
    //                           });
    //                           FocusScope.of(context).unfocus();
    //                           Map body = {
    //                             "email": widget.email.text,
    //                             "password": widget.password.text,
    //                             "address": widget.address.text,
    //                             "first_name": widget.firstName.text,
    //                             "last_name": widget.lastName.text,
    //                             "city": widget.city.text,
    //                             "zip_code": widget.zipCode.text,
    //                             "birth_date": _selectedDate.toString(),
    //                             "mobile": widget.mobile.text
    //                           };
    //                           await _service.register(body, context).whenComplete(() => setState(() => _isLoading = false));
    //                         } else {
    //                           _service.notifier.showContextedBottomToast(context, msg: "Invalid phone number");
    //                         }
    //                       } else {
    //                         _service.notifier.showContextedBottomToast(context, msg: "Invalid email");
    //                       }
    //                     }),
    //                     RegisterTemplate.orLoginText,
    //                     Container(
    //                       width: double.infinity,
    //                       height: 60,
    //                       decoration: BoxDecoration(
    //                           color: Colors.transparent,
    //                           borderRadius: BorderRadius.circular(60),
    //                           border:
    //                               Border.all(color: Colors.white, width: 2)),
    //                       child: MaterialButton(
    //                         color: Colors.transparent,
    //                         elevation: 0,
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(60)),
    //                         onPressed: () => Navigator.of(context).pop(),
    //                         splashColor: Colors.grey.shade300,
    //                         hoverColor: Colors.transparent,
    //                         minWidth: double.infinity,
    //                         padding: const EdgeInsets.symmetric(vertical: 20),
    //                         child: Center(
    //                           child: Text(
    //                             "S'IDENTIFIER",
    //                             style: TextStyle(
    //                               color: Colors.white,
    //                               letterSpacing: 2.0,
    //                               fontSize: 16.5,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
