import 'package:expense/models/expense_related/get_expense_history_response_model.dart';
import 'package:intl/intl.dart';

class ExpenseHistoryState {
  final List<ExpenseHistory> expenseHistory;

  final bool isLoading;
  final bool isSearchLoading;
  final bool isPaginationLoading;

  final num totalSpend;
  final num approvedAmount;
  final int pageNumber;
  final int limit;
  final int totalPages;
  final int totalCount;
  final int filterIndex;

  final String startDate;
  final String endDate;
  final String searchText;
  ExpenseHistoryState({
    this.expenseHistory = const [],
    this.isLoading = false,
    this.filterIndex = 0,
    this.isSearchLoading = false,
    this.isPaginationLoading = false,
    this.pageNumber = 0,
    this.limit = 0,
    this.totalPages = 0,
    this.totalCount = 0,
    String? startDate,
    this.searchText = '',
    String? endDate,
    this.totalSpend = 0,
    this.approvedAmount = 0,
  }) : startDate =
           startDate ??
           DateFormat(
             'dd-MMM-yyyy',
           ).format(DateTime.now().subtract(const Duration(days: 30))),
       endDate = endDate ?? DateFormat('dd-MMM-yyyy').format(DateTime.now());

  ExpenseHistoryState copyWith({
    List<ExpenseHistory>? expenseHistory,
    bool? isLoading,
    bool? isSearchLoading,
    bool? isPaginationLoading,
    int? pageNumber,
    int? limit,
    int? filterIndex,
    String? searchText,
    int? totalPages,
    int? totalCount,
    String? startDate,
    String? endDate,
    num? totalSpend,
    num? approvedAmount,
  }) {
    return ExpenseHistoryState(
      expenseHistory: expenseHistory ?? this.expenseHistory,
      isLoading: isLoading ?? this.isLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      pageNumber: pageNumber ?? this.pageNumber,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchText: searchText ?? this.searchText,
      totalSpend: totalSpend ?? this.totalSpend,
      filterIndex: filterIndex ?? this.filterIndex,
      approvedAmount: approvedAmount ?? this.approvedAmount,
    );
  }
}
