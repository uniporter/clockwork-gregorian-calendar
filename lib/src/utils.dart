
import 'package:clockwork/clockwork.dart';
import 'package:clockwork_gregorian_calendar/src/units/day.dart';
import 'package:clockwork_gregorian_calendar/src/units/year.dart';

import 'units/month.dart';
import 'timestamp_extension.dart';

/// Returns the number of days since the epoch corresponding to the given [year], [month], and [day].
int daysSinceEpoch(GregorianYear year, GregorianMonth month, GregorianDay day) {
    if (day <= 0 || day > GregorianMonth.daysPer(month, year)) throw InvalidArgumentException('day');

    if (month == GregorianMonth.January || month == GregorianMonth.February) year--; // Converts year to the internal year numbering which starts from March.
    final era = (year >= 0 ? year : year - 399)() ~/ 400;
    final yearOfEra = year - era * 400;
    final dayOfYear = _dayOfInternalYear(month, day);
    final dayOfEra = yearOfEra() * 365 + yearOfEra() ~/ 4 - yearOfEra() ~/ 100 + dayOfYear;
    return era * 146097 + dayOfEra - 719468;
}

/// Returns the index of day of the given timestamp in a year, assuming March 1st is the first day of the year. The numbering starts
/// with 0, so for instance March 1st gives 0, March 2nd gives 1, etc.
///
/// This function doesn't depend on what year it is because, due to the way we set up the internal year system, the only factor influencing
/// the day index, whether the year is a leap year or not (and thus whether Feb 29th exists), has no impact because Feb 29 is always the last
/// day of an internal year, so all other days have the same index regardless of whether the year is leap or not.
///
/// The function utilizes a clever algorithm by Howard Hinnant. For more information visit http://howardhinnant.github.io/date_algorithms.html.
int _dayOfInternalYear(GregorianMonth month, GregorianDay day) {
    return ((153 * (month.value + (month.value > 2 ? -3 : 9)) + 2) / 5 + day() - 1).toInt();
}

/// Returns an iterable of leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<GregorianYear> leapYearsSinceEpoch() sync* {
    var currYear = Timestamp.epochUTC().year;
    while (true) if (GregorianYear.isLeapYear(currYear)) yield currYear++;
}

/// Returns an iterable of non leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<GregorianYear> nonLeapYearsSinceEpoch() sync* {
    var currYear = Timestamp.epochUTC().year;
    while (true) if (!GregorianYear.isLeapYear(currYear)) yield currYear++;
}