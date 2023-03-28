import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'dart:math' as math;

/// First plugin test method.
void main() => runApp(_FlutterWeekViewDemoApp());

/// The demo material app.
class _FlutterWeekViewDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Week View',
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Week View"),
          ),
          body: _DemoWeekView(),
        ),
      );
}

class _DemoWeekView extends StatefulWidget {
  @override
  State<_DemoWeekView> createState() => _DemoWeekViewState();
}

class _DemoWeekViewState extends State<_DemoWeekView> {
  DateTime now = DateTime.now();
  List<String> weeks = [
    "_",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thrusday",
    "Friday",
    "Saturday"
  ];

  HourMinute hourMinute = HourMinute.now();
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(weeks.length, (index) {
                if (index == 0) {
                  return Container(
                    alignment: Alignment.center,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade100)),
                    child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 12,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "GMT",
                          // style: TextStyle(fontSize: 8),
                        )),
                  );
                }
                return Container(
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade100)),
                  child: Text(weeks[index]),
                );
              })),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: WeekView(
              // inScrollableWidget: false,
              dayViewStyleBuilder: (date) => const DayViewStyle(
                  hourRowHeight: 80,
                  backgroundColor: Colors.white,
                  currentTimeCircleColor: Colors.red,
                  currentTimeRuleColor: Colors.red),
              currentTimeIndicatorBuilder:
                  (dayViewStyle, topOffsetCalculator, hoursColumnWidth, isRtl) {
                List<Widget> children = [
                  if (dayViewStyle.currentTimeRuleHeight > 0 &&
                      dayViewStyle.currentTimeRuleColor != null)
                    Expanded(
                      child: Container(
                        height: dayViewStyle.currentTimeRuleHeight,
                        color: dayViewStyle.currentTimeRuleColor,
                      ),
                    ),
                  if (dayViewStyle.currentTimeCircleRadius > 0 &&
                      dayViewStyle.currentTimeCircleColor != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      // height: dayViewStyle.currentTimeCircleRadius * 2,
                      // width: dayViewStyle.currentTimeCircleRadius * 2,
                      decoration: BoxDecoration(
                        color: dayViewStyle.currentTimeCircleColor,
                        borderRadius: BorderRadius.circular(12),
                        // shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${hourMinute.hour}:${hourMinute.minute}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ];

                final timeIndicatorHight = math.max(
                  dayViewStyle.currentTimeRuleHeight,
                  dayViewStyle.currentTimeCircleRadius * 2,
                );

                if (dayViewStyle.currentTimeCirclePosition ==
                    CurrentTimeCirclePosition.left) {
                  children = children.reversed.toList();
                }

                return Positioned(
                  top: topOffsetCalculator(hourMinute) - timeIndicatorHight / 2,
                  left: isRtl ? 0 : hoursColumnWidth,
                  right: isRtl ? hoursColumnWidth : 0,
                  child: Row(children: children),
                );
              },
              onHoursColumnTappedDown: (time) {
                setState(() {
                  hourMinute = time;
                });
              },
              onDayBarTappedDown: (date) {
                setState(() {
                  hourMinute = HourMinute.fromDateTime(dateTime: date);
                });
              },
              onBackgroundTappedDown: (date) {
                // print(date);
                setState(() {
                  hourMinute = HourMinute.fromDateTime(dateTime: date);
                });
              },

              style: WeekViewStyle(
                  headerSize: 0,
                  dayViewWidth: 250,
                  dayViewSeparatorWidth: 1,
                  dayViewSeparatorColor: Colors.grey.shade300),
              initialTime: const HourMinute(hour: 7).atDate(DateTime.now()),
              hoursColumnStyle: HoursColumnStyle(
                  color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade100))),
              dayBarStyleBuilder: (date) => DayBarStyle(
                  color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade100))),
              dates: [
                date.subtract(const Duration(days: 1)),
                date,
                date.add(const Duration(days: 1)),
                date.add(const Duration(days: 2)),
                date.add(const Duration(days: 3)),
                date.add(const Duration(days: 4))
              ],
              events: [
                FlutterWeekViewEvent(
                  title: 'An event 1',
                  description: 'A description 1',
                  start: date.subtract(const Duration(hours: 1)),
                  end: date.add(const Duration(hours: 5, minutes: 30)),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                ),
                FlutterWeekViewEvent(
                  title: 'An event 2',
                  description: 'A description 2',
                  start: date.add(const Duration(days: 3, hours: 6)),
                  end: date.add(const Duration(days: 3, hours: 8)),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    // borderRadius: BorderRadius.circular(8)
                  ),
                  eventTextBuilder: (event, context, dayView, height, width) =>
                      Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.blueGrey.shade100,
                            child: Text(TimeOfDay.fromDateTime(
                                    date.add(const Duration(hours: 6)))
                                .format(context)),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Lunch Break",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
                FlutterWeekViewEvent(
                  title: 'An event 3',
                  description: 'A description 3',
                  start:
                      date.add(const Duration(days: 2, hours: 23, minutes: 30)),
                  end:
                      date.add(const Duration(days: 2, hours: 28, minutes: 30)),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8)),
                ),
                FlutterWeekViewEvent(
                  title: 'An event 4',
                  description: 'A description 4',
                  start: date.add(const Duration(hours: 20)),
                  end: date.add(const Duration(hours: 21)),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(8)),
                ),
                FlutterWeekViewEvent(
                  title: 'An event 5',
                  description: 'A description 5',
                  start: date.add(const Duration(hours: 20)),
                  end: date.add(const Duration(hours: 21)),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A day view that displays dynamically added events.