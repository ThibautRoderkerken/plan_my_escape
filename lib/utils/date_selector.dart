import 'package:flutter/material.dart';

class CustomDateSelector extends StatefulWidget {
  final String label;
  final Function(DateTimeRange) onDateSelected;
  final String? errorMessage;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final String? Function(DateTimeRange?)? validator;

  const CustomDateSelector({
    Key? key,
    required this.label,
    required this.onDateSelected,
    this.errorMessage,
    this.initialStartDate,
    this.initialEndDate,
    this.validator,
  }) : super(key: key);

  @override
  CustomDateSelectorState createState() => CustomDateSelectorState();
}

class CustomDateSelectorState extends State<CustomDateSelector> {
  DateTimeRange? _selectedDateRange;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDateRange();
    });
  }


  void _initializeDateRange() {
    if (widget.initialStartDate != null && widget.initialEndDate != null) {
      _selectedDateRange = DateTimeRange(
        start: widget.initialStartDate!,
        end: widget.initialEndDate!,
      );
      widget.onDateSelected(_selectedDateRange!);
    }
  }

  void _validateDateRange() {
    if (widget.validator != null) {
      setState(() {
        _errorMessage = widget.validator!(_selectedDateRange);
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange,
    );

    if (pickedRange != null) {
      setState(() {
        _selectedDateRange = pickedRange;
      });
      widget.onDateSelected(pickedRange);
    }

    _validateDateRange();
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
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
