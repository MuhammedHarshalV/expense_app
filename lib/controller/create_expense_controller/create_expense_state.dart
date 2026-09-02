class CreateExpenseState {
  final String transactionType;
  final String category;
  final String description;
  final String priority;
  final bool isSubmit;
  final num amount;

  const CreateExpenseState({
    this.transactionType = '',
    this.category = '',
    this.description = '',
    this.isSubmit = false,
    this.priority = '',
    this.amount = 0,
  });

  CreateExpenseState copyWith({
    String? transactionType,
    String? category,
    String? description,
    bool? isSubmit,
    String? priority,
    num? amount,
  }) {
    return CreateExpenseState(
      transactionType: transactionType ?? this.transactionType,
      category: category ?? this.category,
      description: description ?? this.description,
      isSubmit: isSubmit ?? this.isSubmit,
      priority: priority ?? this.priority,
      amount: amount ?? this.amount,
    );
  }
}
