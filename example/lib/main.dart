import 'package:flutter/material.dart';
// import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:intl/intl.dart';
import 'package:packages_test/horizotal_week_calendar/horizontal_week_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Packages Test',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HorizontalWeekCalendarPackage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HorizontalWeekCalendarPackage extends StatefulWidget {
  const HorizontalWeekCalendarPackage({super.key});

  @override
  State<HorizontalWeekCalendarPackage> createState() =>
      _HorizontalWeekCalendarPackageState();
}

class _HorizontalWeekCalendarPackageState
    extends State<HorizontalWeekCalendarPackage> {
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Horizontal Week Calendar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              HorizontalWeekCalendar(
                minDate: DateTime(2023, 12, 31),
                maxDate: DateTime(2024, 1, 31),
                initialDate: DateTime(2024, 1, 15),
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                showTopNavbar: false,
                monthFormat: "MMMM yyyy",
                showNavigationButtons: true,
                weekStartFrom: WeekStartFrom.Monday,
                borderRadius: BorderRadius.circular(7),
                activeBackgroundColor: Colors.deepPurple,
                activeTextColor: Colors.white,
                inactiveBackgroundColor: Colors.deepPurple.withOpacity(.3),
                inactiveTextColor: Colors.white,
                disabledTextColor: Colors.grey,
                disabledBackgroundColor: Colors.grey.withOpacity(.3),
                activeNavigatorColor: Colors.deepPurple,
                inactiveNavigatorColor: Colors.grey,
                monthColor: Colors.deepPurple,
                onWeekChange: (List<DateTime> dates) {},
                scrollPhysics: const BouncingScrollPhysics(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Selected Date",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('dd MMM yyyy').format(selectedDate),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
