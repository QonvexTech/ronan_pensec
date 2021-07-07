import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/credentials_preferences.dart';

class SecurityAndLoginViewModel {
  SecurityAndLoginViewModel._privateConstructor();
  static final SecurityAndLoginViewModel _instance = SecurityAndLoginViewModel._privateConstructor();
  static SecurityAndLoginViewModel get instance => _instance;
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  final RegExp _passwordRegexp = new RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$");
  final RegExp _emailRegEx = new RegExp(r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?");
  final TextEditingController _oldPasswordField = new TextEditingController();
  final TextEditingController _newPasswordField = new TextEditingController();
  final TextEditingController _newPasswordConfirmation = new TextEditingController();

  TextEditingController get newPasswordField => _newPasswordField;
  bool showNewPassword = false;
  bool showOldPassword = false;

  static final CredentialsPreferences _credentialsPreferences = CredentialsPreferences.instance;
  CredentialsPreferences get credentialsPreferences => _credentialsPreferences;
  final TextEditingController _newEmailField = new TextEditingController();
  TextEditingController get newEmailField => _newEmailField;
  final TextEditingController _confirmationCodeField = new TextEditingController();
  TextEditingController get confirmationCodeFieldText => _confirmationCodeField;
  final TextEditingController _oldAdminKeyFieldController = new TextEditingController();
  TextEditingController get oldAdminKeyController => _oldAdminKeyFieldController;

  final TextEditingController _adminKeyField = new TextEditingController();
  TextEditingController get adminKeyField => _adminKeyField;


  void emailValReset(){
    _newEmailField.clear();
    _confirmationCodeField.clear();
  }
  void passwordValReset() {
    _oldPasswordField.clear();
    _newPasswordField.clear();
    _newPasswordConfirmation.clear();
  }
  Theme themedField(String label,TextEditingController controller,{required bool isEmail, ValueChanged<Map>? passwordObscureCallback}) => Theme(
    data: ThemeData(primaryColor: Palette.gradientColor[0]),
    child: TextFormField(
      obscureText: isEmail ? false : controller == _oldPasswordField ? !showOldPassword : !showNewPassword,
      validator: (text){
        if(text!.isEmpty){
          return "Ne laissez pas de champs vides";
        }
        if(controller == _newPasswordField || controller == _newPasswordConfirmation){
          if(_newPasswordConfirmation.text != _newPasswordField.text){
            return "Nouvelle incompatibilité de mot de passe";
          }
          if(!_passwordRegexp.hasMatch(_newPasswordConfirmation.text) || !_passwordRegexp.hasMatch(_newPasswordField.text)){
            return "Le mot de passe doit avoir un minimum de huit caractères, au moins une lettre, un chiffre et un caractère spécial";
          }
        }
        else if(controller == _oldPasswordField && _oldPasswordField.text != _credentialsPreferences.password){
          return "Ancien mot de passe invalide";
        }
        else if(controller == _newEmailField){
          if(text == _credentialsPreferences.email){
            return "Vous ne pouvez pas attribuer le même e-mail";
          }
          if(!_emailRegEx.hasMatch(_newEmailField.text)){
            return "Veuillez fournir une adresse email valide";
          }
        }else{
          if(controller ==  _confirmationCodeField && _confirmationCodeField.text.length < 10){
            return "Le code de confirmation est de 10 caractères";
          }
        }
        return null;
      },
      cursorColor: Palette.gradientColor[0],
      controller: controller,
      style: TextStyle(fontSize: 14.5),
      decoration: InputDecoration(
          labelText: label,
          hintText: label,
          suffixIcon: controller == _newPasswordField || controller == _newPasswordConfirmation || controller == _oldPasswordField ? IconButton(
            onPressed: (){
              passwordObscureCallback!(
                  controller == _oldPasswordField ? {
                    "controller" : _oldPasswordField,
                    "show" : !showOldPassword
                  } : {
                    "controller" : _newPasswordField,
                    "show" : !showNewPassword
                  }
                  // controller == _oldPasswordField ? !showOldPassword : !showNewPassword
              );
            },
            icon: Icon(controller == _oldPasswordField ? !showOldPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined : !showNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          ) : null,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2))),
    ),
  );

