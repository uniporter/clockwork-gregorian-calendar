import 'package:clockwork/clockwork.dart';

class GregorianYear extends Year {
    GregorianYear(int value): super(value);

    /// Returns whether [year] is a leap year.
    static isLeapYear(GregorianYear year) => year() % 4 == 0 && (year() % 100 != 0 || year() % 400 == 0);

    static const monthsPer = 12;
    static daysPer(GregorianYear year) => isLeapYear(year) ? 366 : 365;
    static hoursPer(GregorianYear year) => daysPer(year) * Day.hoursPer;
    static minutesPer(GregorianYear year) => daysPer(year) * Day.minutesPer;
    static secondsPer(GregorianYear year) => daysPer(year) * Day.secondsPer;
    static millisecondsPer(GregorianYear year) => daysPer(year) * Day.millisecondsPer;
    static microsecondsPer(GregorianYear year) => daysPer(year) * Day.microsecondsPer;

    @override GregorianYear operator +(dynamic other) => (super + other) as GregorianYear;
    @override GregorianYear operator -(dynamic other) => (super - other) as GregorianYear;
}