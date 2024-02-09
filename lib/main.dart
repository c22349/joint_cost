import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

DateTime _focusedDay = DateTime.now();
void main() {
  initializeDateFormatting('ja').then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter title',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2028, 12, 31),
            focusedDay: _focusedDay,
            locale: 'ja_Jp',
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // 更新されたフォーカス日を保持
              });
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) {
                final isSelectedDay = isSameDay(date, _selectedDay);
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: isSelectedDay
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 245, 54, 44),
                        )
                      : null,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelectedDay ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Colors.red, // 当日の日付を赤文字にする
                    ),
                  ),
                );
              },
              defaultBuilder: (context, date, events) {
                final weekday = date.weekday;
                if (weekday == DateTime.saturday ||
                    weekday == DateTime.sunday) {
                  return Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                }
                // 他の日はデフォルトのスタイルを使用
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
