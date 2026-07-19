import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/theme_service.dart';
import '../../models/menu_data.dart';

class AdminSubcategoryForm extends StatefulWidget {
  final String categoryId;
  final MenuSubcategory? subcategory;

  const AdminSubcategoryForm({
    super.key,
    required this.categoryId,
    this.subcategory,
  });

  @override
  State<AdminSubcategoryForm> createState() => _AdminSubcategoryFormState();
}

class _AdminSubcategoryFormState extends State<AdminSubcategoryForm> {
  late TextEditingController _nameController;
  late TextEditingController _nameEnController;
  late TextEditingController _nameArController;

  bool _showTranslations = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subcategory?.name ?? '');
    _nameEnController = TextEditingController(text: widget.subcategory?.nameEn ?? '');
    _nameArController = TextEditingController(text: widget.subcategory?.nameAr ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    final result = MenuSubcategory(
      id: widget.subcategory?.id,
      name: name,
      nameEn: _nameEnController.text.trim().isEmpty ? null : _nameEnController.text.trim(),
      nameAr: _nameArController.text.trim().isEmpty ? null : _nameArController.text.trim(),
      items: widget.subcategory?.items ?? [],
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
        final textPrimary = AppColorsHelper.textPrimary(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final border = AppColorsHelper.border(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);
        final isEditing = widget.subcategory != null;

        return Scaffold(
          backgroundColor: scaffold,
          appBar: AppBar(
            backgroundColor: scaffold,
            foregroundColor: primary,
            title: Text(
              isEditing ? 'Edit Subcategory' : 'Add Subcategory',
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
                _buildLabelWithFlag('Subcategory Name', 'FR', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(_nameController, 'e.g. Crêpes Classiques', textMuted, textPrimary, border, cardBg, primary),
                const SizedBox(height: AppSpacing.lg),

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
                  _buildLabelWithFlag('Subcategory Name', 'EN', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_nameEnController, 'e.g. Classic Crêpes', textMuted, textPrimary, border, cardBg, primary),
                  const SizedBox(height: AppSpacing.lg),

                  // Name (AR)
                  _buildLabelWithFlag('Subcategory Name', 'AR', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_nameArController, '...كريب كلاسيكي', textMuted, textPrimary, border, cardBg, primary, isRtl: true),
                ],
                const SizedBox(height: AppSpacing.xl),

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
                      isEditing ? 'Update Subcategory' : 'Add Subcategory',
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
      autofocus: true,
      onSubmitted: (_) => _save(),
    );
  }
}
