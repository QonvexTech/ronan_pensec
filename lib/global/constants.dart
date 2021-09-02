//
// ///Live
// // String baseUrl = "https://ronan.checkmy.dev/";
// ///Test
// String baseUrl = "http://127.0.0.1:8000/";
import 'package:flutter/material.dart';

class BaseEnpoint {
  static final String URL = "https://ronan.checkmy.dev/";
}

class ContextHolder {
  ContextHolder._private();
  static final ContextHolder _instance = ContextHolder._private();
  static ContextHolder get instance {
    return _instance;
  }

  BuildContext? _context;
  BuildContext? get context => _context!;
  set setContext(BuildContext context) => _instance._context = context;

  Size? _size;
  Size? get size => _size;
  set setSize(Size size) => _instance._size = size;

  static final String URL = "${BaseEnpoint.URL}";
}
