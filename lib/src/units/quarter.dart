import 'package:clockwork/clockwork.dart';

enum Quarter {
    skip,
    Spring,
    Summer,
    Fall,
    Winter,
}

extension QuarterExtension on Quarter {
    /// Returns the locale-sensitive abbreviated name of the month.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.abbreviated[this.index - 1];
    /// Returns the locale-sensitive narrow name of the month.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.narrow[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.wide[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.short?.elementAt(this.index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.abbreviated[this.index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the month.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.narrow[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.wide[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.short?.elementAt(this.index - 1);
}