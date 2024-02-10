import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ja').then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'joint cost',
      theme: ThemeData(),
      home: const MyHomePage(title: ''),
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
  DateTime _focusedDay = DateTime.now();
  StartingDayOfWeek _startingDayOfWeek = StartingDayOfWeek.sunday; // 初期設定は日曜日

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, //設定画面高さ
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          '設定',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'カレンダー始まり: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButton<StartingDayOfWeek>(
                        value: _startingDayOfWeek,
                        onChanged: (StartingDayOfWeek? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _startingDayOfWeek = newValue;
                            });
                          }
                        },
                        items: [
                          DropdownMenuItem<StartingDayOfWeek>(
                            value: StartingDayOfWeek.sunday,
                            child: Text('日曜'),
                          ),
                          DropdownMenuItem<StartingDayOfWeek>(
                            value: StartingDayOfWeek.monday,
                            child: Text('月曜'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showSettingsPanel, // 歯車マークをタップした時の処理を更新
        ),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Center(
          child: TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronMargin: EdgeInsets.only(left: 80), // <マークの位置を調整
              rightChevronMargin: EdgeInsets.only(right: 80), // >マークの位置を調整
            ),
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2028, 12, 31),
            focusedDay: _focusedDay,
            locale: 'ja_JP',
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              // スクロールによる月の切り替え時にフォーカスされた日を更新
              _focusedDay = focusedDay;
            },
            pageJumpingEnabled: true, // スクロールによるページジャンプを有効
            startingDayOfWeek: _startingDayOfWeek,
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) {
                final isSelectedDay = isSameDay(date, _selectedDay);
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: isSelectedDay
                      ? const BoxDecoration(
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
                    style: const TextStyle(
                      color: Colors.red,
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
                      style: const TextStyle(color: Colors.blue),
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
