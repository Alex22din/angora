import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/io_helper.dart' as io;
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../models/menu_data.dart';
import '../l10n/translations.dart';
import 'menu_item_detail_dialog.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final String categoryIcon;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;

    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService(), LanguageService()]),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final card = AppColorsHelper.card(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final textDim = AppColorsHelper.textDim(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);

        final ingredients = item.localizedIngredients;

        return GestureDetector(
          onTap: () => MenuItemDetailDialog.show(context, item, categoryIcon),
          child: Container(
            padding: EdgeInsets.all(isPhone ? 12 : 16),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: [
                BoxShadow(
                  color: (isNight ? Colors.black : const Color(0xFF0A3981))
                      .withValues(alpha: isNight ? 0.3 : 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: isPhone ? 70 : 110,
                    height: isPhone ? 70 : 110,
                    color: cardBg,
                    child: item.imageUrl != null
                        ? _buildItemImage(item.imageUrl!, categoryIcon, isPhone)
                        : Center(
                            child: Text(
                              categoryIcon,
                              style: TextStyle(fontSize: isPhone ? 32 : 44),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: isPhone ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.localizedName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isPhone ? 14 : 18,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                      if (item.localizedDescription != null && item.localizedDescription!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.localizedDescription!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isPhone ? 11 : 13,
                            color: textMuted,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        ingredients != null ? T.ingredientsCount(ingredients.length) : '',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: textDim,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isPhone ? 8 : 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.isMultiPriced
                          ? '${T.from} ${item.prices?.values.first ?? 0} DA'
                          : '${item.price ?? 0} DA',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isPhone ? 14 : 18,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      T.viewDetails,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemImage(String url, String categoryIcon, bool isPhone) {
    final fallback = Center(
      child: Text(categoryIcon, style: TextStyle(fontSize: isPhone ? 32 : 44)),
    );

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => fallback,
      );
    }

    if (url.startsWith('data:')) {
      try {
        final bytes = base64Decode(url.split(',').last);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: double.infinity,
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
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, e, s) => fallback,
      fallback: fallback,
    );
  }
}
