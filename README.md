## Installation

Add `horizontal_week_calendar:` to your **pubspec.yaml** dependencies then run `flutter pub get`

```
 dependencies:
  horizontal_week_calendar:
```

## Import

Add this line to import the package.
```
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
```


## How to use

```dart
HorizontalWeekCalendar(
  onDateChange: (date) {
    setState(() {
      selectedDate = date;
    });
  },
),
```

## Preview

<img src="https://raw.githubusercontent.com/chandabdullah/horizontal_week_calendar/main/assets/android.png" alt="drawing" height="500"/>
