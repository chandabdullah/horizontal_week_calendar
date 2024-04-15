import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

enum WeekStartFrom {
  Sunday,
  Monday,
}

class HorizontalWeekCalendar extends StatefulWidget {
  /// week start from Monday or Sunday
  ///
  /// default value is
  /// ```dart
  /// [WeekStartFrom.Monday]
  /// ```
  final WeekStartFrom? weekStartFrom;

  ///get DateTime on date select
  ///
  /// ```dart
  /// onDateChange: (DateTime date){
  ///    print(date);
  /// }
  /// ```
  final Function(DateTime)? onDateChange;

  ///get the list of DateTime on week change
  ///
  /// ```dart
  /// onWeekChange: (List<DateTime> list){
  ///    print("First date: ${list.first}");
  ///    print("Last date: ${list.last}");
  /// }
  /// ```
  final Function(List<DateTime>)? onWeekChange;

  /// Active background color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeBackgroundColor;

  /// In-Active background color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor.withOpacity(.2)
  /// ```
  final Color? inactiveBackgroundColor;

  /// Disable background color
  ///
  /// Default value is
  /// ```dart
  /// Colors.grey
  /// ```
  final Color? disabledBackgroundColor;

  /// Active text color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeTextColor;

  /// In-Active text color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor.withOpacity(.2)
  /// ```
  final Color? inactiveTextColor;

  /// Disable text color
  ///
  /// Default value is
  /// ```dart
  /// Colors.grey
  /// ```
  final Color? disabledTextColor;

  /// Active Navigator color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeNavigatorColor;

  /// In-Active Navigator color
  ///
  /// Default value is
  /// ```dart
  /// Colors.grey
  /// ```
  final Color? inactiveNavigatorColor;

  /// Month Color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor.withOpacity(.2)
  /// ```
  final Color? monthColor;

  /// border radius of date card
  ///
  /// Default value is `null`
  final BorderRadiusGeometry? borderRadius;

  /// scroll physics
  ///
  /// Default value is
  /// ```
  /// scrollPhysics: const ClampingScrollPhysics(),
  /// ```
  final ScrollPhysics? scrollPhysics;

  /// showNavigationButtons
  ///
  /// Default value is `true`
  final bool? showNavigationButtons;

  /// monthFormat
  ///
  /// If it's current year then
  /// Default value will be ```MMMM```
  ///
  /// Otherwise
  /// Default value will be `MMMM yyyy`
  final String? monthFormat;

  const HorizontalWeekCalendar({
    super.key,
    this.onDateChange,
    this.onWeekChange,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
    this.disabledBackgroundColor,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor,
    this.disabledTextColor,
    this.activeNavigatorColor,
    this.inactiveNavigatorColor,
    this.monthColor,
    this.weekStartFrom = WeekStartFrom.Monday,
    this.borderRadius,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.showNavigationButtons = true,
    this.monthFormat,
  });

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  CarouselController carouselController = CarouselController();

  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<DateTime> currentWeek = [];
  int currentWeekIndex = 0;

  List<List<DateTime>> listOfWeeks = [];

