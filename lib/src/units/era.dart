import 'package:clockwork/clockwork.dart';

enum Era {
    AD, BC
}

extension EraExtension on Era {
    /// Returns the locale-sensitive name of the era.
    String toName([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.name.pre : nonNullLocale(locale).gregorianCalendar.eras.name.post;
    /// Returns the locale-sensitive abbreviation of the era.
    String toAbbr([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.abbr.pre : nonNullLocale(locale).gregorianCalendar.eras.abbr.post;
    /// Returns the locale-sensitive narrow name of the era.
    String toNarrow([Locale? locale]) => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.narrow.pre : nonNullLocale(locale).gregorianCalendar.eras.narrow.post;

    /// Returns the alternative locale-sensitive name of the era.
    String toNameAlt([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.name.preAlt : nonNullLocale(locale).gregorianCalendar.eras.name.postAlt;
    /// Returns the alternative locale-sensitive abbreviation of the era.
    String toAbbrAlt([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.abbr.preAlt : nonNullLocale(locale).gregorianCalendar.eras.abbr.postAlt;
    /// Returns the alternative locale-sensitive narrow name of the era.
    String toNarrowAlt([Locale? locale]) => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.narrow.preAlt : nonNullLocale(locale).gregorianCalendar.eras.narrow.postAlt;
}
