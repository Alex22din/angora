import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/io_helper.dart' as io;
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../models/menu_data.dart';
import '../l10n/translations.dart';

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
      listenable: Listenable.merge([ThemeService(), LanguageService()]),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final card = AppColorsHelper.card(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final textDim = AppColorsHelper.textDim(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);
        final border = AppColorsHelper.border(isNight);

        final ingredients = item.localizedIngredients;

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
                          ? _buildItemImage(item.imageUrl!, categoryIcon)
                          : Center(
                              child: Text(categoryIcon, style: const TextStyle(fontSize: 72)),
                            ),
                    ),
                  ),
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
                                      item.localizedName,
                                      style: GoogleFonts.cinzel(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: primary,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    if (item.localizedDescription != null && item.localizedDescription!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          item.localizedDescription!,
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
                            T.ingredients,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (ingredients != null && ingredients.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ingredients.map((ing) {
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
                              T.noIngredients,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: textDim,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
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
                          T.close,
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

  Widget _buildItemImage(String url, String categoryIcon) {
    final fallback = Center(
      child: Text(categoryIcon, style: const TextStyle(fontSize: 72)),
    );

    if (url.startsWith('data:')) {
      try {
        final bytes = base64Decode(url.split(',').last);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, e, s) => fallback,
        );
      } catch (_) {
        return fallback;
      }
    }

    return io.buildImageFromFile(
      url,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (_, e, s) => fallback,
      fallback: fallback,
    );
  }
}
