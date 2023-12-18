import 'package:mockito/mockito.dart';
import 'package:plan_my_escape/services/auth_service.dart';

class MockLoginService extends Mock implements AuthService {
  @override
  Future<void> login(String email, String password) async {
    return;
  }
}