  @override
  void initState() {
    initCalender();
    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  initCalender() {
    final date = DateTime.now();

    DateTime startOfCurrentWeek = widget.weekStartFrom == WeekStartFrom.Monday
        ? getDate(date.subtract(Duration(days: date.weekday - 1)))
        : getDate(date.subtract(Duration(days: date.weekday % 7)));

    currentWeek.add(startOfCurrentWeek);
    for (int index = 0; index < 6; index++) {
      DateTime addDate = startOfCurrentWeek.add(Duration(days: (index + 1)));
      currentWeek.add(addDate);
    }

    listOfWeeks.add(currentWeek);

    getMorePreviousWeeks();
  }

  getMorePreviousWeeks() {
    List<DateTime> minus7Days = [];
    DateTime startFrom = listOfWeeks.isEmpty
        ? DateTime.now()
        : listOfWeeks[currentWeekIndex].isEmpty
            ? DateTime.now()
            : listOfWeeks[currentWeekIndex][0];

    for (int index = 0; index < 7; index++) {
      DateTime minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
    }
    listOfWeeks.add(minus7Days.reversed.toList());
    setState(() {});
  }

  onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  onBackClick() {
    carouselController.nextPage();
  }

  onNextClick() {
    carouselController.previousPage();
  }

  onWeekChange(index) {
    if (currentWeekIndex < index) {
      // on back
    }
    if (currentWeekIndex > index) {
      // on next
    }

    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    if (currentWeekIndex + 1 == listOfWeeks.length) {
      getMorePreviousWeeks();
    }

    widget.onWeekChange?.call(currentWeek);
    setState(() {});
  }

  // =================

  isNextDisabled() {
    return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  isCurrentYear() {
    return DateFormat('yyyy').format(currentWeek[0]) ==
        DateFormat('yyyy').format(today);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var withOfScreen = MediaQuery.of(context).size.width;

    // double boxHeight = withOfScreen / 7;

    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.showNavigationButtons == true
                      ? GestureDetector(
                          onTap: () {
                            onBackClick();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new,
                                size: 17,
                                color: widget.activeNavigatorColor ??
                                    theme.primaryColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Back",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: widget.activeNavigatorColor ??
                                      theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    widget.monthFormat?.isEmpty ?? true
                        ? (isCurrentYear()
                            ? DateFormat('MMMM').format(
                                currentWeek[0],
                              )
                            : DateFormat('MMMM yyyy').format(
                                currentWeek[0],
                              ))
                        : DateFormat(widget.monthFormat).format(
                            currentWeek[0],
                          ),
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.monthColor ?? theme.primaryColor,
                    ),
                  ),
                  widget.showNavigationButtons == true
                      ? GestureDetector(
                          onTap: isNextDisabled()
                              ? () {
                                  onNextClick();
                                }
                              : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Next",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: isNextDisabled()
                                      ? theme.primaryColor
                                      : widget.inactiveNavigatorColor ??
                                          Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                                color: isNextDisabled()
                                    ? theme.primaryColor
                                    : widget.inactiveNavigatorColor ??
                                        Colors.grey,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              CarouselSlider(
                carouselController: carouselController,
                items: [
                  if (listOfWeeks.isNotEmpty)
                    for (int ind = 0; ind < listOfWeeks.length; ind++)
                      SizedBox(
                        // height: boxHeight,
                        width: double.infinity,
                        // color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int weekIndex = 0;
                                weekIndex < listOfWeeks[ind].length;
                                weekIndex++)
                              Expanded(
                                child: GestureDetector(
                                  onTap: listOfWeeks[ind][weekIndex]
                                          .isBefore(DateTime.now())
                                      ? () {
                                          onDateSelect(
                                            listOfWeeks[ind][weekIndex],
                                          );
                                        }
                                      : null,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: widget.borderRadius,
                                      color: DateFormat('dd-MM-yyyy').format(
                                                  listOfWeeks[ind]
                                                      [weekIndex]) ==
                                              DateFormat('dd-MM-yyyy')
                                                  .format(selectedDate)
                                          ? widget.activeBackgroundColor ??
                                              theme.primaryColor
                                          : listOfWeeks[ind][weekIndex]
                                                  .isBefore(DateTime.now())
                                              ? widget.inactiveBackgroundColor ??
                                                  theme.primaryColor
                                                      .withOpacity(.2)
                                              : widget.disabledBackgroundColor ??
                                                  Colors.grey,
                                      border: Border.all(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          // "$weekIndex: ${listOfWeeks[ind][weekIndex] == DateTime.now()}",
                                          "${listOfWeeks[ind][weekIndex].day}",
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleLarge!
                                              .copyWith(
                                            color: DateFormat('dd-MM-yyyy')
                                                        .format(listOfWeeks[ind]
                                                            [weekIndex]) ==
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate)
                                                ? widget.activeTextColor ??
                                                    Colors.white
                                                : listOfWeeks[ind][weekIndex]
                                                        .isBefore(
                                                            DateTime.now())
                                                    ? widget.inactiveTextColor ??
                                                        Colors.white
                                                            .withOpacity(.2)
                                                    : widget.disabledTextColor ??
                                                        Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          DateFormat(
                                            'EEE',
                                          ).format(
                                            listOfWeeks[ind][weekIndex],
                                          ),
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                            color: DateFormat('dd-MM-yyyy')
                                                        .format(listOfWeeks[ind]
                                                            [weekIndex]) ==
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate)
                                                ? widget.activeTextColor ??
                                                    Colors.white
                                                : listOfWeeks[ind][weekIndex]
                                                        .isBefore(
                                                            DateTime.now())
                                                    ? widget.inactiveTextColor ??
                                                        Colors.white
                                                            .withOpacity(.2)
                                                    : widget.disabledTextColor ??
                                                        Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                ],
                options: CarouselOptions(
                  // scrollPhysics: const ClampingScrollPhysics(),
                  scrollPhysics:
                      widget.scrollPhysics ?? const ClampingScrollPhysics(),
                  height: 75,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: true,
                  onPageChanged: (index, reason) {
                    onWeekChange(index);
                  },
                ),
              ),
            ],
          );
  }
}
