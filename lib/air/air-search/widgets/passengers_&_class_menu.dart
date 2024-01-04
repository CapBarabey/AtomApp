import 'package:flutter/material.dart';

class PassengersAndClass extends StatefulWidget {
  const PassengersAndClass({super.key});

  @override
  State<PassengersAndClass> createState() => _PassengersAndClassState();
}

class _PassengersAndClassState extends State<PassengersAndClass> {

  @override
  void initState() {
    setState(() {
      classOption = economyClass;
    });
    super.initState();
  }

  TextEditingController passengersClassController = TextEditingController();

  int adults = 1;
  int children = 0;
  int infants = 0;

  String economyClass = 'E';
  String businessClass = 'B';

  String? classOption;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '1 adults, Economy',
      decoration: const InputDecoration(
        labelText: 'Passengers and class',
        suffixIcon: Icon(Icons.flight_class),
        filled: true,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setOptionState) {
                return SizedBox(
                  height: 350,
                  child: Column(
                    children: [
                      passengerOptions(setOptionState),
                      const SizedBox(height: 35),
                      classRadioOption(setOptionState),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK')),
                    ],
                  ),
                );
              }
            );
          }
        );
      },
    );
  }

  Widget circleButton(String type, StateSetter setOptionState, {isRemoveButton = false}) {
    return ElevatedButton(
      onPressed: () {
        if (isRemoveButton == false) {
          switch(type) {
            case 'adults': setOptionState((){adults ++;});
            case 'children': setOptionState((){children ++;});
            case 'infants': setOptionState((){infants ++;});
          }
        } else {
          switch(type) {
            case 'adults': setOptionState((){adults --;});
            case 'children': setOptionState((){children --;});
            case 'infants': setOptionState((){infants --;});
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        elevation: 1.50,
        backgroundColor: Colors.orange,
      ),
      child: isRemoveButton ? const Icon(Icons.remove, color: Colors.white) : const Icon(Icons.add_rounded, color: Colors.white),
    );
  }

  Widget passengerOptions(StateSetter setOptionState) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 153),
              child: Text('Adults: ', style: TextStyle(fontSize: 20)),
            ),
            circleButton('adults', setOptionState, isRemoveButton: true),
            Text('$adults'),
            circleButton('adults', setOptionState),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 137),
              child: Text('Children: ', style: TextStyle(fontSize: 20)),
            ),
            circleButton('children', setOptionState, isRemoveButton: true),
            Text('$children'),
            circleButton('children', setOptionState),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 149),
              child: Text('Infants: ', style: TextStyle(fontSize: 20)),
            ),
            circleButton('infants', setOptionState, isRemoveButton: true),
            Text('$infants'),
            circleButton('infants', setOptionState),
          ],
        ),
      ],
    );
  }

  Widget classRadioOption(StateSetter setOptionState) {
    return Row(
      children: [
        Row(
          children: [
            Radio<String>(
              value: economyClass,
              groupValue: classOption,
              onChanged: (String? value) {
                setOptionState(() {
                  classOption = value;
                });
              },
            ),
            const Text('Economy', style: TextStyle(fontSize: 20)),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: businessClass,
              groupValue: classOption,
              onChanged: (String? value) {
                setOptionState(() {
                  classOption = value;
                });
              },
            ),
            const Text('Business', style: TextStyle(fontSize: 20)),
          ],
        ),
      ],
    );
  }

  String valueBuilder() {
    String? chosenClass;
    String value ='  adults, $chosenClass';




    return value;
  }

}
