class MonthlyExpenseModel {
  final String date; // Example: July-2026 or 07-2026
  final num income;
  final num expense;

  MonthlyExpenseModel({
    required this.date,
    required this.income,
    required this.expense,
  });

  factory MonthlyExpenseModel.fromMap(Map<dynamic, dynamic> map) {
    return MonthlyExpenseModel(
      date: map['date'] ?? '',
      income: map['income'] ?? 0,
      expense: map['expense'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'income': income, 'expense': expense};
  }

  MonthlyExpenseModel copyWith({String? date, num? income, num? expense}) {
    return MonthlyExpenseModel(
      date: date ?? this.date,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }
}
