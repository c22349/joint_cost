import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:joint_cost/viewmodel/setting_model.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, settingModel, child) {
        return TableCalendar(
          startingDayOfWeek: settingModel.startPageA
              ? StartingDayOfWeek.sunday
              : StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronMargin: EdgeInsets.only(left: 80),
            rightChevronMargin: EdgeInsets.only(right: 80),
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
            _focusedDay = focusedDay;
          },
          pageJumpingEnabled: true,
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
              if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
                return Center(
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                );
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
