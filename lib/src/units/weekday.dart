
import 'package:clockwork/clockwork.dart';

enum Weekday {
    skip,
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
}

enum WeekdayISO {
    skip,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}

extension WeekdayExtension on Weekday {
    operator <(Weekday other) => this.index < other.index;
    operator <=(Weekday other) => this.index <= other.index;
    operator >(Weekday other) => this.index > other.index;
    operator >=(Weekday other) => this.index >= other.index;

    Weekday operator +(Weekday other) {
        if (other == Weekday.skip) throw InvalidArgumentException('other');
        final index = (this.index + other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 1 : index];
    }

    Weekday operator -(Weekday other) {
        if (other == Weekday.skip) throw InvalidArgumentException('other');
        final index = (this.index - other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 7 : index];
    }

    /// Returns the ISO expression of the same weekday.
    WeekdayISO toISO() {
        if (this == Weekday.skip) return WeekdayISO.skip;
        else if (this == Weekday.Sunday) return WeekdayISO.Sunday;
        else return WeekdayISO.values[this.index - 1];
    }

    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.abbreviated[this.index - 1];
    /// Returns the locale-sensitive narrow name of the weekday.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.narrow[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.wide[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.short?.elementAt(this.index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.abbreviated[this.index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the weekday.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.narrow[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.wide[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.short?.elementAt(this.index - 1);
}

extension WeekdayISOExtension on WeekdayISO {
    operator <(WeekdayISO other) => this.index < other.index;
    operator <=(WeekdayISO other) => this.index <= other.index;
    operator >(WeekdayISO other) => this.index > other.index;
    operator >=(WeekdayISO other) => this.index >= other.index;

    WeekdayISO operator +(WeekdayISO other) {
        if (other == WeekdayISO.skip) throw InvalidArgumentException('other');
        final index = (this.index + other.index) % 7;
        return WeekdayISO.values[index == WeekdayISO.skip ? 1 : index];
    }

    WeekdayISO operator -(WeekdayISO other) {
        if (other == WeekdayISO.skip) throw InvalidArgumentException('other');
        final index = (this.index - other.index) % 7;
        return WeekdayISO.values[index == WeekdayISO.skip ? 7 : index];
    }

    /// Returns the default [Weekday] representation, where the week starts on Sunday.
    Weekday toDefault() {
        if (this == WeekdayISO.skip) return Weekday.skip;
        else if (this == WeekdayISO.Sunday) return Weekday.Sunday;
        else return Weekday.values[this.index + 1];
    }

    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.abbreviated[this.toDefault().index - 1];
    /// Returns the locale-sensitive narrow name of the weekday.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.narrow[this.toDefault().index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.wide[this.toDefault().index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.short?.elementAt(this.toDefault().index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.abbreviated[this.toDefault().index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the weekday.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.narrow[this.toDefault().index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.wide[this.toDefault().index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.short?.elementAt(this.toDefault().index - 1);
}