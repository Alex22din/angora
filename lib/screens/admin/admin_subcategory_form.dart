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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subcategory?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                Text(
                  'Subcategory Name',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.plusJakartaSans(fontSize: 15, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. Crêpes Classiques',
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
                ),
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
}
