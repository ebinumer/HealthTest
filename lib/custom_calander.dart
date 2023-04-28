import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late List data;

  //parsing json data
  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/json/running.json');
    setState(() => data = json.decode(jsonText));
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();

    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Notice'),
              content: const Text(
                  'This page designed in landscape mode,\nSo keep your phone in landscape mode'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(today);

    List<DateTime> currentWeekDates = List.generate(
        7, (index) => today.add(Duration(days: index - today.weekday + 1)));

    DateTime sunday = today.subtract(Duration(days: today.weekday));
    var todayPosition = 0;

    // Loop through the week and add each date to the list
    for (int i = 0; i < 7; i++) {
      DateTime date = sunday.add(Duration(days: i));
      var formatedDate = DateFormat('yyyy-MM-dd').format(date);
      if (formatedDate == todayDate) {
        todayPosition = i+1;
      }
    }

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            //setting the left headding
            SizedBox(
              width: 100,
              child: ListView(
                padding: const EdgeInsets.only(top: 0),
                children: [
                  _leftMenu('Total Info for the WEEK', 56),
                  _leftMenu('', 32),
                  _leftMenu('Running Time', 32),
                  _leftMenu('Jogging Time', 32),
                  _leftMenu('Exercise Time', 32),
                  _leftMenu('Total Time \n(Running+Jogging\n+Exercise)', 32),
                  _leftMenu(
                      'Running\nTime engagement %(Running / Total Time)', 32),
                  _leftMenu(
                      'Jogging\nTime engagement %(Jogging / Total Time)', 32),
                  _leftMenu(
                      'Exercise\nTime engagement %(Exercise / Total Time)', 32),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //top headding
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDayOfWeek("Total\n(Sun-Sat)", 11.0),
                        _buildDayOfWeek("Sun", 11.0),
                        _buildDayOfWeek("Mon", 11.0),
                        _buildDayOfWeek("Tue", 11.0),
                        _buildDayOfWeek("Wed", 11.0),
                        _buildDayOfWeek("Thu", 11.0),
                        _buildDayOfWeek("Fri", 11.0),
                        _buildDayOfWeek("Sat", 11.0),
                      ],
                    ),
                  ),
                  //data setting widgets
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemBuilder: (context, index) {
                        List<DateTime> weekDates = List.generate(
                            7,
                            (i) => currentWeekDates[i]
                                .subtract(Duration(days: 7 * index)));

                        String currentWeakStartDate =
                            DateFormat('yyyy-MM-dd').format(sunday);
                        String toDayDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        var isCurrentWeak = false;

                        List<double> running = [];
                        List<double> jogging = [];
                        List<double> exercise = [];

                        data.forEachIndexed((index, element) {
                          var calenderWeak =
                              DateTime.parse(element['start_date']);
                          var nowWeak = DateTime.parse(currentWeakStartDate);

                          if (element['start_date'] ==
                              DateFormat('yyyy-MM-dd').format(weekDates[0]
                                  .subtract(const Duration(days: 1)))) {
                            if (calenderWeak.compareTo(nowWeak) == 0) {
                              isCurrentWeak = true;
                            }
                            //running
                            running.addAll(element['running_data'].cast<double>());
                            if (isCurrentWeak) {
                              for(int i = todayPosition; i < 8; i++){
                                running[i]= 0.0;
                              }
                            }
                            var runningTotal = running
                                .getRange(1, running.length)
                                .reduce((a, b) => a + b);
                            running[0] = runningTotal;
                            //jogging
                            jogging
                                .addAll(element['jogging_data'].cast<double>());
                            if (isCurrentWeak) {
                              for(int i = todayPosition; i < 8; i++){
                                jogging[i]= 0.0;
                              }
                            }
                            var joggingTotal = jogging
                                .getRange(1, jogging.length)
                                .reduce((a, b) => a + b);
                            jogging[0] = joggingTotal;
                            //exercise
                            exercise.addAll(
                                element['exercise_data'].cast<double>());
                            if (isCurrentWeak) {
                              for(int i = todayPosition; i < 8; i++){
                                exercise[i]= 0.0;
                              }
                            }
                            var exerciseTotal = exercise
                                .getRange(1, exercise.length)
                                .reduce((a, b) => a + b);
                            exercise[0] = exerciseTotal;
                          }
                        });

                        return Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Table(
                                      border: TableBorder.all(
                                          width: 1, color: Colors.black),
                                      columnWidths: const {
                                        0: FractionColumnWidth(0.13),
                                        1: FractionColumnWidth(0.12),
                                        2: FractionColumnWidth(0.12),
                                        3: FractionColumnWidth(0.12),
                                        4: FractionColumnWidth(0.12),
                                        5: FractionColumnWidth(0.12),
                                        6: FractionColumnWidth(0.12),
                                      },
                                      children: [
                                        //date
                                        TableRow(children: [
                                          const TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text('',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )),
                                          tableCell(weekDates[0]),
                                          tableCell(weekDates[1]),
                                          tableCell(weekDates[2]),
                                          tableCell(weekDates[3]),
                                          tableCell(weekDates[4]),
                                          tableCell(weekDates[5]),
                                          tableCell(weekDates[6]),
                                        ]),
                                        //running
                                        TableRow(children: [
                                          tableValue(running.isNotEmpty
                                              ? running[0]
                                              : 0.0),
                                          tableValue(running.length >= 2
                                              ? running[1]
                                              : 0.0),
                                          tableValue(running.length >= 3
                                              ? running[2]
                                              : 0.0),
                                          tableValue(running.length >= 4
                                              ? running[3]
                                              : 0.0),
                                          tableValue(running.length >= 5
                                              ? running[4]
                                              : 0.0),
                                          tableValue(running.length >= 6
                                              ? running[5]
                                              : 0.0),
                                          tableValue(running.length >= 7
                                              ? running[6]
                                              : 0.0),
                                          tableValue(running.length == 8
                                              ? running[7]
                                              : 0.0),
                                        ]),
                                        //jogging
                                        TableRow(children: [
                                          tableValue(jogging.isNotEmpty
                                              ? jogging[0]
                                              : 0.0),
                                          tableValue(jogging.length >= 2
                                              ? jogging[1]
                                              : 0.0),
                                          tableValue(jogging.length >= 3
                                              ? jogging[2]
                                              : 0.0),
                                          tableValue(jogging.length >= 4
                                              ? jogging[3]
                                              : 0.0),
                                          tableValue(jogging.length >= 5
                                              ? jogging[4]
                                              : 0.0),
                                          tableValue(jogging.length >= 6
                                              ? jogging[5]
                                              : 0.0),
                                          tableValue(jogging.length >= 7
                                              ? jogging[6]
                                              : 0.0),
                                          tableValue(jogging.length == 8
                                              ? jogging[7]
                                              : 0.0),
                                        ]),
                                        //exercise
                                        TableRow(children: [
                                          tableValue(exercise.isNotEmpty
                                              ? exercise[0]
                                              : 0.0),
                                          tableValue(exercise.length >= 2
                                              ? exercise[1]
                                              : 0.0),
                                          tableValue(exercise.length >= 3
                                              ? exercise[2]
                                              : 0.0),
                                          tableValue(exercise.length >= 4
                                              ? exercise[3]
                                              : 0.0),
                                          tableValue(exercise.length >= 5
                                              ? exercise[4]
                                              : 0.0),
                                          tableValue(exercise.length >= 6
                                              ? exercise[5]
                                              : 0.0),
                                          tableValue(exercise.length >= 7
                                              ? exercise[6]
                                              : 0.0),
                                          tableValue(exercise.length == 8
                                              ? exercise[7]
                                              : 0.0),
                                        ]),

                                        // total
                                        TableRow(children: [
                                          tableValue(running[0] +
                                              jogging[0] +
                                              exercise[0]),
                                          tableValue(running[1] +
                                              jogging[1] +
                                              exercise[1]),
                                          tableValue(running[2] +
                                              jogging[2] +
                                              exercise[2]),
                                          tableValue(running[3] +
                                              jogging[3] +
                                              exercise[3]),
                                          tableValue(running[4] +
                                              jogging[4] +
                                              exercise[4]),
                                          tableValue(running[5] +
                                              jogging[5] +
                                              exercise[5]),
                                          tableValue(running[6] +
                                              jogging[6] +
                                              exercise[6]),
                                          tableValue(running[7] +
                                              jogging[7] +
                                              exercise[7]),
                                        ]),
                                        //running time engage
                                        TableRow(children: [
                                          tableValue(running[0] /
                                              (running[0] +
                                                  jogging[0] +
                                                  exercise[0])),
                                          tableValue(running[1] /
                                              (running[1] +
                                                  jogging[1] +
                                                  exercise[1])),
                                          tableValue(running[2] /
                                              (running[2] +
                                                  jogging[2] +
                                                  exercise[2])),
                                          tableValue(running[3] /
                                              (running[3] +
                                                  jogging[3] +
                                                  exercise[3])),
                                          tableValue(running[4] /
                                              (running[4] +
                                                  jogging[4] +
                                                  exercise[4])),
                                          tableValue(running[5] /
                                              (running[5] +
                                                  jogging[5] +
                                                  exercise[5])),
                                          tableValue(running[6] /
                                              (running[6] +
                                                  jogging[6] +
                                                  exercise[6])),
                                          tableValue(running[7] /
                                              (running[7] +
                                                  jogging[7] +
                                                  exercise[7])),
                                        ]),
                                        //jogging time engage
                                        TableRow(children: [
                                          tableValue(jogging[0] /
                                              (running[0] +
                                                  jogging[0] +
                                                  exercise[0])),
                                          tableValue(jogging[1] /
                                              (running[1] +
                                                  jogging[1] +
                                                  exercise[1])),
                                          tableValue(jogging[2] /
                                              (running[2] +
                                                  jogging[2] +
                                                  exercise[2])),
                                          tableValue(jogging[3] /
                                              (running[3] +
                                                  jogging[3] +
                                                  exercise[3])),
                                          tableValue(jogging[4] /
                                              (running[4] +
                                                  jogging[4] +
                                                  exercise[4])),
                                          tableValue(jogging[5] /
                                              (running[5] +
                                                  jogging[5] +
                                                  exercise[5])),
                                          tableValue(jogging[6] /
                                              (running[6] +
                                                  jogging[6] +
                                                  exercise[6])),
                                          tableValue(jogging[7] /
                                              (running[7] +
                                                  jogging[7] +
                                                  exercise[7])),
                                        ]),
                                        //exercise time engage
                                        TableRow(children: [
                                          tableValue(exercise[0] /
                                              (running[0] +
                                                  jogging[0] +
                                                  exercise[0])),
                                          tableValue(exercise[1] /
                                              (running[1] +
                                                  jogging[1] +
                                                  exercise[1])),
                                          tableValue(exercise[2] /
                                              (running[2] +
                                                  jogging[2] +
                                                  exercise[2])),
                                          tableValue(exercise[3] /
                                              (running[3] +
                                                  jogging[3] +
                                                  exercise[3])),
                                          tableValue(exercise[4] /
                                              (running[4] +
                                                  jogging[4] +
                                                  exercise[4])),
                                          tableValue(exercise[5] /
                                              (running[5] +
                                                  jogging[5] +
                                                  exercise[5])),
                                          tableValue(exercise[6] /
                                              (running[6] +
                                                  jogging[6] +
                                                  exercise[6])),
                                          tableValue(exercise[7] /
                                              (running[7] +
                                                  jogging[7] +
                                                  exercise[7])),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: 10, // Change the number of weeks here
                      reverse:
                          true, // Set this to true to enable scrolling to previous weeks
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayOfWeek(String dayOfWeek, double fontSize) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.black,
            //       width: 1.0,
            //     ),
            color: Colors.grey[300]),
        child: Text(
          dayOfWeek,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _leftMenu(String heading, double height) {
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          color: Colors.grey[300]),
      child: Text(heading,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }

  Widget tableCell(DateTime value) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
            DateFormat('dd/MMMM/yyyy')
                .format(value.subtract(const Duration(days: 1)))
                .toString(),
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500)),
      ),
    ));
  }

  Widget tableValue(double value) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(11.5),
      child: Center(
        child: Text(
            value == 0.0
                ? ''
                : value.isNaN
                    ? ''
                    : value.toStringAsFixed(2),
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500)),
      ),
    ));
  }
}
