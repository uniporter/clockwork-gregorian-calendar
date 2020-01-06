
import 'package:clockwork/clockwork.dart';

class GregorianWeekday extends Weekday {
    GregorianWeekday(int value): super(value);

    static final Sunday = GregorianWeekday(1);
    static final Monday = GregorianWeekday(2);
    static final Tuesday = GregorianWeekday(3);
    static final Wednesday = GregorianWeekday(4);
    static final Thursday = GregorianWeekday(5);
    static final Friday = GregorianWeekday(6);
    static final Saturday = GregorianWeekday(7);

    @override GregorianWeekday operator +(dynamic other) => (super + other) as GregorianWeekday;
    @override GregorianWeekday operator -(dynamic other) => (super - other) as GregorianWeekday;

    @override String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.abbreviated[this() - 1];
    @override String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.narrow[this() - 1];
    @override String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.wide[this() - 1];
    @override String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.short?.elementAt(this() - 1);
    @override String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.abbreviated[this() - 1];
    @override String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.narrow[this() - 1];
    @override String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.wide[this() - 1];
    @override String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.short?.elementAt(this() - 1);
}