import 'package:atom_login_page/air/air-search/widgets/datepicker.dart';
import 'package:atom_login_page/air/air-search/widgets/passengers_&_class_menu.dart';
import 'package:flutter/material.dart';

import 'widgets/city_search_field.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  late final String id;
  final String origin = '';
  final String destination = '';
  final String date = '';
  final int adults = 1;
  final int children = 0;
  final int infants = 0;
  final String airTicketClass = 'E';

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Form(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            CitySearchField(),                                            //origin
            SizedBox(height: 20),
            CitySearchField(isDestination: true),                         //destination
            SizedBox(height: 35),
            DatePicker(),                                                 //departure
            SizedBox(height: 30),
            PassengersAndClass(),
            // ElevatedButton(
            //     onPressed: (){},
            //     child: const Text('Passengers and class')
            // )
          ],
        ),
      ),
    );
  }
}
