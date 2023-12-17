import 'package:plan_my_escape/models/country.dart';

// Singleton pour la liste des pays
class GlobalData {
  static final GlobalData _instance = GlobalData._internal();
  factory GlobalData() => _instance;
  GlobalData._internal();

  List<Country> countries = [];
}

