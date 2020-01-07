import 'package:clockwork/clockwork.dart';

class GregorianWeekOfYear extends Week {
    GregorianWeekOfYear(int value, GregorianYear year): super(value, Range(1, GregorianYear.weeksPer(year)));

    @override GregorianWeekOfYear operator +(dynamic other) => (super + other) as GregorianWeekOfYear;
    @override GregorianWeekOfYear operator -(dynamic other) => (super - other) as GregorianWeekOfYear;
}

class GregorianWeekOfMonth extends Week {
    GregorianWeekOfMonth(int value, GregorianMonth month, GregorianYear year): super(value, Range(1, GregorianMonth.weeksPer(month, year)));

    @override GregorianWeekOfMonth operator +(dynamic other) => (super + other) as GregorianWeekOfMonth;
    @override GregorianWeekOfMonth operator -(dynamic other) => (super - other) as GregorianWeekOfMonth;
}