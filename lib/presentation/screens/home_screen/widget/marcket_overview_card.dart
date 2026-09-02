import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/services/net_work_services/connection_checking.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class AnimattedSensexCard extends ConsumerStatefulWidget {
  const AnimattedSensexCard({super.key});

  @override
  ConsumerState<AnimattedSensexCard> createState() =>
      _AnimattedSensexCardState();
}

class _AnimattedSensexCardState extends ConsumerState<AnimattedSensexCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = ref.read(homeProvider.notifier);
    final homeState = ref.watch(homeProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // 2. This container draws the rotating gradient background
            return Container(
              padding: const EdgeInsets.all(3), // This acts as the border width
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  transform: GradientRotation(_controller.value * 2 * math.pi),
                  colors: [
                    const Color.fromARGB(255, 255, 59, 167),
                    const Color.fromARGB(255, 59, 72, 255),
                    const Color.fromARGB(255, 255, 59, 167),
                    Colors.white,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
              child: child, // The white inner card
            );
          },
          // 3. The inner card containing your original UI
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,

              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // Row 1: Sensex & Nifty 50
                Row(
                  children: [
                    Expanded(
                      child: _buildDataTile(
                        context,
                        title: 'SENSEX',
                        value: homeState.sensex
                            .toString(), // Replace with dynamic data
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDataTile(
                        context,
                        title: 'NIFTY 50',
                        value: homeState.nifty
                            .toString(), // Replace with dynamic data
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Row 2: Gold & Silver Prices
                Row(
                  children: [
                    Expanded(
                      child: _buildDataTile(
                        context,
                        title: 'GOLD (1g)',
                        value:
                            "\$ ${homeState.gold.toString()}", // Replace with dynamic data
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDataTile(
                        context,
                        title: 'SILVER (1kg)',
                        value: homeState.silver
                            .toString(), // Replace with dynamic data
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      bool connect = await InternetChecker.hasConnection();
                      if (connect == true) {
                        await homeController.fetchSensex();
                      } else {
                        // ignore: use_build_context_synchronously
                        AppMessage.show(context, 'No Network connection');
                      }
                    },
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withValues(alpha: .35),
                      blur: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          homeState.isSensex == true
                              ? SizedBox.shrink()
                              : Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.green,
                                  size: 18,
                                ),
                          homeState.isSensex == true
                              ? SizedBox.shrink()
                              : SizedBox(width: 8),
                          homeState.isSensex == true
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.appGreen,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Refresh",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Row 3: Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavButton(
                      context,
                      icon: Icons.language,
                      label: 'BSE India',
                      onTap: () async {
                        bool connect = await InternetChecker.hasConnection();
                        if (connect == true) {
                          final Uri url = Uri.parse(
                            'https://www.bseindia.com/',
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            throw 'could not launch ';
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          AppMessage.show(context, 'No Network connection');
                        }
                      },
                    ),
                    _buildNavButton(
                      context,
                      icon: Icons.trending_up,
                      label: 'NSE India',
                      onTap: () async {
                        bool connect = await InternetChecker.hasConnection();
                        if (connect == true) {
                          final Uri url = Uri.parse(
                            'https://www.nseindia.com/',
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            throw 'could not launch ';
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          AppMessage.show(context, 'No Network connection');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataTile(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      // decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.2), // Glassmorphism effect
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      blur: .1,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // UI Helper for the Bottom Navigation Buttons
  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}
