import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/services/admin_key_auth.dart';
import 'package:ronan_pensec/services/change_email_service.dart';
import 'package:ronan_pensec/services/change_password_service.dart';
import 'package:ronan_pensec/view_model/security_and_login_view_model.dart';

class SecurityAndLogin extends StatefulWidget {
  @override
  _SecurityAndLoginState createState() => _SecurityAndLoginState();
}

class _SecurityAndLoginState extends State<SecurityAndLogin> {
  bool _editMyPassword = false;
  bool _editMyEmail = false;
  bool _editAdminValidation = false;
  bool _isLoading = false;
  bool _waitingForEmailConfirmation = false;
  static final SecurityAndLoginViewModel _securityAndLoginViewModel = SecurityAndLoginViewModel.instance;
  static final ChangePasswordService _changePasswordService = ChangePasswordService.instance;
  static final ChangeEmailService _changeEmailService = ChangeEmailService.instance;
  static final AdminKeyAuth _adminKeyAuth = AdminKeyAuth.instance;
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmationKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: Colors.grey.shade200,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Sécurité et connexion",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 1.5,
                color: Colors.black45,
              ),

              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: _editMyEmail ? 1000/sqrt( size.width * (size.width < 700 ? size.width * 0.0000165 : size.width > 900 ? 0.0125 : 0.0265)) : 60,
                child: _securityAndLoginViewModel.animatedChild(label: "Changer l'e-mail", initChild: Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text("${_securityAndLoginViewModel.credentialsPreferences.email}",style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 15
                  ),),
                ), triggeredChild: Container(
                  width: double.infinity,
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text("Vous allez maintenant changer votre email."),
                        subtitle: Text("Vous ne perdrez aucune donnée lors de la modification de votre e-mail. L'action ne peut pas être annulée"),
                        leading: Container(
                          width: 40,
                          height: 40,
                          child: Image.asset("assets/images/warning.png", color: Colors.amberAccent,),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _waitingForEmailConfirmation ? _securityAndLoginViewModel.confirmationCodeField(size, _confirmationKey) : _securityAndLoginViewModel.emailField(size,_emailFormKey),
                      if(!_waitingForEmailConfirmation)...{
                        Container(
                          width: double.infinity,
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () => setState(() => _waitingForEmailConfirmation = true),
                            child: Text("Vous avez déjà le code ?",style: TextStyle(
                                color: Palette.gradientColor[0],
                                decoration: TextDecoration.underline
                            ),textAlign: TextAlign.right,),
                          ),
                        )
                      },
                      const SizedBox(
                        height: 20,
                      ),
                      _securityAndLoginViewModel.saveAndCancelButton(size, onCancel: (){
                        setState(() {
                          _editMyEmail = false;
                          _securityAndLoginViewModel.emailValReset();
                        });
                      }, onSave: () async {
                        if(_waitingForEmailConfirmation){
                          if(_confirmationKey.currentState!.validate()){
                            setState(() {
                              _isLoading = true;
                            });
                            await _changeEmailService.confirmCode(verificationCode: _securityAndLoginViewModel.confirmationCodeFieldText.text).then((value) {
                              if(value != null){
                                setState(() {
                                  _editMyEmail = false;
                                  _waitingForEmailConfirmation = false;
                                  _securityAndLoginViewModel.credentialsPreferences.updateEmail(_securityAndLoginViewModel.newEmailField.text);
                                  _securityAndLoginViewModel.auth.loggedUser!.email = value;

                                  _securityAndLoginViewModel.emailValReset();
                                });
                              }
                            }).whenComplete(() => setState(() => _isLoading = false));
                          }
                        }else{
                          if(_emailFormKey.currentState!.validate()){
                            setState(() {
                              _isLoading = true;
                            });
                            await _changeEmailService.initiate(newEmail: _securityAndLoginViewModel.newEmailField.text).then((value) => setState(() => _waitingForEmailConfirmation = value)).whenComplete(() => setState(() => _isLoading = false));
                          }
                        }

                      }),
                    ],
                  ),
                ), triggered: _editMyEmail, onPressed: (){
                  setState(() {
                    _editMyEmail = true;
                  });
                }),
              ),
              Divider(
                color: Colors.black45,
                thickness: 1,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: _editMyPassword ? 1000/sqrt( size.width * (size.width < 700 ? size.width * 0.000011 : size.width > 900 ? 0.006 : 0.013)) : 60,
                child: _securityAndLoginViewModel.animatedChild(
                    label: "Changer le mot de passe",
                    initChild: Container(
                      width: double.infinity,
                      height: 60,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text("${_securityAndLoginViewModel.passwordizedText}",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5
                      ),),
                    ),
                    triggeredChild: Container(
                      width: double.infinity,
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              child: Image.asset("assets/images/warning.png", color: Colors.amberAccent,),
                            ),
                            title: Text("Vous allez modifier votre mot de passe"),
                            subtitle: Text("Lors de la soumission, le système mettra à jour les informations d'identification enregistrées dans votre appareil. L'action ne peut pas être annulée"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _securityAndLoginViewModel.passwordFields(size, _passwordFormKey),
                          const SizedBox(
                            height: 20,
                          ),
                          _securityAndLoginViewModel.saveAndCancelButton(size, onCancel: (){
                            setState(() {
                              _editMyPassword = false;
                              _securityAndLoginViewModel.passwordValReset();
                            });
                          }, onSave: () async {
                            if(_passwordFormKey.currentState!.validate()){
                              setState(() {
                                _isLoading = true;
                              });
                              await _changePasswordService.loggedUser(newPassword: _securityAndLoginViewModel.newPasswordField.text).then((value) {
                                if(value){
                                  setState(() {
                                    _securityAndLoginViewModel.credentialsPreferences.updatePassword(_securityAndLoginViewModel.newPasswordField.text);
                                    _securityAndLoginViewModel.passwordValReset();
                                    _editMyPassword = false;
                                  });
                                }
                              }).whenComplete(() => setState(() {
                                _isLoading = false;
                              }));
                            }
                          }),
                        ],
                      ),
                    ),
                    triggered: _editMyPassword,
                    onPressed: (){
                      setState(() {
                        _editMyPassword = true;
                      });
                    }
                ),
              ),
              Divider(
                color: Colors.black45,
                thickness: 1,
              ),
              if(_securityAndLoginViewModel.auth.loggedUser!.roleId == 1)...{
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: _editAdminValidation ? 1000/sqrt( size.width * (size.width < 700 ? size.width * 0.0000155 : size.width > 900 ? 0.008 : 0.022)) : 60,
                  child: _securityAndLoginViewModel.animatedChild(label: "Clé de validation administrateur", initChild: Container(
                    height: 60,
                    width: double.infinity,
                    child: ListTile(
                      leading: Icon(Icons.security, color: Colors.green,),
                      title: Text("Clé administrateur",maxLines: size.width < 600 ? 1 : null, overflow: TextOverflow.ellipsis,),
                      subtitle: Text("Attention : Cette clé permet de réinitialiser manuellement les congés de l'utilisateur",maxLines: size.width < 600 ? 1 : null, overflow: TextOverflow.ellipsis,),
                    ),
                  ), triggeredChild: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.security, color: Colors.green,),
                        title: Text("Clé administrateur"),
                        subtitle: Text("Attention : Cette clé permet de réinitialiser manuellement les congés de l'utilisateur"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _securityAndLoginViewModel.oldAdminKey(size),
                      const SizedBox(
                        height: 10,
                      ),
                      _securityAndLoginViewModel.newAdminKey(size, _adminFormKey),
                      const SizedBox(
                        height: 20,
                      ),
                      _securityAndLoginViewModel.saveAndCancelButton(size, onCancel: (){
                        setState(() {
                          _editAdminValidation = false;
                          _securityAndLoginViewModel.adminKeyField.clear();
                        });
                      }, onSave: () async {
                        if(_adminFormKey.currentState!.validate()){
                          setState(() {
                            _isLoading = true;
                          });
                          await _adminKeyAuth.check(key: _securityAndLoginViewModel.oldAdminKeyController.text).then((value) async {
                            if(value){
                              await _changePasswordService.superAdmin(newPassword: _securityAndLoginViewModel.adminKeyField.text).then((value) {
                                if(value){
                                  setState(() {
                                    _editAdminValidation = false;
                                    _securityAndLoginViewModel.adminKeyField.clear();
                                  });
                                }
                              }).whenComplete(() => setState(() => _isLoading = false));
                            }else{
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          });

                        }
                      })
                    ],
                  ), triggered: _editAdminValidation, onPressed: (){
                    setState(() {
                      _editAdminValidation = true;
                    });
                  }),
                ),
                Divider(
                  color: Colors.black45,
                  thickness: 1,
                )
              }
            ],
          ),
        ),
        _isLoading ? GeneralTemplate.loader(size) : Container()
      ],
    );
  }
}
