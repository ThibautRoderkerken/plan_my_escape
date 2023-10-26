import 'package:flutter/material.dart';

class CustomDateSelector extends StatefulWidget {
  final String label;
  final Function(DateTimeRange) onDateSelected;
  final String? errorMessage;

  const CustomDateSelector({
    Key? key,
    required this.label,
    required this.onDateSelected,
    this.errorMessage,
  }) : super(key: key);

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
      widget.onDateSelected(pickedRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.label),
          subtitle: Text(
            _selectedDateRange == null
                ? ''
                : "${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
          ),
          onTap: () {
            _selectDateRange(context);
          },
        ),
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
