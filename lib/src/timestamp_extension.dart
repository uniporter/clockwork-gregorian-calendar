

import 'package:clockwork/clockwork.dart';
import 'package:clockwork_gregorian_calendar/src/units/day.dart';
import 'package:clockwork_gregorian_calendar/src/units/year.dart';
import 'package:clockwork_gregorian_calendar/src/units/year_of_era.dart';

import 'calendar.dart';
import 'units/era.dart';
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
    GregorianEra get era => year >= 1 ? GregorianEra.AD : GregorianEra.BC;
    /// Returns the year.
    GregorianYear get year => _components.year;
    /// Returns the year of era.
    GregorianYearOfEra get yearOfEra => year >= 1 ? GregorianYearOfEra(year()) : GregorianYearOfEra(year().abs() + 1);
    /// Returns the Month.
    GregorianMonth get month => _components.month;
    /// Returns the day.
    GregorianDay get day => _components.day;

    /// Returns the weekday.
    GregorianWeekday get weekday => GregorianWeekday(daysSinceEpoch(year, month, day + 4) % 7 + 1);

    /// Returns the quarter.
    GregorianQuarter get quarter => GregorianQuarter((month() - 1) ~/ 3 + 1);

    /// Returns the fixed day period (AM/PM).
    FixedDayPeriod get fixedDayPeriod => hour < 12 ? FixedDayPeriod.AM : FixedDayPeriod.PM;
    /// Returns the day period. This is a locale-dependent getter. Currently the locale defaults to [currLocale], but we expect this to change.
    DayPeriod get dayPeriod {
        final minutesSinceMidnight = hour() * Hour.minutesPer + minute();
        return currLocale.dayPeriodsRule.keys.firstWhere((dayPeriod) => currLocale.dayPeriodsRule[dayPeriod].contains(minutesSinceMidnight));
    }

    /// Returns the week year.
    GregorianYear get weekyear => GregorianYear(0);    // TODO: implement

    /// Return a [Timestamp] at the start of [unit].
    Timestamp startOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? GregorianYear(0) : year,
            unit >= Length.MONTH ? GregorianMonth.January : month,
            unit >= Length.DAY ? GregorianDay(1, unit >= Length.MONTH ? GregorianMonth.January : month, unit >= Length.YEAR ? GregorianYear(0) : year) : day,
            unit >= Length.HOUR ? Hour(0) : hour,
            unit >= Length.MINUTE ? Minute(0) : minute,
            unit >= Length.SECOND ? Second(0) : second,
            unit >= Length.MILLISECOND ? Millisecond(0) : millisecond,
            unit >= Length.MICROSECOND ? Microsecond(0) : microsecond,
        );
    }

    /// Return a [Timestamp] at the end of [unit]. TODO: Implement
    Timestamp endOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? GregorianYear(0) : year,
            unit >= Length.MONTH ? GregorianMonth.January : month,
            unit >= Length.DAY ? GregorianDay(1, unit >= Length.MONTH ? GregorianMonth.January : month, unit >= Length.YEAR ? GregorianYear(0) : year) : day,
            unit >= Length.HOUR ? Hour(0) : hour,
            unit >= Length.MINUTE ? Minute(0) : minute,
            unit >= Length.SECOND ? Second(0) : second,
            unit >= Length.MILLISECOND ? Millisecond(0) : millisecond,
            unit >= Length.MICROSECOND ? Microsecond(0) : microsecond,
        );
    }

    /// Returns the number of days since the beginning of the year.
    int get dayOfYear => IterableRange<GregorianMonth>(GregorianMonth.January, month, (i) => i = i + 1).fold(0, (counter, month) => counter += GregorianMonth.daysPer(month, year)) + day;
}

/// A struct that holds the components specific to Gregorian calendars: [year], [month], and [day].
class GregorianCalendarComponents {
    final GregorianYear year;
    final GregorianMonth month;
    final GregorianDay day;

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
        final microsecondsSinceInternalEpoch = microsecondsSinceEpoch + -(ts.timezone.possibleOffsets[ts.timezone.history.firstWhere((his) => his.until >= microsecondsSinceEpoch).index] * Minute.microsecondsPer).truncate();
        final daysSinceEpoch = microsecondsSinceInternalEpoch ~/ Day.microsecondsPer;

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
            year: GregorianYear(finalYear),
            month: GregorianMonth(finalMonth),
            day: GregorianDay(finalDay, GregorianMonth(finalMonth), GregorianYear(finalYear)),
        );
    }
}
