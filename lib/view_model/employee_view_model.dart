import 'package:ronan_pensec/global/templates/employee_template.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';

class EmployeeViewModel{
  final EmployeeTemplate template = EmployeeTemplate.instance;
  final EmployeeDataControl employeeDataControl = EmployeeDataControl.instance;
  late final EmployeeService _service = EmployeeService.instance(employeeDataControl);
  EmployeeService get service => _service;
  bool _isTable = true;
  bool get isTable => _isTable;
  set setTable(bool b) => _isTable = b;
  // ///checks and sets number of data to be fetched from the server
  // int _initPage = 10;
  // int get page => _initPage;
  // set setPage(int page) => _initPage = page;
  //
  // int? lastPage;
  // /// Current page control
  // /// checks and sets what page you are in now
  // int _currentPage = 1;
  // int get currentPage => _currentPage;
  // set setCurrentPage(int page) => _currentPage = page;
  //
  // ///checks and sets total data from the server
  // int? _totalData;
  // set setTotal(int total) => _totalData = total;
  // int? get total => _totalData;
  //
  // String? nextPageUrl;
  // late String lastPageUrl;
  // late String firstPageUrl = "$page?page=1";
  // late String currentPageUrl = firstPageUrl;
  // String? previousPageUrl;
}
PaginationModel employeePagination = PaginationModel();