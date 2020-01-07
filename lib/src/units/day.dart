import 'package:clockwork/clockwork.dart';
import 'package:clockwork_gregorian_calendar/src/units/year.dart';

class GregorianDay extends Day {
    GregorianDay(int value, GregorianMonth month, GregorianYear year) : super(value, Range(1, GregorianMonth.daysPer(month, year), false));

    static const hoursPer = 60;
    static const minutesPer = hoursPer * Hour.minutesPer;
    static const secondsPer = hoursPer * Hour.secondsPer;
    static const millisecondsPer = hoursPer * Hour.millisecondsPer;
    static const microsecondsPer = hoursPer * Hour.microsecondsPer;

    @override GregorianDay operator +(dynamic other) => (super + other) as GregorianDay;
    @override GregorianDay operator -(dynamic other) => (super - other) as GregorianDay;
}

class GregorianDayOfYear extends Day {
    GregorianDayOfYear(int value, GregorianYear year): super(value, Range(1, GregorianYear.isLeapYear(year) ? 366 : 365));

    @override GregorianDayOfYear operator +(dynamic other) => (super + other) as GregorianDayOfYear;
    @override GregorianDayOfYear operator -(dynamic other) => (super - other) as GregorianDayOfYear;
}