import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/theme_service.dart';
import '../../models/menu_data.dart';

class AdminCategoryForm extends StatefulWidget {
  final MenuCategory? category;

  const AdminCategoryForm({super.key, this.category});

  @override
  State<AdminCategoryForm> createState() => _AdminCategoryFormState();
}

class _AdminCategoryFormState extends State<AdminCategoryForm> {
  late TextEditingController _nameController;
  late TextEditingController _iconController;
  late TextEditingController _nameEnController;
  late TextEditingController _nameArController;

  bool _showTranslations = false;

  static const List<String> _emojiSuggestions = [
    '🥞', '☕', '🥤', '🍕', '🍔', '🍰', '🎂', '🧁', '🍩',
    '🍜', '🍝', '🥗', '🍖', '🍗', '🥩', '🌮', '🌯', '🥪',
    '🥤', '🧃', '🍷', '🍸', '🍹', '🧋', '☕', '🍵',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _iconController = TextEditingController(text: widget.category?.icon ?? '');
    _nameEnController = TextEditingController(text: widget.category?.nameEn ?? '');
    _nameArController = TextEditingController(text: widget.category?.nameAr ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final icon = _iconController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }
    if (icon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Icon is required')),
      );
      return;
    }

    final result = MenuCategory(
      id: widget.category?.id,
      name: name,
      nameEn: _nameEnController.text.trim().isEmpty ? null : _nameEnController.text.trim(),
      nameAr: _nameArController.text.trim().isEmpty ? null : _nameArController.text.trim(),
      icon: icon,
      subcategories: widget.category?.subcategories,
      items: widget.category?.items,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final scaffold = AppColorsHelper.scaffold(isNight);
        final card = AppColorsHelper.card(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final border = AppColorsHelper.border(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);
        final isEditing = widget.category != null;

        return Scaffold(
          backgroundColor: scaffold,
          appBar: AppBar(
            backgroundColor: scaffold,
            foregroundColor: primary,
            title: Text(
              isEditing ? 'Edit Category' : 'Add Category',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name (FR)
                _buildLabelWithFlag('Category Name', 'FR', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(_nameController, 'e.g. Gourmandises', textMuted, textPrimary, border, cardBg, primary),
                const SizedBox(height: AppSpacing.lg),

                // Icon
                _buildLabel('Icon (Emoji)', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _iconController,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '🥧',
                    hintStyle: TextStyle(color: textMuted),
                    filled: true,
                    fillColor: cardBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: BorderSide(color: border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: BorderSide(color: border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Emoji suggestions
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _emojiSuggestions.map((emoji) {
                    return GestureDetector(
                      onTap: () => setState(() => _iconController.text = emoji),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _iconController.text == emoji
                              ? primary.withValues(alpha: 0.2)
                              : cardBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _iconController.text == emoji ? primary : border,
                            width: _iconController.text == emoji ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(emoji, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Preview
                if (_iconController.text.isNotEmpty || _nameController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        if (_iconController.text.isNotEmpty)
                          Text(_iconController.text, style: const TextStyle(fontSize: 32)),
                        if (_nameController.text.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nameController.text,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                                if (_nameEnController.text.isNotEmpty)
                                  Text(
                                    _nameEnController.text,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: textMuted,
                                    ),
                                  ),
                                if (_nameArController.text.isNotEmpty)
                                  Text(
                                    _nameArController.text,
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: textMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),

                // ── Translations Toggle ──
                GestureDetector(
                  onTap: () => setState(() => _showTranslations = !_showTranslations),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.language, size: 20, color: primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Translations (EN / AR)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          _showTranslations ? Icons.expand_less : Icons.expand_more,
                          color: textMuted,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_showTranslations) ...[
                  const SizedBox(height: AppSpacing.lg),

                  // Name (EN)
                  _buildLabelWithFlag('Category Name', 'EN', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_nameEnController, 'e.g. Sweet Treats', textMuted, textPrimary, border, cardBg, primary),
                  const SizedBox(height: AppSpacing.lg),

                  // Name (AR)
                  _buildLabelWithFlag('Category Name', 'AR', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_nameArController, '...الحلويات', textMuted, textPrimary, border, cardBg, primary, isRtl: true),
                ],
                const SizedBox(height: AppSpacing.xl),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: isNight ? AppColors.nightScaffold : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isEditing ? 'Update Category' : 'Add Category',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildLabelWithFlag(String text, String lang, Color color) {
    final flags = {'FR': '🇫🇷', 'EN': '🇬🇧', 'AR': '🇸🇦'};
    return Row(
      children: [
        Text(flags[lang] ?? '', style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 6),
        Text(
          '$text ($lang)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    Color textMuted,
    Color textPrimary,
    Color border,
    Color cardBg,
    Color primary, {
    bool isRtl = false,
  }) {
    return TextField(
      controller: controller,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      style: GoogleFonts.plusJakartaSans(fontSize: 15, color: textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: textMuted),
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }
}
