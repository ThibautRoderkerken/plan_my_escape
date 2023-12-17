import 'package:flutter/material.dart';
import 'package:plan_my_escape/models/country.dart';
import 'package:plan_my_escape/utils/global_data.dart';
import 'package:plan_my_escape/view_models/dashboard/add_vacation_view_model.dart';

class CustomAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final AddVacationViewModel viewModel; // Ajout du ViewModel en tant que paramètre
  final String? Function(String?)? validator;

  const CustomAutocomplete({
    Key? key,
    required this.controller,
    required this.viewModel, // Assurez-vous de passer le ViewModel
    this.validator,
  }) : super(key: key);

  @override
  CustomAutocompleteState createState() => CustomAutocompleteState();
}

class CustomAutocompleteState extends State<CustomAutocomplete> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    widget.viewModel.setSelectedCountry(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Country>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Country>.empty();
        }
        return GlobalData().countries.where((Country country) {
          return country.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Country selection) {
        widget.controller.text = selection.name;
        widget.viewModel.setSelectedCountry(selection.name);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: const InputDecoration(
            labelText: 'Pays',
            hintText: 'Commencez à taper le nom du pays',
          ),
          validator: widget.validator ?? (String? value) { // Utilisez widget.validator ici
            if (value == null || value.isEmpty) {
              return 'Ce champ ne peut pas être vide';
            }
            if (!GlobalData().countries.any((country) => country.name == value)) {
              return 'Veuillez sélectionner un pays valide';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Country> onSelected, Iterable<Country> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final Country option = options.elementAt(index);
                return ListTile(
                  title: Text(option.name),
                  onTap: () {
                    onSelected(option);
                  },
                );
              },
            ),
          ),
        );
      },
      displayStringForOption: (Country option) => option.name,
    );
  }
}
