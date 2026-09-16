import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseCategoryGrid extends ConsumerWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const ExpenseCategoryGrid({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      CategoryItem(
        icon: Icons.restaurant_outlined,
        title: 'Food & Lunch',
        subtitle: 'Client dining & tea',
      ),
      CategoryItem(
        icon: Icons.local_gas_station_outlined,
        title: 'Fuel / Travel',
        subtitle: 'Petrol, cabs & transit',
      ),
      CategoryItem(
        icon: Icons.science_outlined,
        title: 'Medical Demo',
        subtitle: 'Trial kits & supplies',
      ),
      CategoryItem(
        icon: Icons.bed_outlined,
        title: 'Hotel / Stay',
        subtitle: 'Lodging & room',
      ),
      CategoryItem(
        icon: Icons.print_outlined,
        title: 'Stationery',
        subtitle: 'Brochures & forms',
      ),
      CategoryItem(
        icon: Icons.more_horiz,
        title: 'Other Expense',
        subtitle: 'Courier, toll & misc',
      ),
    ];

    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return _CategoryCard(
          icon: category.icon,
          title: category.title,
          subtitle: category.subtitle,
          isSelected: selectedCategory == category.title,
          onTap: () {
            onCategorySelected(category.title);
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.appWhite.withValues(alpha: 0.2)
                        : colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.appWhite
                        : colorScheme.primary,
                    size: 18.sp,
                  ),
                ),

                if (isSelected)
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.appWhite,
                    size: 18.sp,
                  ),
              ],
            ),

            const Spacer(),

            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.appWhite : colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                color: isSelected
                    ? Colors.white70
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const CategoryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
