import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'hexColor.dart';

// rest fields of user
class CustomDropdown {

  static Widget build({
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required Function(String?) setSelectedValue, // Callback for setting the selected value
    String? selectedValue,
    required double deviceWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,fontFamily: 'Poppins'),),
        SizedBox(height: 10,),
        Container(
          width: deviceWidth*0.90,
          height: 60,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            icon: Icon(Icons.arrow_drop_down_circle,color: HexColor('#FB8C00'),),
            hint: Text('Select'),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('#FB8C00'),), // Change the border color here
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Change the border color here
              ), // Add an outline border
            ),
            onChanged: (String? newValue) {
              // newValue = newValue==''?newValue:selectedValue! +',${newValue}';
              // onChanged(newValue); // Call the provided onChanged callback
              setSelectedValue(newValue);
              selectedValue = newValue;  // Set the selected value using the callback

            },
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item,style: TextStyle(fontSize: 14,fontFamily: 'Poppins'),),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// specially for DOB
class CustomDOBDropDown extends StatelessWidget{
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  double deviceWidth;

  CustomDOBDropDown({
    required this.label,
    required this.onDateSelected,
    required this.selectedDate,
    required this.deviceWidth,
  });

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,fontFamily: 'Poppins'),),
        SizedBox(height: 10,),
        InkWell(
          onTap: () async {
            DateTime? selected = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            onDateSelected(selected);

          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.grey), // Border style
              borderRadius: BorderRadius.circular(5.0), // Rounded corners
            ),
            width: deviceWidth*0.86,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.only(left: 11.0,right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? "${selectedDate!.toLocal()}".split(' ')[0]
                        : 'Select Date',
                    style: TextStyle(fontSize: 14,fontFamily: 'Poppins'),),
                  Icon(Icons.calendar_today_rounded,color: HexColor('#FB8C00'),), // Calendar icon
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
