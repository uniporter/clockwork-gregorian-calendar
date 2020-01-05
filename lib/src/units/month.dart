import 'package:clockwork/clockwork.dart';

enum Month {
    skip,
    January,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December,
}

extension MonthExtension on Month {
    bool operator <(Month other) => this.index < other.index;
    bool operator <=(Month other) => this.index <= other.index;
    bool operator >(Month other) => this.index > other.index;
    bool operator >=(Month other) => this.index >= other.index;

    Month operator +(Month other) {
        if (other == Month.skip) throw InvalidArgumentException('other');
        final index = (this.index + other.index) % 12;
        return Month.values[index == Month.skip ? 1 : index];
    }

    Month operator -(Month other) {
        if (other == Month.skip) throw InvalidArgumentException('other');
        final index = (this.index - other.index) % 12;
        return Month.values[index == Month.skip ? 12 : index];
    }

    /// Returns the locale-sensitive abbreviated name of the month.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.abbreviated[this.index - 1];
    /// Returns the locale-sensitive narrow name of the month.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.narrow[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.wide[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.short?.elementAt(this.index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.abbreviated[this.index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the month.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.narrow[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.wide[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.short?.elementAt(this.index - 1);
}