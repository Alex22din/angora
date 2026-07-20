import 'package:uuid/uuid.dart';

import '../services/language_service.dart';

const _uuid = Uuid();

class MenuItem {
  String id;
  String name;
  String? nameEn;
  String? nameAr;
  String? description;
  String? descriptionEn;
  String? descriptionAr;
  int? price;
  bool isMultiPriced;
  Map<String, int>? prices;
  List<String>? ingredients;
  List<String>? ingredientsEn;
  List<String>? ingredientsAr;
  String? imageUrl;

  MenuItem({
    String? id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.description,
    this.descriptionEn,
    this.descriptionAr,
    this.price,
    this.isMultiPriced = false,
    this.prices,
    this.ingredients,
    this.ingredientsEn,
    this.ingredientsAr,
    this.imageUrl,
  }) : id = id ?? _uuid.v4();

  String get localizedName {
    return LanguageService().translated(name, nameEn, nameAr);
  }

  String? get localizedDescription {
    switch (LanguageService().currentLanguage) {
      case 'en':
        return descriptionEn ?? description;
      case 'ar':
        return descriptionAr ?? description;
      default:
        return description;
    }
  }

  List<String>? get localizedIngredients {
    switch (LanguageService().currentLanguage) {
      case 'en':
        return ingredientsEn ?? ingredients;
      case 'ar':
        return ingredientsAr ?? ingredients;
      default:
        return ingredients;
    }
  }

  String get priceDisplay {
    if (isMultiPriced && prices != null) {
      return prices!.entries.map((e) => '${_label(e.key)} ${e.value} DA').join(' | ');
    }
    return '${price ?? 0} DA';
  }

