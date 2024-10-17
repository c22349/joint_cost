import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// 読み込みファイル
import 'package:joint_cost/view/settings.dart';
import 'package:joint_cost/view/calendar_widget.dart';
import 'package:joint_cost/viewmodel/setting_model.dart';

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
          child: CalendarWidget(),
        ),
      ),
    );
  }
}
