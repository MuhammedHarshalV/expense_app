import 'dart:async';
import 'dart:developer';

import 'package:expense/apis/expense_related_api/get_expense_history_api.dart';
import 'package:expense/controller/history_screen_controller/history_screen_state.dart';
import 'package:expense/models/expense_related/get_expense_history_response_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class ExpenseHistoryController extends StateNotifier<ExpenseHistoryState> {
  ExpenseHistoryController() : super(ExpenseHistoryState()) {
    getExpenseHistory(isInitial: true);
  }
  final searchController = TextEditingController();
  Timer? _debounce;

  // dd-MMM-yyyy
  final DateFormat _dateFormat = DateFormat('dd-MMM-yyyy');

  // -------------------------------
  // SEARCH
  // -------------------------------

  void onSearchChanged(String value) {
    _debounce?.cancel();
    state = state.copyWith(searchText: value);
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      getExpenseHistory(isSearch: true);
    });
  }

  // -------------------------------
  // START DATE
  // -------------------------------

  Future<void> pickStartDate(BuildContext context) async {
    final now = DateTime.now();

    DateTime initialDate;

    try {
      initialDate = _dateFormat.parse(state.startDate);
    } catch (_) {
      initialDate = now.subtract(const Duration(days: 30));
    }

    final pickedDate = await showDatePicker(
      helpText: 'Select Start Date',
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (!mounted) return;

    if (pickedDate == null) return;

    final formattedDate = _dateFormat.format(pickedDate);

    state = state.copyWith(startDate: formattedDate);

    if (!mounted || !context.mounted) return;

    // Immediately open End Date picker
    await pickEndDate(context);
  }

  // -------------------------------
  // END DATE
  // -------------------------------
  Future<void> pickEndDate(BuildContext context) async {
    final now = DateTime.now();
    if (!mounted) return;
    DateTime startDate;

    try {
      startDate = _dateFormat.parse(state.startDate);
    } catch (_) {
      startDate = now.subtract(const Duration(days: 30));
    }

    DateTime initialDate;

    try {
      initialDate = _dateFormat.parse(state.endDate);
    } catch (_) {
      initialDate = now;
    }

    // Existing end date could be before newly selected start date
    if (initialDate.isBefore(startDate)) {
      initialDate = startDate;
    }

    final pickedDate = await showDatePicker(
      helpText: 'Select End Date',
      context: context,
      initialDate: initialDate,
      firstDate: startDate,
      lastDate: now,
    );
    if (!mounted) return;
    if (pickedDate == null) return;

    state = state.copyWith(endDate: _dateFormat.format(pickedDate));
    if (!mounted) return;
    await getExpenseHistory(isSearch: true);
  }

  // -------------------------------
  // CLEAR DATE FILTER
  // -------------------------------

  Future<void> clearDateFilter() async {
    state = state.copyWith(startDate: '', endDate: '');

    await getExpenseHistory(isSearch: true);
  }

  //filter change

  final List<String> expenseFilters = [
    'latest',
    'oldest',
    'largest',
    'smallest',
  ];
  Future<void> changeFilter(int index) async {
    if (index < 0 || index >= expenseFilters.length) return;

    if (state.filterIndex == index) return;

    state = state.copyWith(filterIndex: index);

    await getExpenseHistory(isSearch: true);
  }

  // -------------------------------
  // CLEAR SEARCH
  // -------------------------------

  Future<void> clearSearch() async {
    _debounce?.cancel();

    state = state.copyWith(searchText: '');

    await getExpenseHistory(isSearch: true);
  }

  Future<void> getExpenseHistory({
    bool isInitial = false,
    bool isPagination = false,
    bool isSearch = false,
  }) async {
    final search = state.searchText.trim();

    final startDate = state.startDate;

    final endDate = state.endDate;
    final filter = expenseFilters[state.filterIndex];

    log('Search: $search');
    log('Start Date: $startDate');
    log('End Date: $endDate');
    log('Filter: $filter');
    // Prevent duplicate API calls
    if (state.isLoading || state.isSearchLoading || state.isPaginationLoading) {
      return;
    }

    // -----------------------------
    // Decide page number
    // -----------------------------

    final int requestedPage;

    if (isPagination) {
      if (state.pageNumber >= state.totalPages) {
        return;
      }

      requestedPage = state.pageNumber + 1;
    } else {
      requestedPage = 1;
    }

    // -----------------------------
    // Loading
    // -----------------------------

    if (isInitial) {
      state = state.copyWith(isLoading: true);
    } else if (isPagination) {
      state = state.copyWith(isPaginationLoading: true);
    } else if (isSearch) {
      state = state.copyWith(isSearchLoading: true);
    }

    try {
      final GetExpenseHistoryResponseModel? response =
          await GetExpenseHistoryApi.getExpenseHistoryApi(
            search: search,
            startDate: startDate,
            endDate: endDate,
            filter: filter,
            pageNumber: requestedPage,
            limit: 10,
          );

      if (response == null) return;

      final newList = response.data ?? [];

      // -----------------------------
      // Pagination list handling
      // -----------------------------

      final updatedList = isPagination
          ? [...state.expenseHistory, ...newList]
          : newList;

      // -----------------------------
      // Assign API values to state
      // -----------------------------

      state = state.copyWith(
        expenseHistory: updatedList,

        pageNumber: response.page ?? requestedPage,

        totalPages: response.totalPages ?? 0,

        totalCount: response.totalCount ?? 0,
        totalSpend: response.totalSpend ?? 0,
        approvedAmount: response.approvedAmount ?? 0,
      );

      log('spend amount ${response.totalSpend}');
      log('state is ${state.totalSpend}');
    } catch (e) {
      log('Expense history error: $e');
    } finally {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          isSearchLoading: false,
          isPaginationLoading: false,
        );
      }
    }
  }

  // --------------------------------
  // DATE FILTER
  // --------------------------------

  Future<void> applyDateFilter({String? startDate, String? endDate}) async {
    await getExpenseHistory(isSearch: true);
  }

  // --------------------------------
  // CLEAR FILTER
  // --------------------------------

  // Future<void> clearFilter() async {
  //   _search = '';
  //   _startDate = null;
  //   _endDate = null;

  //   await getExpenseHistory(isSearch: true);
  // }

  // --------------------------------
  // PAGINATION
  // --------------------------------

  Future<void> loadMore() async {
    if (state.pageNumber >= state.totalPages) {
      return;
    }

    await getExpenseHistory(isPagination: true);
  }

  // --------------------------------
  // REFRESH
  // --------------------------------

  Future<void> refresh() async {
    await getExpenseHistory(isInitial: true);
  }

  @override
  void dispose() {
    log('===== expense history screen disposed =====');

    _debounce?.cancel();

    super.dispose();
  }
}

final expenseHistoryProvider =
    StateNotifierProvider<ExpenseHistoryController, ExpenseHistoryState>((ref) {
      return ExpenseHistoryController();
    });