  static String _label(String key) {
    return key.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'description': description,
        'descriptionEn': descriptionEn,
        'descriptionAr': descriptionAr,
        'price': price,
        'isMultiPriced': isMultiPriced,
        'prices': prices,
        'ingredients': ingredients,
        'ingredientsEn': ingredientsEn,
        'ingredientsAr': ingredientsAr,
        'imageUrl': imageUrl,
      };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as String?,
        name: json['name'] as String,
        nameEn: json['nameEn'] as String?,
        nameAr: json['nameAr'] as String?,
        description: json['description'] as String?,
        descriptionEn: json['descriptionEn'] as String?,
        descriptionAr: json['descriptionAr'] as String?,
        price: (json['price'] as num?)?.toInt(),
        isMultiPriced: json['isMultiPriced'] as bool? ?? false,
        prices: (json['prices'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, (v as num).toInt()),
        ),
        ingredients: (json['ingredients'] as List<dynamic>?)?.cast<String>(),
        ingredientsEn: (json['ingredientsEn'] as List<dynamic>?)?.cast<String>(),
        ingredientsAr: (json['ingredientsAr'] as List<dynamic>?)?.cast<String>(),
        imageUrl: json['imageUrl'] as String?,
      );

  MenuItem copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? nameAr,
    String? description,
    String? descriptionEn,
    String? descriptionAr,
    int? price,
    bool? isMultiPriced,
    Map<String, int>? prices,
    List<String>? ingredients,
    List<String>? ingredientsEn,
    List<String>? ingredientsAr,
    String? imageUrl,
  }) =>
      MenuItem(
        id: id ?? this.id,
        name: name ?? this.name,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        description: description ?? this.description,
        descriptionEn: descriptionEn ?? this.descriptionEn,
        descriptionAr: descriptionAr ?? this.descriptionAr,
        price: price ?? this.price,
        isMultiPriced: isMultiPriced ?? this.isMultiPriced,
        prices: prices ?? this.prices,
        ingredients: ingredients ?? this.ingredients,
        ingredientsEn: ingredientsEn ?? this.ingredientsEn,
        ingredientsAr: ingredientsAr ?? this.ingredientsAr,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

class MenuSubcategory {
  String id;
  String name;
  String? nameEn;
  String? nameAr;
  List<MenuItem> items;

  MenuSubcategory({
    String? id,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.items,
  }) : id = id ?? _uuid.v4();

  String get localizedName {
    return LanguageService().translated(name, nameEn, nameAr);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'items': items.map((i) => i.toJson()).toList(),
      };

  factory MenuSubcategory.fromJson(Map<String, dynamic> json) => MenuSubcategory(
        id: json['id'] as String?,
        name: json['name'] as String,
        nameEn: json['nameEn'] as String?,
        nameAr: json['nameAr'] as String?,
        items: (json['items'] as List<dynamic>?)
                ?.map((i) => MenuItem.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class MenuCategory {
  String id;
  String name;
  String? nameEn;
  String? nameAr;
  String icon;
  List<MenuSubcategory>? subcategories;
  List<MenuItem>? items;

  MenuCategory({
    String? id,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.icon,
    this.subcategories,
    this.items,
  }) : id = id ?? _uuid.v4();

  String get localizedName {
    return LanguageService().translated(name, nameEn, nameAr);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'icon': icon,
        'subcategories': subcategories?.map((s) => s.toJson()).toList(),
        'items': items?.map((i) => i.toJson()).toList(),
      };

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        id: json['id'] as String?,
        name: json['name'] as String,
        nameEn: json['nameEn'] as String?,
        nameAr: json['nameAr'] as String?,
        icon: json['icon'] as String,
        subcategories: (json['subcategories'] as List<dynamic>?)
            ?.map((s) => MenuSubcategory.fromJson(s as Map<String, dynamic>))
            .toList(),
        items: (json['items'] as List<dynamic>?)
            ?.map((i) => MenuItem.fromJson(i as Map<String, dynamic>))
            .toList(),
      );
}

List<MenuCategory> defaultMenuCategories() => [
      MenuCategory(
        id: 'gourmandises',
        name: 'Gourmandises',
        nameEn: 'Sweet Treats',
        nameAr: 'الحلويات',
        icon: '🥞',
        subcategories: [
          MenuSubcategory(
            name: 'Crêpes Classiques & Croustillantes',
            nameEn: 'Classic & Crispy Crêpes',
            nameAr: 'كريب كلاسيكي ومقرمش',
            items: [
              MenuItem(
                name: 'Chocolat',
                nameEn: 'Chocolate',
                nameAr: 'شوكولاتة',
                price: 250,
                ingredients: ['Pâte à crêpes', 'Chocolat fondu', 'Beurre'],
                ingredientsEn: ['Crêpe batter', 'Melted chocolate', 'Butter'],
                ingredientsAr: ['عجينة الكريب', 'شوكولاتة ذائبة', 'زبدة'],
              ),
              MenuItem(
                name: 'Un fruit',
                nameEn: 'One fruit',
                nameAr: 'فاكهة واحدة',
                description: 'Banane / Ananas / Fraise / Pêche',
                descriptionEn: 'Banana / Pineapple / Strawberry / Peach',
                descriptionAr: 'موز / أناناس / فراولة / خوخ',
                price: 350,
                ingredients: ['Pâte à crêpes', 'Fruit frais', 'Chocolat', 'Crème'],
                ingredientsEn: ['Crêpe batter', 'Fresh fruit', 'Chocolate', 'Cream'],
                ingredientsAr: ['عجينة الكريب', 'فاكهة طازجة', 'شوكولاتة', 'كريمة'],
              ),
              MenuItem(
                name: 'Deux fruits',
                nameEn: 'Two fruits',
                nameAr: 'فاكتان',
                price: 450,
                ingredients: ['Pâte à crêpes', 'Deux fruits frais', 'Chocolat', 'Crème'],
                ingredientsEn: ['Crêpe batter', 'Two fresh fruits', 'Chocolate', 'Cream'],
                ingredientsAr: ['عجينة الكريب', 'فاكهة طازجة', 'شوكولاتة', 'كريمة'],
              ),
              MenuItem(
                name: '03 chocolats',
                nameEn: '3 Chocolates',
                nameAr: '3 شوكولاتات',
                price: 500,
                ingredients: ['Pâte à crêpes', 'Chocolat noir', 'Chocolat au lait', 'Chocolat blanc'],
                ingredientsEn: ['Crêpe batter', 'Dark chocolate', 'Milk chocolate', 'White chocolate'],
                ingredientsAr: ['عجينة الكريب', 'شوكولاتة سوداء', 'شوكولاتة بالحليب', 'شوكولاتة بيضاء'],
              ),
              MenuItem(
                name: 'Angora',
                price: 600,
                ingredients: ['Pâte à crêpes', 'Chocolat', 'Fruits', 'Crème', 'Noisettes'],
                ingredientsEn: ['Crêpe batter', 'Chocolate', 'Fruits', 'Cream', 'Hazelnuts'],
                ingredientsAr: ['عجينة الكريب', 'شوكولاتة', 'فواكه', 'كريمة', 'بندق'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Crêpes Croustillantes MEGA',
            nameEn: 'MEGA Crispy Crêpes',
            nameAr: 'كريب مقرمش كبير',
            items: [
              MenuItem(
                name: 'Chocolat',
                nameEn: 'Chocolate',
                nameAr: 'شوكولاتة',
                price: 2500,
                ingredients: ['Pâte croustillante', 'Chocolat fondu', 'Beurre', 'Sucre glace'],
                ingredientsEn: ['Crispy batter', 'Melted chocolate', 'Butter', 'Icing sugar'],
                ingredientsAr: ['عجينة مقرمشة', 'شوكولاتة ذائبة', 'زبدة', 'سكر ناعم'],
              ),
              MenuItem(
                name: 'Aux fruits',
                nameEn: 'With fruits',
                nameAr: 'بالفواكه',
                price: 3000,
                ingredients: ['Pâte croustillante', 'Fruits frais', 'Chocolat', 'Crème', 'Sirop'],
                ingredientsEn: ['Crispy batter', 'Fresh fruits', 'Chocolate', 'Cream', 'Syrup'],
                ingredientsAr: ['عجينة مقرمشة', 'فاكهة طازجة', 'شوكولاتة', 'كريمة', 'شراب'],
              ),
              MenuItem(
                name: 'Angora',
                price: 5000,
                ingredients: ['Pâte croustillante', 'Chocolat', 'Fruits', 'Crème', 'Noisettes', 'Glace'],
                ingredientsEn: ['Crispy batter', 'Chocolate', 'Fruits', 'Cream', 'Hazelnuts', 'Ice cream'],
                ingredientsAr: ['عجينة مقرمشة', 'شوكولاتة', 'فواكه', 'كريمة', 'بندق', 'آيس كريم'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Pancakes (à partir de 03 étages)',
            nameEn: 'Pancakes (from 3 layers)',
            nameAr: 'بان كيك (من 3 طبقات)',
            items: [
              MenuItem(
                name: 'Chocolat',
                nameEn: 'Chocolate',
                nameAr: 'شوكولاتة',
                price: 300,
                ingredients: ['Pâte à pancakes', 'Chocolat fondu', 'Beurre', 'Sirop d\'érable'],
                ingredientsEn: ['Pancake batter', 'Melted chocolate', 'Butter', 'Maple syrup'],
                ingredientsAr: ['عجينة البان كيك', 'شوكولاتة ذائبة', 'زبدة', 'شراب القيقب'],
              ),
              MenuItem(
                name: 'Un fruit',
                nameEn: 'One fruit',
                nameAr: 'فاكهة واحدة',
                description: 'Banane / Ananas / Fraise / Pêche',
                descriptionEn: 'Banana / Pineapple / Strawberry / Peach',
                descriptionAr: 'موز / أناناس / فراولة / خوخ',
                price: 400,
                ingredients: ['Pâte à pancakes', 'Fruit frais', 'Chocolat', 'Crème'],
                ingredientsEn: ['Pancake batter', 'Fresh fruit', 'Chocolate', 'Cream'],
                ingredientsAr: ['عجينة البان كيك', 'فاكهة طازجة', 'شوكولاتة', 'كريمة'],
              ),
              MenuItem(
                name: 'Deux fruits',
                nameEn: 'Two fruits',
                nameAr: 'فاكتان',
                price: 450,
                ingredients: ['Pâte à pancakes', 'Deux fruits frais', 'Chocolat', 'Crème'],
                ingredientsEn: ['Pancake batter', 'Two fresh fruits', 'Chocolate', 'Cream'],
                ingredientsAr: ['عجينة البان كيك', 'فاكهة طازجة', 'شوكولاتة', 'كريمة'],
              ),
              MenuItem(
                name: '03 chocolats',
                nameEn: '3 Chocolates',
                nameAr: '3 شوكولاتات',
                price: 500,
                ingredients: ['Pâte à pancakes', 'Chocolat noir', 'Chocolat au lait', 'Chocolat blanc'],
                ingredientsEn: ['Pancake batter', 'Dark chocolate', 'Milk chocolate', 'White chocolate'],
                ingredientsAr: ['عجينة البان كيك', 'شوكولاتة سوداء', 'شوكولاتة بالحليب', 'شوكولاتة بيضاء'],
              ),
              MenuItem(
                name: 'Angora',
                price: 600,
                ingredients: ['Pâte à pancakes', 'Chocolat', 'Fruits', 'Crème', 'Noisettes'],
                ingredientsEn: ['Pancake batter', 'Chocolate', 'Fruits', 'Cream', 'Hazelnuts'],
                ingredientsAr: ['عجينة البان كيك', 'شوكولاتة', 'فواكه', 'كريمة', 'بندق'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Gaufres',
            nameEn: 'Waffles',
            nameAr: 'وافل',
            items: [
              MenuItem(
                name: 'Chocolat',
                nameEn: 'Chocolate',
                nameAr: 'شوكولاتة',
                price: 350,
                ingredients: ['Pâte à gaufres', 'Chocolat fondu', 'Beurre', 'Sucre glace'],
                ingredientsEn: ['Waffle batter', 'Melted chocolate', 'Butter', 'Icing sugar'],
                ingredientsAr: ['عجينة الوافل', 'شوكولاتة ذائبة', 'زبدة', 'سكر ناعم'],
              ),
              MenuItem(
                name: 'Un fruit',
                nameEn: 'One fruit',
                nameAr: 'فاكهة واحدة',
                description: 'Banane / Ananas / Fraise / Pêche',
                descriptionEn: 'Banana / Pineapple / Strawberry / Peach',
                descriptionAr: 'موز / أناناس / فراولة / خوخ',
                price: 450,
                ingredients: ['Pâte à gaufres', 'Fruit frais', 'Chocolat', 'Crème'],
                ingredientsEn: ['Waffle batter', 'Fresh fruit', 'Chocolate', 'Cream'],
                ingredientsAr: ['عجينة الوافل', 'فاكهة طازجة', 'شوكولاتة', 'كريمة'],
              ),
              MenuItem(
                name: 'Deux fruits',
                nameEn: 'Two fruits',
                nameAr: 'فاكتان',
                price: 500,
                ingredients: ['Pâte à gaufres', 'Deux fruits frais', 'Chocolat', 'Crème'],
                ingredientsEn: ['Waffle batter', 'Two fresh fruits', 'Chocolate', 'Cream'],
                ingredientsAr: ['عجينة الوافل', 'فاكهة طازجة', 'شوكولاتة', 'كريمة'],
              ),
              MenuItem(
                name: '03 chocolats',
                nameEn: '3 Chocolates',
                nameAr: '3 شوكولاتات',
                price: 550,
                ingredients: ['Pâte à gaufres', 'Chocolat noir', 'Chocolat au lait', 'Chocolat blanc'],
                ingredientsEn: ['Waffle batter', 'Dark chocolate', 'Milk chocolate', 'White chocolate'],
                ingredientsAr: ['عجينة الوافل', 'شوكولاتة سوداء', 'شوكولاتة بالحليب', 'شوكولاتة بيضاء'],
              ),
              MenuItem(
                name: 'Angora',
                price: 650,
                ingredients: ['Pâte à gaufres', 'Chocolat', 'Fruits', 'Crème', 'Noisettes'],
                ingredientsEn: ['Waffle batter', 'Chocolate', 'Fruits', 'Cream', 'Hazelnuts'],
                ingredientsAr: ['عجينة الوافل', 'شوكولاتة', 'فواكه', 'كريمة', 'بندق'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Cheesecake',
            nameEn: 'Cheesecake',
            nameAr: 'تشيز كيك',
            items: [
              MenuItem(
                name: 'Bueno',
                price: 350,
                ingredients: ['Base biscuits', 'Crème fraîche', 'Kinder Bueno', 'Chocolat blanc'],
                ingredientsEn: ['Biscuit base', 'Sour cream', 'Kinder Bueno', 'White chocolate'],
                ingredientsAr: ['قاعدة البسكويت', 'كريمة حامضة', 'كيندر بوينو', 'شوكولاتة بيضاء'],
              ),
              MenuItem(
                name: 'Pistachio',
                nameEn: 'Pistachio',
                nameAr: 'فستق',
                price: 350,
                ingredients: ['Base biscuits', 'Crème fraîche', 'Pâte de pistache', 'Pistaches'],
                ingredientsEn: ['Biscuit base', 'Sour cream', 'Pistachio paste', 'Pistachios'],
                ingredientsAr: ['قاعدة البسكويت', 'كريمة حامضة', 'معجون الفستق', 'فستق'],
              ),
              MenuItem(
                name: 'Dubai',
                price: 350,
                ingredients: ['Base biscuits', 'Crème fraîche', 'Pistache', 'Kunafa', 'Chocolat'],
                ingredientsEn: ['Biscuit base', 'Sour cream', 'Pistachio', 'Kunafa', 'Chocolate'],
                ingredientsAr: ['قاعدة البسكويت', 'كريمة حامضة', 'فستق', 'كنافة', 'شوكولاتة'],
              ),
              MenuItem(
                name: 'Tiramisu',
                price: 250,
                ingredients: ['Biscuits cuillère', 'Mascarpone', 'Café', 'Cacao'],
                ingredientsEn: ['Ladyfingers', 'Mascarpone', 'Coffee', 'Cocoa'],
                ingredientsAr: ['بسكويت السيدة', 'ماسكاربوني', 'قهوة', 'كاكاو'],
              ),
              MenuItem(
                name: 'Verrine',
                nameEn: 'Verrine',
                nameAr: 'فيرين',
                price: 250,
                ingredients: ['Biscuits', 'Crème', 'Fruits', 'Chocolat'],
                ingredientsEn: ['Biscuits', 'Cream', 'Fruits', 'Chocolate'],
                ingredientsAr: ['بسكويت', 'كريمة', 'فواكه', 'شوكولاتة'],
              ),
              MenuItem(
                name: 'Brownies',
                nameEn: 'Brownies',
                nameAr: 'براونيز',
                price: 200,
                ingredients: ['Chocolat noir', 'Beurre', 'Sucre', 'Œufs', 'Farine', 'Noix'],
                ingredientsEn: ['Dark chocolate', 'Butter', 'Sugar', 'Eggs', 'Flour', 'Walnuts'],
                ingredientsAr: ['شوكولاتة سوداء', 'زبدة', 'سكر', 'بيض', 'دقيق', 'جوز'],
              ),
            ],
          ),
        ],
      ),
      MenuCategory(
        id: 'boissons_chaudes',
        name: 'Boissons Chaudes',
        nameEn: 'Hot Drinks',
        nameAr: 'المشروبات الساخنة',
        icon: '☕',
        items: [
          MenuItem(
            name: 'Café noir',
            nameEn: 'Black coffee',
            nameAr: 'قهوة سوداء',
            description: 'Espresso / Capsule',
            descriptionEn: 'Espresso / Capsule',
            descriptionAr: 'إسبريسو / كبسولة',
            isMultiPriced: true,
            prices: {'espresso': 30, 'capsule': 100},
            ingredients: ['Café moulu', 'Eau chaude'],
            ingredientsEn: ['Ground coffee', 'Hot water'],
            ingredientsAr: ['قهوة مطحونة', 'ماء ساخن'],
          ),
          MenuItem(
            name: 'Crème',
            nameEn: 'Cream coffee',
            nameAr: 'قهوة بالكريمة',
            price: 50,
            ingredients: ['Café', 'Lait chaud', 'Crème'],
            ingredientsEn: ['Coffee', 'Hot milk', 'Cream'],
            ingredientsAr: ['قهوة', 'حليب ساخن', 'كريمة'],
          ),
          MenuItem(
            name: 'Cappuccino',
            price: 150,
            ingredients: ['Espresso', 'Lait moussu', 'Cacao'],
            ingredientsEn: ['Espresso', 'Frothed milk', 'Cocoa'],
            ingredientsAr: ['إسبريسو', 'حليب مخفوق', 'كاكاو'],
          ),
          MenuItem(
            name: 'Lait au chocolat',
            nameEn: 'Chocolate milk',
            nameAr: 'حليب بالشوكولاتة',
            price: 150,
            ingredients: ['Lait chaud', 'Chocolat en poudre', 'Sucre'],
            ingredientsEn: ['Hot milk', 'Chocolate powder', 'Sugar'],
            ingredientsAr: ['حليب ساخن', 'مسحوق الشوكولاتة', 'سكر'],
          ),
          MenuItem(
            name: 'Thé maison',
            nameEn: 'House tea',
            nameAr: 'شاي المنزلي',
            isMultiPriced: true,
            prices: {'petit_verre': 50, 'grand_verre': 70},
            ingredients: ['Thé vert', 'Eau bouillante', 'Menthe'],
            ingredientsEn: ['Green tea', 'Boiling water', 'Mint'],
            ingredientsAr: ['شاي أخضر', 'ماء مغلي', 'نعناع'],
          ),
          MenuItem(
            name: 'Maxwell',
            price: 70,
            ingredients: ['Café Maxwell', 'Eau chaude', 'Lait (optionnel)'],
            ingredientsEn: ['Maxwell coffee', 'Hot water', 'Milk (optional)'],
            ingredientsAr: ['قهوة ماكسويل', 'ماء ساخن', 'حليب (اختياري)'],
          ),
        ],
      ),
      MenuCategory(
        id: 'boissons_froides',
        name: 'Boissons Froides',
        nameEn: 'Cold Drinks',
        nameAr: 'المشروبات الباردة',
        icon: '🥤',
        subcategories: [
          MenuSubcategory(
            name: 'Mojito',
            nameEn: 'Mojito',
            nameAr: 'موهيتو',
            items: [
              MenuItem(
                name: 'Classique',
                nameEn: 'Classic',
                nameAr: 'كلاسيكي',
                price: 300,
                ingredients: ['Menthe fraîche', 'Citron vert', 'Sucre', 'Eau gazeuse', 'Glaçons'],
                ingredientsEn: ['Fresh mint', 'Lime', 'Sugar', 'Sparkling water', 'Ice cubes'],
                ingredientsAr: ['نعناع طازج', 'ليمون حامض', 'سكر', 'ماء غازي', 'مكعبات ثلج'],
              ),
              MenuItem(
                name: 'Bleu',
                nameEn: 'Blue',
                nameAr: 'أزرق',
                price: 350,
                ingredients: ['Menthe fraîche', 'Citron vert', 'Sirop bleu', 'Eau gazeuse', 'Glaçons'],
                ingredientsEn: ['Fresh mint', 'Lime', 'Blue syrup', 'Sparkling water', 'Ice cubes'],
                ingredientsAr: ['نعناع طازج', 'ليمون حامض', 'شراب أزرق', 'ماء غازي', 'مكعبات ثلج'],
              ),
              MenuItem(
                name: 'Rouge',
                nameEn: 'Red',
                nameAr: 'أحمر',
                price: 350,
                ingredients: ['Menthe fraîche', 'Citron vert', 'Sirop rouge', 'Eau gazeuse', 'Glaçons'],
                ingredientsEn: ['Fresh mint', 'Lime', 'Red syrup', 'Sparkling water', 'Ice cubes'],
                ingredientsAr: ['نعناع طازج', 'ليمون حامض', 'شراب أحمر', 'ماء غازي', 'مكعبات ثلج'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Milkshake',
            nameEn: 'Milkshake',
            nameAr: 'ميلك شيك',
            items: [
              MenuItem(
                name: 'Nutella',
                price: 400,
                ingredients: ['Lait', 'Nutella', 'Glace vanille', 'Crème'],
                ingredientsEn: ['Milk', 'Nutella', 'Vanilla ice cream', 'Cream'],
                ingredientsAr: ['حليب', 'نوتيلا', 'آيس كريم فانيليا', 'كريمة'],
              ),
              MenuItem(
                name: 'Bueno',
                price: 450,
                ingredients: ['Lait', 'Kinder Bueno', 'Glace vanille', 'Crème'],
                ingredientsEn: ['Milk', 'Kinder Bueno', 'Vanilla ice cream', 'Cream'],
                ingredientsAr: ['حليب', 'كيندر بوينو', 'آيس كريم فانيليا', 'كريمة'],
              ),
              MenuItem(
                name: 'Pistachio',
                nameEn: 'Pistachio',
                nameAr: 'فستق',
                price: 450,
                ingredients: ['Lait', 'Pâte de pistache', 'Glace vanille', 'Crème'],
                ingredientsEn: ['Milk', 'Pistachio paste', 'Vanilla ice cream', 'Cream'],
                ingredientsAr: ['حليب', 'معجون الفستق', 'آيس كريم فانيليا', 'كريمة'],
              ),
              MenuItem(
                name: 'Oreo / Ferrero Rocher',
                price: 450,
                ingredients: ['Lait', 'Oreo ou Ferrero Rocher', 'Glace vanille', 'Crème'],
                ingredientsEn: ['Milk', 'Oreo or Ferrero Rocher', 'Vanilla ice cream', 'Cream'],
                ingredientsAr: ['حليب', 'أوريو أو فيرو روشيه', 'آيس كريم فانيليا', 'كريمة'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Jus & Boissons Gazeuses',
            nameEn: 'Juices & Sodas',
            nameAr: 'عصائر ومشروبات غازية',
            items: [
              MenuItem(
                name: 'Jus pressé',
                nameEn: 'Fresh juice',
                nameAr: 'عصير طازج',
                description: 'Fruit de saison',
                descriptionEn: 'Seasonal fruit',
                descriptionAr: 'فاكهة الموسم',
                price: 300,
                ingredients: ['Fruit frais', 'Sucre', 'Eau'],
                ingredientsEn: ['Fresh fruit', 'Sugar', 'Water'],
                ingredientsAr: ['فاكهة طازجة', 'سكر', 'ماء'],
              ),
              MenuItem(
                name: 'Jus cocktail',
                nameEn: 'Cocktail juice',
                nameAr: 'عصير كوكتيل',
                price: 450,
                ingredients: ['Multiples fruits', 'Sirop', 'Eau', 'Glaçons'],
                ingredientsEn: ['Mixed fruits', 'Syrup', 'Water', 'Ice cubes'],
                ingredientsAr: ['فواكه متنوعة', 'شراب', 'ماء', 'مكعبات ثلج'],
              ),
              MenuItem(
                name: 'Jus 33cl',
                nameEn: 'Juice 33cl',
                nameAr: 'عصير 33 سم',
                price: 80,
                ingredients: ['Jus industriel 33cl'],
                ingredientsEn: ['Canned juice 33cl'],
                ingredientsAr: ['عصير معلب 33 سم'],
              ),
              MenuItem(
                name: 'Canette',
                nameEn: 'Can',
                nameAr: 'علبة',
                price: 100,
                ingredients: ['Boisson gazeuse 33cl'],
                ingredientsEn: ['Soda 33cl'],
                ingredientsAr: ['مشروب غازي 33 سم'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Eau Minérale',
            nameEn: 'Mineral Water',
            nameAr: 'مياه معدنية',
            items: [
              MenuItem(
                name: 'Petite format',
                nameEn: 'Small size',
                nameAr: 'حجم صغير',
                price: 30,
                ingredients: ['Eau minérale 50cl'],
                ingredientsEn: ['Mineral water 50cl'],
                ingredientsAr: ['مياه معدنية 50 سم'],
              ),
              MenuItem(
                name: 'Grande format',
                nameEn: 'Large size',
                nameAr: 'حجم كبير',
                price: 50,
                ingredients: ['Eau minérale 1.5L'],
                ingredientsEn: ['Mineral water 1.5L'],
                ingredientsAr: ['مياه معدنية 1.5 لتر'],
              ),
            ],
          ),
        ],
      ),
      MenuCategory(
        id: 'pizzas_tacos',
        name: 'Pizzas & Tacos',
        nameEn: 'Pizzas & Tacos',
        nameAr: 'بيتزا وتاكوس',
        icon: '🍕',
        subcategories: [
          MenuSubcategory(
            name: 'Pizzas',
            nameEn: 'Pizzas',
            nameAr: 'بيتزا',
            items: [
              MenuItem(
                name: 'Pizza Marguerite',
                nameEn: 'Margherita Pizza',
                nameAr: 'بيتزا مارغريتا',
                description: 'Sauce tomate, Cheddar, Olive',
                descriptionEn: 'Tomato sauce, Cheddar, Olive',
                descriptionAr: 'صلصة طماطم، شيدر، زيتون',
                price: 300,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Cheddar', 'Olives'],
                ingredientsEn: ['Pizza dough', 'Tomato sauce', 'Cheddar', 'Olives'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة طماطم', 'شيدر', 'زيتون'],
              ),
              MenuItem(
                name: 'Pizza Poulet',
                nameEn: 'Chicken Pizza',
                nameAr: 'بيتزا دجاج',
                description: 'Sauce blanche, Poulet, Cheddar, Mozzarella',
                descriptionEn: 'White sauce, Chicken, Cheddar, Mozzarella',
                descriptionAr: 'صلصة بيضاء، دجاج، شيدر، موزاريلا',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce blanche', 'Poulet grillé', 'Cheddar', 'Mozzarella'],
                ingredientsEn: ['Pizza dough', 'White sauce', 'Grilled chicken', 'Cheddar', 'Mozzarella'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة بيضاء', 'دجاج مشوي', 'شيدر', 'موزاريلا'],
              ),
              MenuItem(
                name: 'Pizza Viande Hachée',
                nameEn: 'Minced Meat Pizza',
                nameAr: 'بيتза لحم مفروم',
                description: 'Sauce tomate, Viande hachée, Cheddar, Mozzarella',
                descriptionEn: 'Tomato sauce, Minced meat, Cheddar, Mozzarella',
                descriptionAr: 'صلصة طماطم، لحم مفروم، شيدر، موزاريلا',
                price: 400,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Viande hachée', 'Cheddar', 'Mozzarella'],
                ingredientsEn: ['Pizza dough', 'Tomato sauce', 'Minced meat', 'Cheddar', 'Mozzarella'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة طماطم', 'لحم مفروم', 'شيدر', 'موزاريلا'],
              ),
              MenuItem(
                name: 'Pizza Thon',
                nameEn: 'Tuna Pizza',
                nameAr: 'بيتزا تونة',
                description: 'Sauce tomate, Thon, Cheddar, Mozzarella',
                descriptionEn: 'Tomato sauce, Tuna, Cheddar, Mozzarella',
                descriptionAr: 'صلصة طماطم، تونة، شيدر، موزاريلا',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Thon', 'Cheddar', 'Mozzarella'],
                ingredientsEn: ['Pizza dough', 'Tomato sauce', 'Tuna', 'Cheddar', 'Mozzarella'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة طماطم', 'تونة', 'شيدر', 'موزاريلا'],
              ),
              MenuItem(
                name: 'Pizza Mix',
                nameEn: 'Mix Pizza',
                nameAr: 'بيتزا ميكس',
                description: 'Sauce tomate, Poulet, Viande hachée, Fromage',
                descriptionEn: 'Tomato sauce, Chicken, Minced meat, Cheese',
                descriptionAr: 'صلصة طماطم، دجاج، لحم مفروم، جبنة',
                price: 500,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Poulet', 'Viande hachée', 'Fromage'],
                ingredientsEn: ['Pizza dough', 'Tomato sauce', 'Chicken', 'Minced meat', 'Cheese'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة طماطم', 'دجاج', 'لحم مفروم', 'جبنة'],
              ),
              MenuItem(
                name: 'Pizza Végétarienne',
                nameEn: 'Vegetarian Pizza',
                nameAr: 'بيتزا نباتية',
                description: 'Sauce tomate, Poivrons, Champignon, Maïs',
                descriptionEn: 'Tomato sauce, Peppers, Mushrooms, Corn',
                descriptionAr: 'صلصة طماطم، فلفل، فطر، ذرة',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Poivrons', 'Champignons', 'Maïs'],
                ingredientsEn: ['Pizza dough', 'Tomato sauce', 'Peppers', 'Mushrooms', 'Corn'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة طماطم', 'فلفل', 'فطر', 'ذرة'],
              ),
              MenuItem(
                name: 'Pizza 4 Fromages',
                nameEn: '4 Cheeses Pizza',
                nameAr: 'بيتزا 4 جبنة',
                description: 'Cheddar, Mozzarella, Gouda, Camembert',
                descriptionEn: 'Cheddar, Mozzarella, Gouda, Camembert',
                descriptionAr: 'شيدر، موزاريلا، غودا، كاممبرت',
                price: 700,
                ingredients: ['Pâte à pizza', 'Cheddar', 'Mozzarella', 'Gouda', 'Camembert'],
                ingredientsEn: ['Pizza dough', 'Cheddar', 'Mozzarella', 'Gouda', 'Camembert'],
                ingredientsAr: ['عجينة بيتزا', 'شيدر', 'موزاريلا', 'غودا', 'كاممبرت'],
              ),
              MenuItem(
                name: 'Pizza Poulet Fumé',
                nameEn: 'Smoked Chicken Pizza',
                nameAr: 'بيتزا دجاج مدخن',
                description: 'Sauce blanche, Poulet fumé, Cheddar, Mozzarella',
                descriptionEn: 'White sauce, Smoked chicken, Cheddar, Mozzarella',
                descriptionAr: 'صلصة بيضاء، دجاج مدخن، شيدر، موزاريلا',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce blanche', 'Poulet fumé', 'Cheddar', 'Mozzarella'],
                ingredientsEn: ['Pizza dough', 'White sauce', 'Smoked chicken', 'Cheddar', 'Mozzarella'],
                ingredientsAr: ['عجينة بيتزا', 'صلصة بيضاء', 'دجاج مدخن', 'شيدر', 'موزاريلا'],
              ),
              MenuItem(
                name: 'Pizza MEGA Mix',
                nameEn: 'MEGA Mix Pizza',
                nameAr: 'بيتزا ميكس كبير',
                description: 'Viande hachée, Poulet, Thon, Fromage',
                descriptionEn: 'Minced meat, Chicken, Tuna, Cheese',
                descriptionAr: 'لحم مفروم، دجاج، تونة، جبنة',
                price: 1800,
                ingredients: ['Pâte à pizza double', 'Viande hachée', 'Poulet', 'Thon', 'Fromage'],
                ingredientsEn: ['Double pizza dough', 'Minced meat', 'Chicken', 'Tuna', 'Cheese'],
                ingredientsAr: ['عجينة بيتزا مزدوجة', 'لحم مفروم', 'دجاج', 'تونة', 'جبنة'],
              ),
              MenuItem(
                name: 'Pizza MEGA Angora',
                nameEn: 'MEGA Angora Pizza',
                nameAr: 'بيتزا أنقورا كبير',
                description: 'Doublé: VH, Poulet, Poulet fumé, Fromage',
                descriptionEn: 'Double: Minced meat, Chicken, Smoked chicken, Cheese',
                descriptionAr: 'مزدوجة: لحم مفروم، دجاج، دجاج مدخن، جبنة',
                price: 2000,
                ingredients: ['Pâte à pizza double', 'Viande hachée', 'Poulet', 'Poulet fumé', 'Fromage'],
                ingredientsEn: ['Double pizza dough', 'Minced meat', 'Chicken', 'Smoked chicken', 'Cheese'],
                ingredientsAr: ['عجينة بيتزا مزدوجة', 'لحم مفروم', 'دجاج', 'دجاج مدخن', 'جبنة'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Tacos',
            nameEn: 'Tacos',
            nameAr: 'تاكوس',
            items: [
              MenuItem(
                name: 'Tacos Poulet',
                nameEn: 'Chicken Tacos',
                nameAr: 'تاكوس دجاج',
                description: 'Poulet, Frites, Fromage, Sauce',
                descriptionEn: 'Chicken, Fries, Cheese, Sauce',
                descriptionAr: 'دجاج، بطاطا مقلية، جبنة، صلصة',
                price: 400,
                ingredients: ['Tortilla', 'Poulet grillé', 'Frites', 'Fromage', 'Sauce'],
                ingredientsEn: ['Tortilla', 'Grilled chicken', 'Fries', 'Cheese', 'Sauce'],
                ingredientsAr: ['تورتيلا', 'دجاج مشوي', 'بطاطا مقلية', 'جبنة', 'صلصة'],
              ),
              MenuItem(
                name: 'Tacos Viande Hachée',
                nameEn: 'Minced Meat Tacos',
                nameAr: 'تاكوس لحم مفروم',
                description: 'Viande hachée, Frites, Fromage, Sauce',
                descriptionEn: 'Minced meat, Fries, Cheese, Sauce',
                descriptionAr: 'لحم مفروم، بطاطا مقلية، جبنة، صلصة',
                price: 500,
                ingredients: ['Tortilla', 'Viande hachée', 'Frites', 'Fromage', 'Sauce'],
                ingredientsEn: ['Tortilla', 'Minced meat', 'Fries', 'Cheese', 'Sauce'],
                ingredientsAr: ['تورتيلا', 'لحم مفروم', 'بطاطا مقلية', 'جبنة', 'صلصة'],
              ),
              MenuItem(
                name: 'Tacos Mix',
                nameEn: 'Mix Tacos',
                nameAr: 'تاكوس ميكس',
                description: 'Viande hachée, Poulet, Frites, Fromage, Sauce',
                descriptionEn: 'Minced meat, Chicken, Fries, Cheese, Sauce',
                descriptionAr: 'لحم مفروم، دجاج، بطاطا مقلية، جبنة، صلصة',
                price: 700,
                ingredients: ['Tortilla', 'Viande hachée', 'Poulet', 'Frites', 'Fromage', 'Sauce'],
                ingredientsEn: ['Tortilla', 'Minced meat', 'Chicken', 'Fries', 'Cheese', 'Sauce'],
                ingredientsAr: ['تورتيلا', 'لحم مفروم', 'دجاج', 'بطاطا مقلية', 'جبنة', 'صلصة'],
              ),
            ],
          ),
        ],
      ),
    ];
