import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../models/menu_data.dart';

class MenuItemDetailDialog extends StatelessWidget {
  final MenuItem item;
  final String categoryIcon;

  const MenuItemDetailDialog({
    super.key,
    required this.item,
    required this.categoryIcon,
  });

  static void show(BuildContext context, MenuItem item, String categoryIcon) {
    showDialog(
      context: context,
      builder: (_) => MenuItemDetailDialog(item: item, categoryIcon: categoryIcon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final card = AppColorsHelper.card(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final textDim = AppColorsHelper.textDim(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);
        final border = AppColorsHelper.border(isNight);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: (isNight ? AppColors.nightPrimary : const Color(0xFF0A3981))
                        .withValues(alpha: isNight ? 0.2 : 0.15),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image section
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.lg),
                        topRight: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.lg),
                        topRight: Radius.circular(AppRadius.lg),
                      ),
                      child: item.imageUrl != null
                          ? Image.file(
                              File(item.imageUrl!),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, s) => Center(
                                child: Text(categoryIcon, style: const TextStyle(fontSize: 72)),
                              ),
                            )
                          : Center(
                              child: Text(categoryIcon, style: const TextStyle(fontSize: 72)),
                            ),
                    ),
                  ),
                  // Details
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.cinzel(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: primary,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    if (item.description != null && item.description!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          item.description!,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            color: textMuted,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Text(
                                  item.priceDisplay,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isNight ? AppColors.nightScaffold : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (item.isMultiPriced && item.prices != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: item.prices!.entries.map((e) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    '${_formatKey(e.key)}: ${e.value} DA',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          Container(height: 1, color: border),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'INGREDIENTS',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (item.ingredients != null && item.ingredients!.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.ingredients!.map((ing) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    ing,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            Text(
                              'No ingredients listed',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: textDim,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Close button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                    child: SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: isNight ? AppColors.nightScaffold : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Close',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatKey(String key) {
    return key.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
