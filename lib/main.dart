import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: CustomCalendar(),
    );
  }
}
class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late PageController _pageController;
  late DateTime _currentWeekStartDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notice'),
          content: const Text('This page designed in landscape mode,\nSo keep your phone in landscape mode'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ));

    _currentWeekStartDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    _pageController = PageController(initialPage: 0);

    _pageController.addListener(() {
      setState(() {
     print("== ${_pageController.page}");
        if(_pageController.page == 0.0){
            _currentWeekStartDate =
                _currentWeekStartDate.subtract(const Duration(days: 7));
        }


      });
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return SafeArea(
      child: Scaffold(
        body: Row(
         children: [
           SizedBox(
             width: 100,
             child: Expanded(
                 child: ListView(

                   padding: EdgeInsets.only(top: 6),
                   children: [
                     Container(
                       height: 43,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Total Info for the WEEK',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Running Time',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Jogging Time',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Exercise Time',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Total Time \n(Running+Jogging+Exercise)',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Running\nTime engagement %(Running / Total Time)',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Jogging\nTime engagement %(Jogging / Total Time)',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                     Container(
                       height: 30,
                       alignment: Alignment.centerLeft,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1.0,
                         ),
                       ),
                       child: Text('Exercise\nTime engagement %(Exercise / Total Time)',style: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold)),
                     ),
                   ],
                 ),
               ),
           ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDayOfWeek("Total\n(Sun-Sat)",11.0),
                        _buildDayOfWeek("Sun",16.0),
                        _buildDayOfWeek("Mon",16.0),
                        _buildDayOfWeek("Tue",16.0),
                        _buildDayOfWeek("Wed",16.0),
                        _buildDayOfWeek("Thu",16.0),
                        _buildDayOfWeek("Fri",16.0),
                        _buildDayOfWeek("Sat",16.0),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        _pageController.animateToPage(
                            index, duration: const Duration(microseconds: 01),
                            curve: Curves.ease);
                        DateTime startDate = _currentWeekStartDate.add(Duration(days: 7 * index));
                        return CustomCalendarWeek(startDate: startDate);
                      },
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
  Widget _buildDayOfWeek(String dayOfWeek,double fontSize) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          dayOfWeek,
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class CustomCalendarWeek extends StatelessWidget {
  final DateTime startDate;

  CustomCalendarWeek({required this.startDate});

  @override
  Widget build(BuildContext context) {
    List<double> running = [0,3.0,2.5,1.8,3.0,1.0,2.0,2];
    List<double> jogging = [0,1.0,1.5,1.8,1.0,1.0,1.0,2];
    List<double> exercise = [0,3.0,2.5,1.8,3.0,1.0,2.0,2];
    List<DateTime> weekDates = [];
    for (int i = 0; i < 8; i++) {
      weekDates.add(startDate.add(Duration(days: i)));
    }

    return
      Column(
      children: [
        Row(
          children: weekDates.map((date) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text(weekDates[0] ==date ?'' : DateFormat('dd/MMMM/yyyy').format(date.subtract(Duration(days: 1))).toString(),style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: running.map((time) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("$time Hr",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: jogging.map((jogging) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("$jogging Hr",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: exercise.map((exercise) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("$exercise Hr",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: weekDates.map((date) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: weekDates.map((date) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: weekDates.map((date) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),
        Row(
          children: weekDates.map((date) => Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Text("",style: const TextStyle(fontSize: 10)),
            ),
          ),).toList(),
        ),


      ],

    );
  }


}
