import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';


class CountryPicker extends StatefulWidget {
  final TextEditingController? phoneController;
  final Function(Country)? onCountrySelected;

  const CountryPicker({
    super.key,
    this.phoneController,
    this.onCountrySelected,
  });

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  Country selectedCountry = Country(
    phoneCode: '977',
    countryCode: 'NP',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Nepal',
    displayName: 'Nepal',
    displayNameNoCountryCode: 'Nepal',
    example: '9841234567',
    e164Key: '',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: context.height * 0.05,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: true,
            onSelect: (Country country) {
              setState(() {
                selectedCountry = country;
              });
              if (widget.onCountrySelected != null) {
                widget.onCountrySelected!(country);
              }
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(selectedCountry.flagEmoji, style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '+${selectedCountry.phoneCode}',
                style:TextStyle(fontSize: 14),
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
