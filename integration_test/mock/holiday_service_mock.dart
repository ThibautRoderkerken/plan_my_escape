import 'package:mockito/mockito.dart';
import 'package:plan_my_escape/models/vacation_period.dart';
import 'package:plan_my_escape/services/holiday_service.dart';

class MockHolidayService extends Mock implements HolidayService {
  @override
  Future<dynamic> addVacationPeriod(VacationPeriod vacation) async {
    throw UnimplementedError();
  }

  @override
  Future<List<VacationPeriod>> getVacationPeriods() async {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> updateVacationPeriod(VacationPeriod vacation) async {
    throw UnimplementedError();
  }

  @override
  Future<VacationPeriod> getVacationPeriodDetails(int vacationId) async {
    throw UnimplementedError();
  }

  @override
  Future deleteVacationPeriod(int id) async {
    throw UnimplementedError();
  }
}
