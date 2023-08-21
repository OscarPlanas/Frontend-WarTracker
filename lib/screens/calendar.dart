import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/event.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    fetchUserEvents();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    print(savedThemeMode);
    setState(() {
      _themeMode = savedThemeMode;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    final selectedDate = DateTime(day.year, day.month, day.day);

    return events.entries
        .where((entry) => isSameDay(entry.key, selectedDate))
        .map((entry) => entry.value)
        .expand((eventsList) => eventsList)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: Text(("Calendar"), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      drawer: Sidebar(),
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: _themeMode == ThemeMode.dark
                    ? Colors.grey[900]
                    : Colors.white,
                scrollable: true,
                title: Text(AppLocalizations.of(context)!.calendarEvent,
                    style: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Background,
                        ),
                      ),
                    ),
                    controller: _eventController,
                    style: _themeMode == ThemeMode.dark
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Background,
                    ),
                    onPressed: () {
                      setState(() {
                        createEvent(_eventController.text);
                        Navigator.of(context).pop();
                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
                        _eventController.clear();
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.buttonSubmit,
                      style: TextStyle(color: ButtonBlack),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Background,
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
              child: TableCalendar(
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color:
                    _themeMode == ThemeMode.dark ? Colors.grey : Colors.black,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              selectedDecoration: BoxDecoration(
                color:
                    _themeMode == ThemeMode.dark ? Colors.black : Colors.grey,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                  color:
                      _themeMode == ThemeMode.dark ? Background : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.grey[350]
                      : Colors.black),
              weekendStyle: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.grey[350]
                      : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            headerStyle: HeaderStyle(
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color:
                    _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color:
                    _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
              formatButtonTextStyle: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              titleTextStyle: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (BuildContext context, date, events) {
                if (events.isEmpty) return SizedBox();
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(1),
                        child: Container(
                          width: 5,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _themeMode == ThemeMode.dark
                                  ? Color.fromARGB(255, 155, 8, 218)
                                  : Colors.red),
                        ),
                      );
                    });
              },
            ),
            locale: AppLocalizations.of(context)!.localeName == 'en'
                ? 'en_US'
                : 'es_ES',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          )),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        Event event = value[index]; // Get the Event object
                        return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                              color: _themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.grey[200],
                            ),
                            child: ListTile(
                              onTap: () => print(""),
                              title: Text(event.title),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            _themeMode == ThemeMode.dark
                                                ? Colors.grey[900]
                                                : Colors.white,
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .calendarDeleteTitle,
                                            style: TextStyle(
                                                color:
                                                    _themeMode == ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        content: Text(
                                          AppLocalizations.of(context)!
                                              .calendarDelete,
                                          style: TextStyle(
                                              color:
                                                  _themeMode == ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                                style: TextStyle(
                                                    color: _themeMode ==
                                                            ThemeMode.dark
                                                        ? Background
                                                        : Colors.red)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteEvent(
                                                  event.id); // Delete the event
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .delete,
                                                style: TextStyle(
                                                    color: _themeMode ==
                                                            ThemeMode.dark
                                                        ? Background
                                                        : Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ));
                      });
                }),
          )
        ],
      ),
    );
  }

  // Function to create an event
  Future<void> createEvent(String eventName) async {
    print("Creating event");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5432/api/events/createevent'),
      body: {
        'title': eventName,
        'date': _selectedDay!.toIso8601String(),
        'user': currentUser.id
      },
    );

    if (response.statusCode == 200) {
      // Event created successfully
      final newEvent = Event(eventName, "");
      setState(() {
        if (events.containsKey(_selectedDay!)) {
          events[_selectedDay!]!.add(newEvent);
        } else {
          events[_selectedDay!] = [newEvent];
        }

        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    } else {
      // Handle error
      print('Error creating event: ${response.body}');
    }
  }

  Future<void> fetchUserEvents() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:5432/api/events/geteventbyuser/${currentUser.id}'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final eventsData = json.decode(response.body);
      final Map<DateTime, List<Event>> newEvents = {}; // Create a new map

      for (final eventData in eventsData) {
        final event = Event(eventData['title'], eventData['_id']);
        final eventDate = DateTime.parse(eventData['date']);

        if (newEvents.containsKey(eventDate)) {
          newEvents[eventDate]!
              .add(event); // Add the event to the existing list
        } else {
          newEvents[eventDate] = [event]; // Create a new list with the event
        }
      }

      // Update the events map
      setState(() {
        events = newEvents;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    } else {
      // Handle error
      print('Error fetching user events: ${response.body}');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5432/api/events/deleteevent/$eventId'),
    );

    if (response.statusCode == 200) {
      // Event deleted successfully
      setState(() {
        events[_selectedDay!] = events[_selectedDay!]!
            .where((event) => event.id != eventId)
            .toList();
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    } else {
      // Handle error
      print('Error deleting event: ${response.body}');
    }
  }
}
