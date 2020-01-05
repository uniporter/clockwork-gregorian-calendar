
import 'package:clockwork/clockwork.dart';

import 'units/month.dart';
import 'timestamp_extension.dart';

/// Returns whether [year] is a leap year.
bool isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

/// Returns the number of days since the epoch corresponding to the given [year], [month], and [day].
int daysSinceEpoch(int year, Month month, int day) {
    if (month == Month.skip) throw InvalidArgumentException('month');
    if (day <= 0 || day > daysPerMonth(month, year)) throw InvalidArgumentException('day');

    if (month.index <= 2) year--; // Converts year to the internal year numbering which starts from March.
    final era = (year >= 0 ? year : year - 399) ~/ 400;
    final yearOfEra = year - era * 400;
    final dayOfYear = _dayOfInternalYear(month, day);
    final dayOfEra = yearOfEra * 365 + yearOfEra ~/ 4 - yearOfEra ~/ 100 + dayOfYear;
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
int _dayOfInternalYear(Month month, int day) {
    return ((153 * (month.index + (month.index > 2 ? -3 : 9)) + 2) / 5 + day - 1).toInt();
}

final int daysPerLeapYear = Month.values.skip(0).fold(0, (count, month) => count += daysPerMonth(month, leapYearsSinceEpoch().first));
final int daysPerNonLeapYear = Month.values.skip(0).fold(0, (count, month) => count += daysPerMonth(month, nonLeapYearsSinceEpoch().first));

final int microsecondsPerLeapYear = microsecondsPerDay * daysPerLeapYear;
final int microsecondsPerNonLeapYear = microsecondsPerDay * daysPerNonLeapYear;


/// Returns the number of days in [year].
int daysPerYear(int year) => isLeapYear(year) ? daysPerLeapYear : daysPerNonLeapYear;

int microsecondsInMonth(Month month, int year) {
    if (month == Month.skip) throw InvalidArgumentException('month');

    return microsecondsPerDay * daysPerMonth(month, year);
}

int microsecondsPerYear(int year) => isLeapYear(year) ? microsecondsPerLeapYear : microsecondsPerNonLeapYear;


/// Returns the number of days in [month] of [year].
int daysPerMonth(Month month, int year) {
    const MONTHS_WITH_31_DAYS = [Month.January, Month.March, Month.May, Month.July, Month.August, Month.October, Month.December];
    const MONTHS_WITH_30_DAYS = [Month.April, Month.June, Month.September, Month.November];

    if (month == Month.skip) throw InvalidArgumentException('month');

    if (MONTHS_WITH_31_DAYS.contains(month)) return 31;
    else if (MONTHS_WITH_30_DAYS.contains(month)) return 30;
    else if (isLeapYear(year)) return 29;
    else return 28;
}

/// Returns an iterable of leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<int> leapYearsSinceEpoch() sync* {
    int currYear = Timestamp.epochUTC().year;
    while (true) if (isLeapYear(currYear)) yield currYear++;
}

/// Returns an iterable of non leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<int> nonLeapYearsSinceEpoch() sync* {
    int currYear = Timestamp.epochUTC().year;
    while (true) if (!isLeapYear(currYear)) yield currYear++;
}