import 'package:flutter/material.dart';

class CustomDateSelector extends StatefulWidget {
  final String label;
  const CustomDateSelector({Key? key, required this.label}) : super(key: key);

  @override
  CustomDateSelectorState createState() => CustomDateSelectorState();
}

class CustomDateSelectorState extends State<CustomDateSelector> { // Retirez le tiret bas
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: Text(
        _selectedDate == null ? '' : "${_selectedDate!.toLocal()}".split(' ')[0],
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }
}
