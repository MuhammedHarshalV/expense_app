import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/common_appbar.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Colors
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryBlue = isDark
        ? const Color(0xFF3B82F6)
        : const Color(0xFF003399);
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(
                      isDark,
                      surfaceColor,
                      borderColor,
                      textMuted,
                      textPrimary,
                    ),
                    const SizedBox(height: 16),

                    _buildPeriodSelector(
                      isDark,
                      surfaceColor,
                      borderColor,
                      textPrimary,
                      textMuted,
                    ),
                    const SizedBox(height: 16),

                    _buildFilterChips(primaryBlue),
                    const SizedBox(height: 20),

                    _buildSummaryCard(
                      isDark,
                      surfaceColor,
                      borderColor,
                      primaryBlue,
                      textPrimary,
                      textMuted,
                    ),
                    const SizedBox(height: 24),

                    _buildSectionHeader(textPrimary, textMuted),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  FacilityBreakdownCard(
                    isDark: isDark,
                    icon: Icons.local_hospital_outlined,
                    name: 'Medical Trust 2',
                    location: 'Ernakulam, Kerala',
                    claimsCount: '6 Claims',
                    badgeText: 'Active',
                    badgeColor: const Color(0xFF06B6D4),
                    totalSpend: '₹4,850',
                    approved: '₹3,650',
                    statusPillText: '₹1,200 Under Review',
                    statusPillColor: const Color(0xFFF59E0B),
                  ),
                  FacilityBreakdownCard(
                    isDark: isDark,
                    icon: Icons.business_outlined,
                    name: 'Metropolitan Health Plaza',
                    location: 'Seattle, WA / Reg',
                    claimsCount: '4 Claims',
                    badgeText: 'Active',
                    badgeColor: const Color(0xFF06B6D4),
                    totalSpend: '₹12,400',
                    approved: '₹12,400',
                    statusPillText: '100% Settled',
                    statusPillColor: primaryBlue,
                    isSettled: true,
                  ),
                  FacilityBreakdownCard(
                    isDark: isDark,
                    icon: Icons.local_shipping_outlined,
                    name: 'Nayara Fleet & Logistics',
                    location: 'Malappuram',
                    claimsCount: '2 Claims',
                    badgeText: 'Logistics',
                    badgeColor: textMuted,
                    totalSpend: '₹7,850',
                    approved: '₹5,200',
                    statusPillText: '₹2,650 Pending Review',
                    statusPillColor: const Color(0xFFF59E0B),
                  ),
                  FacilityBreakdownCard(
                    isDark: isDark,
                    icon: Icons.ac_unit_outlined,
                    name: 'Lakeshore Super Specialty',
                    location: 'Kochi, Kerala',
                    claimsCount: '2 Claims',
                    badgeText: 'Active',
                    badgeColor: const Color(0xFF06B6D4),
                    totalSpend: '₹3,350',
                    approved: '₹2,350',
                    statusPillText: '₹1,000 In Process',
                    statusPillColor: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textMuted,
    Color textPrimary,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        style: TextStyle(color: textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search clinic names (e.g. Medical Trust)..',
          hintStyle: TextStyle(color: textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 18, color: textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color(0xFF003399),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERIOD',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '01 Oct 2024 - 31 Oct 2024',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  '30 Days',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 14, color: textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(Color primaryBlue) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            'All Facilities',
            isActive: true,
            primaryBlue: primaryBlue,
          ),
          const SizedBox(width: 8),
          _buildChip(
            'Approved Only',
            isActive: false,
            primaryBlue: primaryBlue,
          ),
          const SizedBox(width: 8),
          _buildChip(
            'Pending Review',
            isActive: false,
            primaryBlue: primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    String label, {
    required bool isActive,
    required Color primaryBlue,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? primaryBlue : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? Colors.white : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryBlue,
    Color textPrimary,
    Color textMuted,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: primaryBlue),
                      const SizedBox(width: 6),
                      Text(
                        'Oct 2024 - 14 Claims Total',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Updated 2h ago',
                  style: TextStyle(fontSize: 10, color: textMuted),
                ),
              ],
            ),
          ),

          // Metrics Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Spend',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹28,450',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '14 log entries',
                        style: TextStyle(fontSize: 10, color: textMuted),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Approved',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textMuted,
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: primaryBlue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹23,600',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '83% reimbursed',
                          style: TextStyle(fontSize: 10, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pending Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.pending_actions,
                      size: 14,
                      color: Color(0xFFC2410C),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Under Review / Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
                const Text(
                  '₹4,850',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC2410C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settlement Clearance Rate',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                    Text(
                      '83%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.83,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(Color textPrimary, Color textMuted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Breakdown by Facility',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        Text(
          '4 Locations',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textMuted,
          ),
        ),
      ],
    );
  }
}

// --- REUSABLE FACILITY CARD WIDGET ---

class FacilityBreakdownCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String name;
  final String location;
  final String claimsCount;
  final String badgeText;
  final Color badgeColor;
  final String totalSpend;
  final String approved;
  final String statusPillText;
  final Color statusPillColor;
  final bool isSettled;

  const FacilityBreakdownCard({
    super.key,
    required this.isDark,
    required this.icon,
    required this.name,
    required this.location,
    required this.claimsCount,
    required this.badgeText,
    required this.badgeColor,
    required this.totalSpend,
    required this.approved,
    required this.statusPillText,
    required this.statusPillColor,
    this.isSettled = false,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final primaryBlue = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF003399);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          // Header: Icon, Name, Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(icon, size: 20, color: primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$location • $claimsCount',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Spend & Approved Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spend',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalSpend,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Approved',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    approved,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Footer: Status Pill & View Receipts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSettled
                      ? primaryBlue.withOpacity(0.1)
                      : statusPillColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (isSettled) ...[
                      Icon(Icons.check, size: 12, color: primaryBlue),
                      const SizedBox(width: 4),
                    ] else ...[
                      Icon(Icons.circle, size: 6, color: statusPillColor),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      statusPillText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSettled ? primaryBlue : statusPillColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'View ${claimsCount.split(' ')[0]} Receipts',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: primaryBlue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
