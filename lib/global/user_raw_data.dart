import 'package:flutter/material.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:rxdart/rxdart.dart';

class UserRawData {
  UserRawData._private();

  static final UserRawData _instance = UserRawData._private();

  static UserRawData get instance => _instance;

  // List<RawUserModel> _rawUserList = [];

  // List<RawUserModel> get rawUserList => _rawUserList;

  BehaviorSubject<List<RawUserModel>> _subject =
      BehaviorSubject<List<RawUserModel>>();
  Stream<List<RawUserModel>>? get stream => _subject.stream;
  List<RawUserModel>? get current => _subject.value;

  setUsers(List data) =>
      _subject.add(data.map((e) => RawUserModel.fromJson(e)).toList());
  // _rawUserList = data.map((e) => RawUserModel.fromJson(e)).toList();

  DropdownButtonHideUnderline showDropdown(
          {required ValueChanged<RawUserModel> onChooseCallback,
          required RawUserModel value}) =>
      DropdownButtonHideUnderline(
        child: DropdownButton<RawUserModel>(
          isExpanded: true,
          value: value,
          onChanged: (RawUserModel? value) {
            if (value != null) {
              onChooseCallback(value);
            }
          },
          items: _instance.current!
              .map<DropdownMenuItem<RawUserModel>>(
                (e) => DropdownMenuItem<RawUserModel>(
                  child: Text("${e.fullName}"),
                  value: e,
                ),
              )
              .toList(),
        ),
      );
}
