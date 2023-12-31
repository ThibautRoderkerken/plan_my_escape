import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/update_vacation_view_model.dart';
import '../widgets/custom_action_button.dart';
import '../utils/date_selector.dart';
import '../widgets/custom_text_field.dart';

class UpdateVacationScreen extends StatelessWidget {
  final int vacationIndex;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;

  const UpdateVacationScreen(
      {Key? key,
      required this.vacationIndex,
      required this.destination,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updateVacationViewModel =
        Provider.of<UpdateVacationViewModel>(context);

    return Center(
        child: SingleChildScrollView(
            child: Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Modifier la période de vacances',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Destination',
            controller: updateVacationViewModel.destinationController =
                TextEditingController(text: destination),
          ),
          const SizedBox(height: 16),
          Consumer<UpdateVacationViewModel>(
            builder: (context, model, child) {
              return CustomDateSelector(
                label: 'Sélectionnez la période',
                onDateSelected: model.onDateSelected,
                initialStartDate: startDate,
                initialEndDate: endDate,
              );
            },
          ),
          const SizedBox(height: 16),
          CustomActionButton(
              label: 'Modifier',
              onPressed: () {
                updateVacationViewModel.validateAndUpdateVacation(
                    vacationIndex, context);
              }),
        ],
      ),
    )));
  }
}
