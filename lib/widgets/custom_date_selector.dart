import 'package:flutter/material.dart';

class CustomDateSelector extends StatefulWidget {
  final String label;
  const CustomDateSelector({Key? key, required this.label}) : super(key: key);

  @override
  CustomDateSelectorState createState() => CustomDateSelectorState();
}

class CustomDateSelectorState extends State<CustomDateSelector> {
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedRange != null) {
      setState(() {
        _selectedDateRange = pickedRange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: Text(
        _selectedDateRange == null
            ? ''
            : "${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
      ),
      onTap: () {
        _selectDateRange(context);
      },
    );
  }
}
