import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:joint_cost/viewmodel/setting_model.dart";
import 'package:joint_cost/view/settings.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('ja').then((_) => runApp(
        ChangeNotifierProvider(
          create: (context) => SettingModel(),
          child: const MyApp(),
        ),
      ));
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingModel = Provider.of<SettingModel>(context, listen: false);
      setState(() {
        _startingDayOfWeek = settingModel.startPageA
            ? StartingDayOfWeek.sunday
            : StartingDayOfWeek.monday;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => const SettingPage(),
            );
          },
        ),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Center(
          child: Consumer<SettingModel>(
            builder: (context, settingModel, child) {
              return TableCalendar(
                startingDayOfWeek: settingModel.startPageA
                    ? StartingDayOfWeek.sunday
                    : StartingDayOfWeek.monday,
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
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, events) {
                    final isSelectedDay = isSameDay(date, _selectedDay);
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: isSelectedDay
                          ? const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF5362C),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
