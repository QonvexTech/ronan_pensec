import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';

class RegionViewModel {
  final TextEditingController name = new TextEditingController();
  final SlidableController slideController = new SlidableController();
  bool _isList = true;
  int _currentPage = 0;
  bool _isLoading = false;
  RegionModel? _selectedRegion;
  final RegionDataControl control = RegionDataControl.instance;
  late final RegionService _service = RegionService.instance(control);

  /// GETTERS
  RegionService get service => _service;

  bool get isList => _isList;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  RegionModel? get selectedRegion=> _selectedRegion;

  ///SETTERS
  set setRegion(RegionModel? model) => _selectedRegion = model;
  set setIsList(bool list) => _isList = list;
  set setPage(int i) => _currentPage = i;
  set setIsLoading(bool l) => _isLoading = l;
}