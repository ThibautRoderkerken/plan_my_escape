import 'package:mockito/mockito.dart';
import 'package:plan_my_escape/models/country.dart';
import 'package:plan_my_escape/services/country_service.dart';

class MockCountryService extends Mock implements CountryService {
  @override
  Future<List<Country>> getCountries() async {
    List<Country> countries = [
      Country(code: "1", name: 'Belgique'),
      Country(code: "2", name: 'France'),
      Country(code: "3", name: 'Allemagne'),
    ];

    return countries;
  }
}