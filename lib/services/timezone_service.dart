import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tzs;

import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  static TimezoneService? _instance;
  static String? timezoneString;

  TimezoneService._internal();

  set timezoneStringData(String? timezone) {
    timezoneString = timezone;
  }

  String? get getTimezoneString => timezoneString;

  static TimezoneService? getInstance() {
    tz.initializeTimeZones();
    _instance ??= TimezoneService._internal();
    return _instance;
  }

  tz.TZDateTime getCurrentDateTime() {
    tzs.Location location = tz.getLocation(timezoneString!);
    final localizedDt = tz.TZDateTime.from(DateTime.now(), location);
    tz.setLocalLocation(location);
    return localizedDt;
  }

  DateTime getUTCDateTime(DateTime scheduledPostDateTime) {
    /// Get Time zone offset from IST Format
    DateTime scheduledPostDateTimeUTC = scheduledPostDateTime.toUtc();

    Duration localTimezoneOffset = scheduledPostDateTime.timeZoneOffset;

    /// Get Location from Timezone name
    /// timezoneString is profile timezone string
    tz.Location location = tz.getLocation(timezoneString!);

    /// Get Date time from datetime and location
    final localizedDt = tz.TZDateTime.from(scheduledPostDateTimeUTC, location);
    Duration profileTimezoneOffset = localizedDt.timeZoneOffset;
    final scheduledPostDateTimeInUTCAccToProfileTime = scheduledPostDateTimeUTC
        .add(localTimezoneOffset)
        .subtract(profileTimezoneOffset);
    return scheduledPostDateTimeInUTCAccToProfileTime;
  }

  DateTime? convertToTimezoneDate(DateTime dateTime) {
    /// Get Time zone offset from IST Format
    Duration currentDuration = dateTime.timeZoneOffset;

    /// Get Location from Timezone name
    if (timezoneString != null) {
      tz.Location location = tz.getLocation(timezoneString!);

      /// Get Date time from datetime and location
      final localizedDt = tz.TZDateTime.from(dateTime, location);

      /// Substract localizedDt.timeZoneOffset
      final convertedDT =
          dateTime.add(currentDuration).add(localizedDt.timeZoneOffset);
      return convertedDT.toUtc();
    }
    return null;
  }

  String getTimezoneGMT(DateTime dateTime) {
    tzs.Location location = tzs.getLocation(timezoneString!);
    final localizedDt = tz.TZDateTime.from(dateTime, location);
    return localizedDt.timeZoneOffset.toString();
  }

  String? getCurrentGMHours() {
    if (timezoneString != null) {
      tzs.Location location = tzs.getLocation(timezoneString!);
      final localizedDt = tz.TZDateTime.from(DateTime.now(), location);
      return "${localizedDt.timeZoneOffset.inHours}: ${localizedDt.timeZoneOffset.inMinutes}";
    }
    return null;
  }

  Duration getCurrentGMDuration() {
    tzs.Location location = tzs.getLocation(timezoneString!);
    final localizedDt = tz.TZDateTime.from(DateTime.now(), location);
    return localizedDt.timeZoneOffset;
  }
}
