class ExpenseHiveModel {
  final String transactionType; // Expense / Income
  final String category;
  final String priority; // Low / Medium / High
  final String description;
  final num amount;

  final String createdAt;

  ExpenseHiveModel({
    required this.transactionType,
    required this.category,
    required this.priority,
    required this.description,
    required this.amount,
    required this.createdAt,
  });

  factory ExpenseHiveModel.fromMap(Map<dynamic, dynamic> map) {
    return ExpenseHiveModel(
      transactionType: map['transactionType'] ?? '',
      category: map['category'] ?? '',
      priority: map['priority'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0),
      createdAt: (map['createdAt'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionType': transactionType,
      'category': category,
      'priority': priority,
      'description': description,
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  ExpenseHiveModel copyWith({
    String? transactionType,
    String? category,
    String? priority,
    String? description,
    num? amount,
    String? createdAt,
  }) {
    return ExpenseHiveModel(
      transactionType: transactionType ?? this.transactionType,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
