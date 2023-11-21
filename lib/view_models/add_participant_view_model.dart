import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/member.dart';
import '../../view_models/dashboard_view_model.dart';

class AddParticipantViewModel extends ChangeNotifier {
  final int vacationIndex;
  final DashboardViewModel dashboardViewModel;

  AddParticipantViewModel({required this.vacationIndex, required this.dashboardViewModel});

  void addParticipant(String name, String email) {
    // Logique pour ajouter un participant
    dashboardViewModel.addMember(vacationIndex, name, email);
    notifyListeners();
  }

  void removeParticipant(int index) {
    dashboardViewModel.removeMember(vacationIndex, index);
    notifyListeners();
  }

  List<Member> get participants => dashboardViewModel.vacationPeriods[vacationIndex].members;
}
