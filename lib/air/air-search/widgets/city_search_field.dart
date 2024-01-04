import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CitySearchField extends StatefulWidget {
  final bool? isDestination;
  const CitySearchField({super.key, this.isDestination});

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {

  @override
  Widget build(BuildContext context) {
    final bool isDestination = widget.isDestination ?? false;
    return TypeAheadField(
      suggestionsCallback: (pattern) async {
        return await getSuggestions(pattern);
      },
      builder: (context, controller, focusNode) =>
          TextFormField(
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: isDestination ? const Icon(Icons.flight_land) : const Icon(Icons.flight_takeoff),
            labelText: isDestination ? 'Destination' : 'Origin',
          ),
        ),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion['label']),
          trailing: Text(suggestion['id']),
        );
      },
      onSelected: (suggestion) {
        debugPrint('$suggestion');
      },
    );
  }
}

Future<List> getSuggestions(String query) async {
  final queryParams = {
    'search': query
  };
  final uri = Uri.https('api.saletoyou.net', '/geo/city', queryParams);
  final response = await http.get(uri);

  List options  = [];
  final data = json.decode(response.body);
  for (int i = 0; i < data["data"].length; i++) {
    options.add({'id': data["data"][i]["id"], 'label': data["data"][i]["label"]});
  }
  debugPrint('Working');

  return options;
}
