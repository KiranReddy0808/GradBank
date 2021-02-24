import 'package:flutter/foundation.dart';

class Payments {
  int amount_;
  String category_;
  int date_;
  int month_;
  int year_;

  Payments(
      {@required this.amount_,
      @required this.category_,
      @required this.date_,
      @required this.month_,
      @required this.year_});
}

class recentPayments {
  int amount_;
  int day_;

  recentPayments({@required this.amount_, @required this.day_});
}

class catPayments {
  int amount_;
  String category_;

  catPayments({@required this.amount_, @required this.category_});
}

class limits {
  int m_limit;
  int y_limit;

  limits({
    @required this.m_limit,
    @required this.y_limit,
  });
}
