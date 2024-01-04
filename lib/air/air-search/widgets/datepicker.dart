import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _focusedDay = DateTime.now();
  DateTime toDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime lastDay = DateTime.now().add(const Duration(days: 365));
  final dateFormat = DateFormat('dd.MM.yyyy');

  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dateField(isDeparture: true),
        const SizedBox(height: 20),
        dateField(),
      ],
    );
  }

  Widget calendar(StateSetter stateSetter, {isDeparture = false}) {
    return TableCalendar(
      locale: "ru_RU",
      rowHeight: 40,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      firstDay: toDay,
      lastDay: lastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: _rangeSelectionMode,
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          stateSetter(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = selectedDay;
            _rangeEnd = null;
          });
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        stateSetter((){
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;

          departureDateController.text = dateFormat.format(_rangeStart!);
          if (_rangeEnd != null) {
            returnDateController.text = dateFormat.format(_rangeEnd!);
          }
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Widget dateField({isDeparture = false}) {
    return TextFormField(
        controller: isDeparture ? departureDateController : returnDateController,
        decoration: InputDecoration(
          labelText: isDeparture ? 'Departure' : 'Return',
          suffixIcon: isDeparture ? const Icon(Icons.calendar_today) : const Icon(Icons.calendar_today_outlined),
          filled: true,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue)
          ),
        ),
        readOnly: true,
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            showDragHandle: true,
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setDayState) {
                    return SizedBox(
                        height: 430,
                        child: Column(
                          children: [
                            calendar(setDayState),                              //calendar
                            const SizedBox(height: 45),
                            ElevatedButton(
                              onPressed: () {
                                returnDateController.text = "";
                                if (departureDateController.text != "") {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Тo return ticket no needed'),
                            )
                          ],
                        ),
                    );
                  }
                );
            },
          );
        }
    );
  }

}
