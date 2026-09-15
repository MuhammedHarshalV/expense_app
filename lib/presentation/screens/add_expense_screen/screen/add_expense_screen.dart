import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/common_widgets/title_field.dart';
import 'package:expense/presentation/screens/add_expense_screen/widget/amount_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseScreen extends ConsumerWidget {
  const AddExpenseScreen({super.key});

  // Theme Colors matching the image
  static const Color primaryBlue = Color(0xFF003399);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.black45,
        backgroundColor: const Color(0xFF1A2980),

        title: Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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

        actions: const [ProfileIcon()],

        // Gradient background
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldLabel(label: 'EXPENSE AMOUNT', isRequired: true),
                    const SizedBox(height: 6),
                    AmountCard(),
                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      'EXPENSE CATEGORY',
                      isRequired: true,
                      trailing: 'Select 1',
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryGrid(),
                    const SizedBox(height: 24),

                    _buildDateSection(),
                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      'RECEIPT ATTACHMENT',
                      trailing: '(Optional)',
                    ),
                    const SizedBox(height: 12),
                    _buildAttachmentSection(),
                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      'PURPOSE / NOTES',
                      trailing: '(Optional)',
                    ),
                    const SizedBox(height: 12),
                    _buildNotesSection(),
                    const SizedBox(height: 24),

                    _buildSpeedPolicyBanner(),
                    const SizedBox(height: 24),

                    _buildSubmitButtons(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildCategoryCard(
          Icons.local_gas_station_outlined,
          'Fuel / Travel',
          'Petrol, cabs & transit',
          isSelected: true,
        ),
        _buildCategoryCard(
          Icons.restaurant_outlined,
          'Food & Lunch',
          'Client dining & tea',
        ),
        _buildCategoryCard(
          Icons.science_outlined,
          'Medical Demo',
          'Trial kits & supplies',
        ),
        _buildCategoryCard(
          Icons.bed_outlined,
          'Hotel / Stay',
          'Lodging & room',
        ),
        _buildCategoryCard(
          Icons.print_outlined,
          'Stationery',
          'Brochures & forms',
        ),
        _buildCategoryCard(
          Icons.more_horiz,
          'Other Expense',
          'Courier, toll & misc',
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    IconData icon,
    String title,
    String subtitle, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? primaryBlue : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? primaryBlue : borderColor),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : primaryBlue,
                  size: 18,
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 18,
                ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white70 : textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FieldLabel(label: 'DATE OF EXPENSE', isRequired: true),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'Yesterday',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.calendar_today_outlined, size: 18, color: primaryBlue),
              SizedBox(width: 12),
              Text(
                'Today, 24 Oct 2024',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              Spacer(),
              Icon(Icons.edit_calendar_outlined, size: 18, color: textMuted),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAttachmentButton(
                Icons.camera_alt_outlined,
                'Take Photo',
                'Instant scan',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttachmentButton(
                Icons.receipt_long_outlined,
                'Upload File',
                'PDF, PNG, JPG',
                isTeal: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.verified_outlined, size: 16, color: primaryBlue),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Attach physical bill or fuel slip for immediate verification',
                style: TextStyle(fontSize: 11, color: textMuted, height: 1.4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentButton(
    IconData icon,
    String title,
    String subtitle, {
    bool isTeal = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isTeal ? const Color(0xFFE0F2FE) : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isTeal ? const Color(0xFF0284C7) : primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'e.g., Petrol top-up for 3 clinic follow-ups in Ernakulam district...',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTagChip('+ Client Meeting'),
            _buildTagChip('+ Refuel'),
            _buildTagChip('+ Emergency Demo'),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedPolicyBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.shield_outlined, color: Color(0xFF166534), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Speed Policy: Claims under ₹2,000 for registered partner clinics are automatically settled within 24 working hours.',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF166534),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Save & Submit Expense',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save as Draft',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- HELPERS ---

  Widget _buildSectionHeader(
    String title, {
    bool isRequired = false,
    String? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textDark,
              letterSpacing: 0.5,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
      ],
    );
  }

  Widget _buildAmountChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),
    );
  }

  Widget _buildTagChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
      ),
    );
  }
}
