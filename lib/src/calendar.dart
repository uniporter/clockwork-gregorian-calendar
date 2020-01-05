import 'package:clockwork/clockwork.dart';

import 'timestamp_extension.dart';
import 'units/month.dart';
import 'utils.dart';

class GregorianCalendar extends Calendar {
    final String name = 'gregorian';

    static final GregorianCalendar _singleton = GregorianCalendar._internal();
    factory GregorianCalendar() => _singleton;
    GregorianCalendar._internal();

    /// Returns a timestamp from the explicitly provided timezone and timestamp components.
    ///
    /// Note: In certain cases a given TimestampComponents and a timezone alone do not suffice to determine an unique instant.
    /// In this case [AmbiguousTimestampException] will be thrown. Othertimes the components are valid but the time actually
    /// doesn't exist, in which case [TimestampNonexistentException] will be thrown.
    Timestamp fromComponents(TimeZone timezone, int year, Month month, int day, [int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) {
        if (timezone == null) throw InvalidArgumentException('timezone');
        else if (month == Month.skip) throw InvalidArgumentException('month');
        else if (day <= 0 || day > daysPerMonth(month, year)) throw InvalidArgumentException('day');
        else if (hour < 0 || hour > 23) throw InvalidArgumentException('hour');
        else if (minute < 0 || minute > 59) throw InvalidArgumentException('minute');
        else if (second < 0 || second > 59) throw InvalidArgumentException('second');
        else if (millisecond < 0 || millisecond > 999) throw InvalidArgumentException('millisecond');
        else if (microsecond < 0 || microsecond > 999) throw InvalidArgumentException('microsecond');

        final surmisedComponents = GregorianCalendarComponents(
            year: year,
            month: month,
            day: day,
        );

        final surmisedMicrosecondsSinceEpochOffseted = daysSinceEpoch(year, month, day) * microsecondsPerDay + hour * microsecondsPerHour + minute * microsecondsPerMinute + second * microsecondsPerSecond + millisecond * microsecondsPerMillisecond + microsecond;
        final surmisedHistory1 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochOffseted);
        final surmisedOffsetInMicroseconds1 = (timezone.possibleOffsets[surmisedHistory1.index] * microsecondsPerMinute).truncate();
        final surmisedMicrosecondsSinceEpochUTC = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds1;

        final surmisedHistory2 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC);
        final surmisedOffsetInMicroseconds2 = (timezone.possibleOffsets[surmisedHistory2.index] * microsecondsPerMinute).truncate();
        if (surmisedOffsetInMicroseconds1 != surmisedOffsetInMicroseconds2) throw TimestampNonexistentException("FUCKed");

        final surmisedHistory2Index = timezone.history.indexOf(surmisedHistory2);
        if (surmisedHistory2Index > 0) {
            final surmisedHistory3 = timezone.history[surmisedHistory2Index - 1];
            final surmisedOffsetInMicroseconds3 = (timezone.possibleOffsets[surmisedHistory3.index] * microsecondsPerMinute).truncate();
            final surmisedMicrosecondsSinceEpochUTC2 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds3;

            final surmisedHistory4 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC2);
            final surmisedOffsetInMicroseconds4 = (timezone.possibleOffsets[surmisedHistory4.index] * microsecondsPerMinute).truncate();
            if (surmisedOffsetInMicroseconds3 == surmisedOffsetInMicroseconds4) throw AmbiguousTimestampException("FUCKed");
        }

        if (surmisedHistory2Index < timezone.history.length - 1) {
            final surmisedHistory5 = timezone.history[surmisedHistory2Index + 1];
            final surmisedOffsetInMicroseconds5 = (timezone.possibleOffsets[surmisedHistory5.index] * microsecondsPerMinute).truncate();
            final surmisedMicrosecondsSinceEpochUTC3 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds5;

            final surmisedHistory6 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC3);
            final surmisedOffsetInMicroseconds6 = (timezone.possibleOffsets[surmisedHistory6.index] * microsecondsPerMinute).truncate();
            if (surmisedOffsetInMicroseconds5 == surmisedOffsetInMicroseconds6) throw AmbiguousTimestampException("FUCKed");
        }

        final artifact = Timestamp(
            timezone,
            Instant(surmisedMicrosecondsSinceEpochUTC),
        );

        componentsCache[artifact] = surmisedComponents;
        return artifact;
    }

    @override int weekyear(Timestamp ts) => ts.weekyear;
}