import 'package:expense/controller/create_expense_controller/create_expense_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/create_screen/widget/name_enter_card.dart';
import 'package:expense/presentation/screens/create_screen/widget/expense_add_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTransactionScreen extends ConsumerWidget {
  final int? index;
  const NewTransactionScreen({super.key, this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createExpenseController = ref.read(createExpensePrrovider.notifier);
    final createExpenseState = ref.watch(createExpensePrrovider);

    final homeController = ref.read(homeProvider.notifier);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            snap: false,
            // Snaps into full view when scrolling up
            elevation: 4,
            shadowColor: Colors.black45,
            expandedHeight: 70.0, // Slightly taller for a premium feel
            backgroundColor:
                Colors.transparent, // Required to show the gradient
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A2980), // Deep stylish blue
                    Color(0xFF26D0CE), // Vibrant teal
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            title: Row(
              children: [
                InkWell(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: GlassContainer(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(360),
                    border: Border.all(color: AppColors.appWhite),
                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: AppColors.appWhite,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'FinanceTrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [ProfileIcon()],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  NameEnterCard(),
                  SizedBox(height: 20),
                  ExpenseAddCard(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: GlassContainer(
          height: 50,
          child: createExpenseState.isSubmit == true
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),

                  label: Text(
                    index != null ? 'Update Entry' : 'Save Entry',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ),
    );
  }
}
