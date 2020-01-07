import 'package:clockwork/clockwork.dart';
import 'package:clockwork_gregorian_calendar/src/utils.dart';

class GregorianYear extends Year {
    GregorianYear(int value): super(value);

    /// Returns whether [year] is a leap year.
    static isLeapYear(GregorianYear year) => year() % 4 == 0 && (year() % 100 != 0 || year() % 400 == 0);

    static int weeksPer(GregorianYear year, [Locale? locale, GregorianWeekday? firstDayOfYear]) {
        if (firstDayOfYear == null) {
            final zeroBasedWeekdayFirstDayOfYear = (daysSinceEpoch(year, GregorianMonth.January, GregorianDay(1, GregorianMonth.January, year)) - 2) % 7;
            firstDayOfYear = zeroBasedWeekdayFirstDayOfYear == 0 ? GregorianWeekday.Saturday : GregorianWeekday(zeroBasedWeekdayFirstDayOfYear);
        }

        final partialWeekLength = (nonNullLocale(locale).weekData.firstDayOfWeek - firstDayOfYear()) % 7;
        final isFirstDayCounted = partialWeekLength == 0 || partialWeekLength >= nonNullLocale(locale).weekData.minDaysInWeek;

        /// The first day of *next year*.
        final firstDayOfNextYear = (firstDayOfYear() + daysPer(year)) % 7 != 0 ? GregorianWeekday((firstDayOfYear() + daysPer(year)) % 7) : GregorianWeekday.Saturday;
        final nextPartialWeekLength = (nonNullLocale(locale).weekData.firstDayOfWeek - firstDayOfNextYear()) % 7;
        final isLastWeekOfYearCounted = nextPartialWeekLength != 0 && nextPartialWeekLength < nonNullLocale(locale).weekData.minDaysInWeek;

        final daysInYear = daysPer(year);
        return (daysInYear / 7).ceil() + (isFirstDayCounted ? 1 : 0) + (isLastWeekOfYearCounted ? 0 : -1);
    }

    static const monthsPer = 12;
    static int daysPer(GregorianYear year) => isLeapYear(year) ? 366 : 365;
    static int hoursPer(GregorianYear year) => daysPer(year) * Day.hoursPer;
    static int minutesPer(GregorianYear year) => daysPer(year) * Day.minutesPer;
    static int secondsPer(GregorianYear year) => daysPer(year) * Day.secondsPer;
    static int millisecondsPer(GregorianYear year) => daysPer(year) * Day.millisecondsPer;
    static int microsecondsPer(GregorianYear year) => daysPer(year) * Day.microsecondsPer;

    @override GregorianYear operator +(dynamic other) => (super + other) as GregorianYear;
    @override GregorianYear operator -(dynamic other) => (super - other) as GregorianYear;
}