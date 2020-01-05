

import 'package:clockwork/clockwork.dart';

import 'calendar.dart';
import 'units/day_period.dart';
import 'units/era.dart';
import 'units/fixed_day_period.dart';
import 'units/length.dart';
import 'units/month.dart';
import 'units/quarter.dart';
import 'units/weekday.dart';
import 'utils.dart';

Map<Timestamp, GregorianCalendarComponents> componentsCache = {};

extension GregorianCalendarExtension on Timestamp {
    void _cacheComponent() => componentsCache.containsKey(this) ? null : componentsCache[this] = GregorianCalendarComponents.fromTimestamp(this);

    GregorianCalendarComponents get _components {
        _cacheComponent();
        return componentsCache[this];
    }

    /// Returns the era.
    Era get era => year >= 1 ? Era.AD : Era.BC;
    /// Returns the year.
    int get year => _components.year;
    /// Returns the year of era.
    int get yearOfEra => year >= 1 ? year : year.abs() + 1;
    /// Returns the Month.
    Month get month => _components.month;
    /// Returns the day.
    int get day => _components.day;

    /// Returns the weekday.
    Weekday get weekday => Weekday.values[(daysSinceEpoch(year, month, day) + 4) % 7 + 1];
    /// Returns the ISO weekday.
    WeekdayISO get weekdayISO => WeekdayISO.values[(daysSinceEpoch(year, month, day) + 3) % 7 + 1];

    /// Returns the quarter.
    Quarter get quarter => Quarter.values[(month.index - 1) ~ 3 + 1];

    /// Returns the fixed day period (AM/PM).
    FixedDayPeriod get fixedDayPeriod => hour < 12 ? FixedDayPeriod.AM : FixedDayPeriod.PM;
    /// Returns the day period. This is a locale-dependent getter. Currently the locale defaults to [currLocale], but we expect this to change.
    DayPeriod get dayPeriod {
        final minutesSinceMidnight = hour * minutesPerHour + minute;
        return currLocale.dayPeriodsRule.keys.firstWhere((dayPeriod) => currLocale.dayPeriodsRule[dayPeriod].contains(minutesSinceMidnight));
    }

    /// Returns the week number of year according to the ISO8601 standard.
    int get weekOfYearISO {
        final isCurrLeapYear = isLeapYear(year);
        final isPrevLeapYear = isLeapYear(year - 1);

        final dayOfYearNumber = isCurrLeapYear && month.index > 2 ? dayOfYear + 1 : dayOfYear;
        final jan1Weekday = startOf(Length.YEAR).weekdayISO;
        final currWeekday = weekdayISO;

        var weekNumber;
        if (dayOfYearNumber <= (8 - jan1Weekday.index) && jan1Weekday > WeekdayISO.Thursday) {
            if (jan1Weekday == WeekdayISO.Friday || jan1Weekday == WeekdayISO.Saturday && isPrevLeapYear) weekNumber = 53;
            else weekNumber = 52;
        } else if (daysPerYear(year) - dayOfYearNumber < 4 - currWeekday.index) weekNumber = 1;
        else {
            final j = dayOfYearNumber + (7 - currWeekday.index) + (jan1Weekday.index - 1);
            weekNumber = j / 7;
            if (jan1Weekday.index > 4) weekNumber -= 1;
        }

        return weekNumber;
    }

    /// Returns the week year.
    int get weekyear => 0;    // TODO: implement

    /// Return a [Timestamp] at the start of [unit].
    Timestamp startOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? 0 : year,
            unit >= Length.MONTH ? Month.January : month,
            unit >= Length.DAY ? 0 : day,
            unit >= Length.HOUR ? 0 : hour,
            unit >= Length.MINUTE ? 0 : minute,
            unit >= Length.SECOND ? 0 : second,
            unit >= Length.MILLISECOND ? 0 : millisecond,
            unit >= Length.MICROSECOND ? 0 : microsecond,
        );
    }

    /// Return a [Timestamp] at the end of [unit]. TODO: Implement
    Timestamp endOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? 0 : year,
            unit >= Length.MONTH ? Month.January : month,
            unit >= Length.DAY ? 0 : day,
            unit >= Length.HOUR ? 0 : hour,
            unit >= Length.MINUTE ? 0 : minute,
            unit >= Length.SECOND ? 0 : second,
            unit >= Length.MILLISECOND ? 0 : millisecond,
            unit >= Length.MICROSECOND ? 0 : microsecond,
        );
    }

    /// Returns the number of days since the beginning of the year.
    int get dayOfYear => IterableRange<int>(1, month.index, (i) => i++).fold(0, (counter, month) => counter += daysPerMonth(Month.values[month], year)) + day;
}

/// A struct that holds the components specific to Gregorian calendars: [year], [month], and [day].
class GregorianCalendarComponents {
    final int year;
    final Month month;
    final int day;

    const GregorianCalendarComponents({
        required this.year,
        required this.month,
        required this.day,
    });

    /// Create a [GregorianCalendarComponents] from a given [Timestamp]. This is the recommended way to initialize a [GregorianCalendarComponents].
    factory GregorianCalendarComponents.fromTimestamp(Timestamp ts) {
        /// This is the timezoned microsecond timestamp of [ts]. For instance, if a region has offset +01:00, the utc microsecondsSinceEpoch is `500`,
        /// then this variable is `500 + 1 * microsecondsPerHour`.
        final microsecondsSinceEpoch = ts.instant.microSecondsSinceEpoch() + ts.timezone.offset(ts.instant.microSecondsSinceEpoch()).asMicroseconds();
        final microsecondsSinceInternalEpoch = microsecondsSinceEpoch + -(ts.timezone.possibleOffsets[ts.timezone.history.firstWhere((his) => his.until >= microsecondsSinceEpoch).index] * microsecondsPerMinute).truncate();
        final daysSinceEpoch = microsecondsSinceInternalEpoch ~/ microsecondsPerDay;

        /// Turns epoch to `Mar 1st, 0000`.
        final daysSinceInternalEpoch = daysSinceEpoch + 719468;
        final era = (daysSinceInternalEpoch >= 0 ? daysSinceInternalEpoch : daysSinceInternalEpoch - 146096) ~/ 146097;
        final dayOfEra = daysSinceInternalEpoch - era * 146097;
        final yearOfEra = (dayOfEra - dayOfEra ~/ 1460 + dayOfEra ~/ 36524 - dayOfEra ~/ 146096) ~/ 365;

        final dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra ~/ 4 - yearOfEra ~/ 100);
        final internalMonth = (5 * dayOfYear + 2) ~/ 153;
        final finalMonth  = internalMonth + (internalMonth < 10 ? 3 : -9);
        final finalDay = dayOfYear - (153 * internalMonth + 2) ~/ 5 + 1;
        final finalYear = yearOfEra + era * 400;

        return GregorianCalendarComponents(
            year: finalYear,
            month: Month.values[finalMonth],
            day: finalDay,
        );
    }
}
