import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helpers/io_helper.dart' as io;
import '../../theme/app_theme.dart';
import '../../services/theme_service.dart';
import '../../models/menu_data.dart';
import '../../models/menu_data_manager.dart';

class AdminItemForm extends StatefulWidget {
  final String categoryId;
  final String? subcategoryId;
  final MenuItem? item;

  const AdminItemForm({
    super.key,
    required this.categoryId,
    this.subcategoryId,
    this.item,
  });

  @override
  State<AdminItemForm> createState() => _AdminItemFormState();
}

class _AdminItemFormState extends State<AdminItemForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _multiPriceKeyController = TextEditingController();
  final _multiPriceValueController = TextEditingController();

  final _nameEnController = TextEditingController();
  final _nameArController = TextEditingController();
  final _descEnController = TextEditingController();
  final _descArController = TextEditingController();
  final _ingredientEnController = TextEditingController();
  final _ingredientArController = TextEditingController();

  bool _isMultiPriced = false;
  Map<String, int> _prices = {};
  List<String> _ingredients = [];
  List<String>? _ingredientsEn;
  List<String>? _ingredientsAr;
  Uint8List? _pickedImageBytes;
  String? _pickedImageExt;
  String? _existingImageUrl;

  bool _showTranslations = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      final item = widget.item!;
      _nameController.text = item.name;
      _descriptionController.text = item.description ?? '';
      _priceController.text = item.price?.toString() ?? '';
      _isMultiPriced = item.isMultiPriced;
      _prices = Map.from(item.prices ?? {});
      _ingredients = List.from(item.ingredients ?? []);
      _ingredientsEn = item.ingredientsEn != null ? List.from(item.ingredientsEn!) : null;
      _ingredientsAr = item.ingredientsAr != null ? List.from(item.ingredientsAr!) : null;
      _existingImageUrl = item.imageUrl;

      _nameEnController.text = item.nameEn ?? '';
      _nameArController.text = item.nameAr ?? '';
      _descEnController.text = item.descriptionEn ?? '';
      _descArController.text = item.descriptionAr ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ingredientController.dispose();
    _multiPriceKeyController.dispose();
    _multiPriceValueController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _descEnController.dispose();
    _descArController.dispose();
    _ingredientEnController.dispose();
    _ingredientArController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      _pickedImageExt = file.extension ?? 'png';
      if (kIsWeb) {
        _pickedImageBytes = file.bytes;
      } else {
        _pickedImageBytes = await io.readFileBytes(file.path!);
      }
      setState(() {});
    }
  }

  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _ingredients.add(text);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _addIngredientEn() {
    final text = _ingredientEnController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _ingredientsEn ??= [];
        _ingredientsEn!.add(text);
        _ingredientEnController.clear();
      });
    }
  }

  void _removeIngredientEn(int index) {
    setState(() {
      _ingredientsEn?.removeAt(index);
      if (_ingredientsEn != null && _ingredientsEn!.isEmpty) _ingredientsEn = null;
    });
  }

  void _addIngredientAr() {
    final text = _ingredientArController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _ingredientsAr ??= [];
        _ingredientsAr!.add(text);
        _ingredientArController.clear();
      });
    }
  }

  void _removeIngredientAr(int index) {
    setState(() {
      _ingredientsAr?.removeAt(index);
      if (_ingredientsAr != null && _ingredientsAr!.isEmpty) _ingredientsAr = null;
    });
  }

  void _addPriceEntry() {
    final key = _multiPriceKeyController.text.trim();
    final value = int.tryParse(_multiPriceValueController.text.trim());
    if (key.isNotEmpty && value != null) {
      setState(() {
        _prices[key] = value;
        _multiPriceKeyController.clear();
        _multiPriceValueController.clear();
      });
    }
  }

  void _removePriceEntry(String key) {
    setState(() => _prices.remove(key));
  }

  void _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    int? price;
    if (!_isMultiPriced) {
      price = int.tryParse(_priceController.text.trim());
    }

    String? savedImageUrl = _existingImageUrl;
    if (_pickedImageBytes != null) {
      savedImageUrl = await MenuDataManager().saveImageBytes(
        _pickedImageBytes!,
        widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        _pickedImageExt ?? 'png',
      );
    }

    final result = MenuItem(
      id: widget.item?.id,
      name: name,
      nameEn: _nameEnController.text.trim().isEmpty ? null : _nameEnController.text.trim(),
      nameAr: _nameArController.text.trim().isEmpty ? null : _nameArController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      descriptionEn: _descEnController.text.trim().isEmpty ? null : _descEnController.text.trim(),
      descriptionAr: _descArController.text.trim().isEmpty ? null : _descArController.text.trim(),
      price: _isMultiPriced ? null : price,
      isMultiPriced: _isMultiPriced,
      prices: _isMultiPriced && _prices.isNotEmpty ? _prices : null,
      ingredients: _ingredients.isNotEmpty ? _ingredients : null,
      ingredientsEn: _ingredientsEn,
      ingredientsAr: _ingredientsAr,
      imageUrl: savedImageUrl,
    );

    if (mounted) {
      Navigator.pop(context, result);
    }
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
        final isEditing = widget.item != null;

        return Scaffold(
          backgroundColor: scaffold,
          appBar: AppBar(
            backgroundColor: scaffold,
            foregroundColor: primary,
            title: Text(
              isEditing ? 'Edit Item' : 'Add Item',
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
                // ── Image Picker ──
                _buildLabel('Item Image', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: border, style: BorderStyle.solid),
                    ),
                    child: _pickedImageBytes != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.card),
                                child: Image.memory(
                                  _pickedImageBytes!,
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _pickedImageBytes = null;
                                    _pickedImageExt = null;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _existingImageUrl != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppRadius.card),
                                    child: _existingImageUrl!.startsWith('http')
                                        ? Image.network(
                                            _existingImageUrl!,
                                            width: double.infinity,
                                            height: 160,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, e, s) => _buildImagePlaceholder(textMuted),
                                          )
                                        : _existingImageUrl!.startsWith('data:')
                                            ? _buildDataUrlImage(_existingImageUrl!, textMuted)
                                            : io.buildImageFromFile(
                                                _existingImageUrl!,
                                                width: double.infinity,
                                                height: 160,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, e, s) => _buildImagePlaceholder(textMuted),
                                                fallback: _buildImagePlaceholder(textMuted),
                                              ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _existingImageUrl = null;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _buildImagePlaceholder(textMuted),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Name (FR) ──
                _buildLabelWithFlag('Name', 'FR', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(_nameController, 'e.g. Pizza Marguerite', textMuted, textPrimary, border, cardBg, primary, isNight),
                const SizedBox(height: AppSpacing.lg),

                // ── Description (FR) ──
                _buildLabelWithFlag('Description', 'FR', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(_descriptionController, 'Short description...', textMuted, textPrimary, border, cardBg, primary, isNight),
                const SizedBox(height: AppSpacing.lg),

                // ── Pricing ──
                Row(
                  children: [
                    _buildLabel('Multi-priced', textPrimary),
                    const Spacer(),
                    Switch(
                      value: _isMultiPriced,
                      onChanged: (v) => setState(() => _isMultiPriced = v),
                      activeThumbColor: primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                if (!_isMultiPriced) ...[
                  _buildLabel('Price (DA)', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_priceController, 'e.g. 300', textMuted, textPrimary, border, cardBg, primary, isNight, isNumber: true),
                ] else ...[
                  ..._prices.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_formatKey(e.key)}: ${e.value} DA',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removePriceEntry(e.key),
                                child: const Icon(Icons.close, size: 18, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildTextField(_multiPriceKeyController, 'Key (e.g. petit_verre)', textMuted, textPrimary, border, cardBg, primary, isNight),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(_multiPriceValueController, 'Price', textMuted, textPrimary, border, cardBg, primary, isNight, isNumber: true),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: _addPriceEntry,
                        icon: Icon(Icons.add_circle, color: primary, size: 32),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),

                // ── Ingredients (FR) ──
                _buildLabelWithFlag('Ingredients', 'FR', textPrimary),
                const SizedBox(height: AppSpacing.sm),
                if (_ingredients.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_ingredients.length, (i) {
                      return Chip(
                        label: Text(
                          _ingredients[i],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: textPrimary,
                          ),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _removeIngredient(i),
                        backgroundColor: cardBg,
                        side: BorderSide(color: border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      );
                    }),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_ingredientController, 'Add ingredient...', textMuted, textPrimary, border, cardBg, primary, isNight),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      onPressed: _addIngredient,
                      icon: Icon(Icons.add_circle, color: primary, size: 32),
                    ),
                  ],
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

                  // ── Name (EN) ──
                  _buildLabelWithFlag('Name', 'EN', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_nameEnController, 'English name...', textMuted, textPrimary, border, cardBg, primary, isNight),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Name (AR) ──
                  _buildLabelWithFlag('Name', 'AR', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_nameArController, '...اسم بالعربية', textMuted, textPrimary, border, cardBg, primary, isNight, isRtl: true),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Description (EN) ──
                  _buildLabelWithFlag('Description', 'EN', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_descEnController, 'English description...', textMuted, textPrimary, border, cardBg, primary, isNight),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Description (AR) ──
                  _buildLabelWithFlag('Description', 'AR', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(_descArController, '...وصف بالعربية', textMuted, textPrimary, border, cardBg, primary, isNight, isRtl: true),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Ingredients (EN) ──
                  _buildLabelWithFlag('Ingredients', 'EN', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  if (_ingredientsEn != null && _ingredientsEn!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_ingredientsEn!.length, (i) {
                        return Chip(
                          label: Text(
                            _ingredientsEn![i],
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textPrimary),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeIngredientEn(i),
                          backgroundColor: cardBg,
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        );
                      }),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(_ingredientEnController, 'Add ingredient (EN)...', textMuted, textPrimary, border, cardBg, primary, isNight),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: _addIngredientEn,
                        icon: Icon(Icons.add_circle, color: primary, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Ingredients (AR) ──
                  _buildLabelWithFlag('Ingredients', 'AR', textPrimary),
                  const SizedBox(height: AppSpacing.sm),
                  if (_ingredientsAr != null && _ingredientsAr!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_ingredientsAr!.length, (i) {
                        return Chip(
                          label: Text(
                            _ingredientsAr![i],
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textPrimary),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeIngredientAr(i),
                          backgroundColor: cardBg,
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        );
                      }),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(_ingredientArController, '...أضف مكوّن', textMuted, textPrimary, border, cardBg, primary, isNight, isRtl: true),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: _addIngredientAr,
                        icon: Icon(Icons.add_circle, color: primary, size: 32),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),

                // ── Save ──
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
                      isEditing ? 'Update Item' : 'Add Item',
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
        Text(
          flags[lang] ?? '',
          style: const TextStyle(fontSize: 14),
        ),
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
    Color primary,
    bool isNight, {
    bool isNumber = false,
    bool isRtl = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color textMuted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 36, color: textMuted),
        const SizedBox(height: 8),
        Text(
          'Tap to pick an image',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMuted),
        ),
      ],
    );
  }

  Widget _buildDataUrlImage(String dataUrl, Color textMuted) {
    try {
      final bytes = base64Decode(dataUrl.split(',').last);
      return Image.memory(
        bytes,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => _buildImagePlaceholder(textMuted),
      );
    } catch (_) {
      return _buildImagePlaceholder(textMuted);
    }
  }

  String _formatKey(String key) {
    return key.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
