import 'package:clockwork/clockwork.dart';

class GregorianYearOfEra extends Year {
    final range = Range(1, double.infinity);

    GregorianYearOfEra(int value): super(value);

    @override GregorianYearOfEra operator +(dynamic other) => (super + other) as GregorianYearOfEra;
    @override GregorianYearOfEra operator -(dynamic other) => (super - other) as GregorianYearOfEra;
}