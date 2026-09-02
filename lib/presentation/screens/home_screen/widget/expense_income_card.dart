
import 'package:expense/controller/create_expense_controller/create_expense_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/constants/icon_constants.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/screens/create_screen/screen/create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseIncomeCards extends ConsumerWidget {
  final int index;
  const ExpenseIncomeCards({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeController = ref.read(homeProvider.notifier);
    final createController = ref.read(createExpensePrrovider.notifier);

    return Container(
      // margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        //color: index % 2 == 0 ? AppColors.appGreen : Colors.red,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: homeState.expenseList[index].transactionType == 'Income'
              ? AppColors.appGreen
              : Colors.red,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      homeState.expenseList[index].transactionType == 'Income'
                      ? AppColors.appGreen.withValues(alpha: .5)
                      : AppColors.appRed.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  homeState.expenseList[index].transactionType == 'Income'
                      ? CategoryIcons.income[homeState
                            .expenseList[index]
                            .category]
                      : CategoryIcons.expense[homeState
                            .expenseList[index]
                            .category],
                  color: AppColors.appBlack,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeState.expenseList[index].category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      homeState.expenseList[index].description,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                homeState.expenseList[index].transactionType == 'Income'
                    ? "+ ${homeState.expenseList[index].amount.toString()}"
                    : "- ${homeState.expenseList[index].amount.toString()}",
                style: TextStyle(
                  color:
                      homeState.expenseList[index].transactionType == 'Income'
                      ? AppColors.appGreen
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          _DashedDivider(),
          const SizedBox(height: 15),
          // 2. BOTTOM ROW: Action Buttons (Priority, Edit, Delete)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (homeState.expenseList[index].transactionType == 'Expense')
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amberAccent),
                    Icon(
                      (homeState.expenseList[index].priority == 'Medium' ||
                              homeState.expenseList[index].priority == 'High')
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amberAccent,
                    ),
                    Icon(
                      homeState.expenseList[index].priority == 'High'
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amberAccent,
                    ),
                    Text(
                      'Priority',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              if (homeState.expenseList[index].createdAt ==
                  DateFormat('dd-MM-yyyy').format(DateTime.now()))
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewTransactionScreen(index: index),
                      ),
                    );
                    createController.updateState(
                      amount: homeState.expenseList[index].amount,
                      transactionType:
                          homeState.expenseList[index].transactionType,
                      category: homeState.expenseList[index].category,
                      priority: homeState.expenseList[index].priority,
                      desc: homeState.expenseList[index].description,
                    );
                  },
                  child: SizedBox(
                    child: Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (homeState.expenseList[index].createdAt ==
                  DateFormat('dd-MM-yyyy').format(DateTime.now()))
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,

                  onTap: () async {
                    await homeController.deleteExpense(index);
                  },
                  child: SizedBox(
                    child: Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends ConsumerWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / 8).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: 4,
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurface,
            );
          }),
        );
      },
    );
  }
}
