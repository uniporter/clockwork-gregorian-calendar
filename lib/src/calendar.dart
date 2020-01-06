import 'package:clockwork/clockwork.dart';
import 'package:clockwork_gregorian_calendar/src/units/day.dart';
import 'package:clockwork_gregorian_calendar/src/units/year.dart';
import 'package:clockwork_gregorian_calendar/src/units/year_of_era.dart';

import 'timestamp_extension.dart';
import 'utils.dart';

class GregorianCalendar extends Calendar {
    final String name = 'Gregorian';

    static final GregorianCalendar _singleton = GregorianCalendar._internal();
    factory GregorianCalendar() => _singleton;
    GregorianCalendar._internal();

    /// Returns a timestamp from the explicitly provided timezone and timestamp components.
    ///
    /// Note: In certain cases a given TimestampComponents and a timezone alone do not suffice to determine an unique instant.
    /// In this case [AmbiguousTimestampException] will be thrown. Othertimes the components are valid but the time actually
    /// doesn't exist, in which case [TimestampNonexistentException] will be thrown.
    Timestamp fromComponents(TimeZone timezone, GregorianYear year, GregorianMonth month, GregorianDay day, [Hour? hour, Minute? minute, Second? second, Millisecond? millisecond, Microsecond? microsecond]) {
        final _hour = hour ?? Hour(0);
        final _minute = minute ?? Minute(0);
        final _second = second ?? Second(0);
        final _millisecond = millisecond ?? Millisecond(0);
        final _microsecond = microsecond ?? Microsecond(0);


        final surmisedComponents = GregorianCalendarComponents(
            year: year,
            month: month,
            day: day,
        );

        final surmisedMicrosecondsSinceEpochOffseted = daysSinceEpoch(year, month, day) * Day.microsecondsPer + _hour() * Hour.microsecondsPer + _minute() * Minute.microsecondsPer + _second() * Second.microsecondsPer + _millisecond() * Millisecond.microsecondsPer + _microsecond();
        final surmisedHistory1 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochOffseted);
        final surmisedOffsetInMicroseconds1 = (timezone.possibleOffsets[surmisedHistory1.index] * Minute.microsecondsPer).truncate();
        final surmisedMicrosecondsSinceEpochUTC = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds1;

        final surmisedHistory2 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC);
        final surmisedOffsetInMicroseconds2 = (timezone.possibleOffsets[surmisedHistory2.index] * Minute.microsecondsPer).truncate();
        if (surmisedOffsetInMicroseconds1 != surmisedOffsetInMicroseconds2) throw TimestampNonexistentException("FUCKed");

        final surmisedHistory2Index = timezone.history.indexOf(surmisedHistory2);
        if (surmisedHistory2Index > 0) {
            final surmisedHistory3 = timezone.history[surmisedHistory2Index - 1];
            final surmisedOffsetInMicroseconds3 = (timezone.possibleOffsets[surmisedHistory3.index] * Minute.microsecondsPer).truncate();
            final surmisedMicrosecondsSinceEpochUTC2 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds3;

            final surmisedHistory4 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC2);
            final surmisedOffsetInMicroseconds4 = (timezone.possibleOffsets[surmisedHistory4.index] * Minute.microsecondsPer).truncate();
            if (surmisedOffsetInMicroseconds3 == surmisedOffsetInMicroseconds4) throw AmbiguousTimestampException("FUCKed");
        }

        if (surmisedHistory2Index < timezone.history.length - 1) {
            final surmisedHistory5 = timezone.history[surmisedHistory2Index + 1];
            final surmisedOffsetInMicroseconds5 = (timezone.possibleOffsets[surmisedHistory5.index] * Minute.microsecondsPer).truncate();
            final surmisedMicrosecondsSinceEpochUTC3 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds5;

            final surmisedHistory6 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC3);
            final surmisedOffsetInMicroseconds6 = (timezone.possibleOffsets[surmisedHistory6.index] * Minute.microsecondsPer).truncate();
            if (surmisedOffsetInMicroseconds5 == surmisedOffsetInMicroseconds6) throw AmbiguousTimestampException("FUCKed");
        }

        final artifact = Timestamp(
            timezone,
            Instant(surmisedMicrosecondsSinceEpochUTC),
        );

        componentsCache[artifact] = surmisedComponents;
        return artifact;
    }

    @override GregorianYear weekYear(Timestamp ts) => ts.weekyear;
    @override GregorianYearOfEra yearOfEra(Timestamp ts) => ts.yearOfEra;
    @override GregorianYear year(Timestamp ts) => ts.year;

    @override GregorianWeekday weekday(Timestamp ts) => ts.weekday;
    @override GregorianDay day(Timestamp ts) => ts.day;
    @override GregorianMonth month(Timestamp ts) => ts.month;

    @override GregorianEra era(Timestamp ts) => ts.era;
    @override GregorianQuarter quarter(Timestamp ts) => ts.quarter;
}