  Widget oldAdminKey(Size size) => this.field(size, label: "Ancienne clé d'administrateur", controller: _oldAdminKeyFieldController);
 Widget newAdminKey(Size size, GlobalKey<FormState> key) => Form(
   key: key,
   child: this.field(size, label: "Nouvelle clé administrateur", controller: _adminKeyField),
 );
  Widget confirmationCodeField(Size size, GlobalKey<FormState> key) => Form(
    key: key,
    child: this.field(size, label: "Code de confirmation", controller: _confirmationCodeField, isEmail: true),
  );
  Widget emailField(Size size,GlobalKey<FormState> emailKey) => Form(
    key: emailKey,
    child: this.field(size, label: "Nouveau Courriel", controller: _newEmailField,isEmail: true),
  );
  Widget passwordFields(Size size, GlobalKey<FormState> passwordKey, {required ValueChanged<Map> showPasswordCallback}) => Form(
    key: passwordKey,
    child: Column(
      children: [
        this.field(size, label: "Ancien mot de passe", controller: _oldPasswordField, showPasswordCallback: showPasswordCallback),
        const SizedBox(
          height: 5,
        ),
        this.field(size, label: "Nouveau mot de passe", controller: _newPasswordField, showPasswordCallback: showPasswordCallback),
        const SizedBox(
          height: 5,
        ),
        this.field(size, label: "Confirmation du nouveau mot de passe", controller: _newPasswordConfirmation, showPasswordCallback: showPasswordCallback),
      ],
    ),
  );

  Widget field(Size size,
      {required String label, required TextEditingController controller, bool isEmail = false, ValueChanged<Map>? showPasswordCallback}) {
    final List<Widget> _children = [
      Container(
        width: size.width > 700 ? 150 : size.width,
        child: Text("$label"),
      ),
      const SizedBox(
        width: 10,
      ),
      if (size.width < 700) ...{
        Container(
          height: 40,
          width: double.infinity,
          margin: const EdgeInsets.only(right: 10),
          child: themedField(label, controller,isEmail: isEmail, passwordObscureCallback: showPasswordCallback),
        ),
      } else ...{
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(right: 10),
            child: themedField(label, controller, isEmail: isEmail, passwordObscureCallback: showPasswordCallback),
          ),
        )
      }
    ];
    if (size.width < 700) {
      return Column(
        children: _children,
      );
    } else {
      return Row(
        children: _children,
      );
    }
  }
  String get passwordizedText {
    String _password = "";
    for(var x = 0;x< _instance.credentialsPreferences.getPasswordLength; x++){
      _password += "•";
    }
    return _password;
  }
  Widget button(VoidCallback onPressed, String label) =>
      TextButton(onPressed: onPressed, child: Text(label));
  Widget animatedChild({required String label, required Widget initChild, required Widget triggeredChild, required bool triggered, String buttonLabel = 'Editer', required VoidCallback onPressed}) => Container(
    padding: const EdgeInsets.only(right: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 190,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "$label",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        Expanded(flex: 4, child: triggered ? triggeredChild : initChild),
        if (!triggered) ...{
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: this.button(onPressed, buttonLabel),
          )
        }
      ],
    ),
  );
  Widget saveAndCancelButton(Size size,{required VoidCallback onCancel, required VoidCallback onSave}) => Container(
    width: double.infinity,
    child: Wrap(
      children: [
        Container(
          width: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border:
              Border.all(color: Colors.black45)),
          child: MaterialButton(
            onPressed: onCancel,
            padding: const EdgeInsets.symmetric(
                horizontal: 5),
            child: Center(
              child: Text(
                "Annuler",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          margin: EdgeInsets.only(
              top: size.width < 600 ? 10 : 0),
          width: 205,
          child: MaterialButton(
            color: Palette.gradientColor[0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            onPressed: onSave,
            padding: const EdgeInsets.symmetric(
                horizontal: 5),
            child: Center(
              child: Text(
                "Sauvegarder les modifications",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    ),
  );
}