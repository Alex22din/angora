import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class MenuItem {
  String id;
  String name;
  String? description;
  int? price;
  bool isMultiPriced;
  Map<String, int>? prices;
  List<String>? ingredients;
  String? imageUrl;

  MenuItem({
    String? id,
    required this.name,
    this.description,
    this.price,
    this.isMultiPriced = false,
    this.prices,
    this.ingredients,
    this.imageUrl,
  }) : id = id ?? _uuid.v4();

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
        'description': description,
        'price': price,
        'isMultiPriced': isMultiPriced,
        'prices': prices,
        'ingredients': ingredients,
        'imageUrl': imageUrl,
      };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as String?,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: json['price'] as int?,
        isMultiPriced: json['isMultiPriced'] as bool? ?? false,
        prices: (json['prices'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, v as int),
        ),
        ingredients: (json['ingredients'] as List<dynamic>?)?.cast<String>(),
        imageUrl: json['imageUrl'] as String?,
      );

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    bool? isMultiPriced,
    Map<String, int>? prices,
    List<String>? ingredients,
    String? imageUrl,
  }) =>
      MenuItem(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        isMultiPriced: isMultiPriced ?? this.isMultiPriced,
        prices: prices ?? this.prices,
        ingredients: ingredients ?? this.ingredients,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

class MenuSubcategory {
  String id;
  String name;
  List<MenuItem> items;

  MenuSubcategory({
    String? id,
    required this.name,
    required this.items,
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((i) => i.toJson()).toList(),
      };

  factory MenuSubcategory.fromJson(Map<String, dynamic> json) => MenuSubcategory(
        id: json['id'] as String?,
        name: json['name'] as String,
        items: (json['items'] as List<dynamic>?)
                ?.map((i) => MenuItem.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class MenuCategory {
  String id;
  String name;
  String icon;
  List<MenuSubcategory>? subcategories;
  List<MenuItem>? items;

  MenuCategory({
    String? id,
    required this.name,
    required this.icon,
    this.subcategories,
    this.items,
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'subcategories': subcategories?.map((s) => s.toJson()).toList(),
        'items': items?.map((i) => i.toJson()).toList(),
      };

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        id: json['id'] as String?,
        name: json['name'] as String,
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
        icon: '🥞',
        subcategories: [
          MenuSubcategory(
            name: 'Crêpes Classiques & Croustillantes',
            items: [
              MenuItem(
                name: 'Chocolat',
                price: 250,
                ingredients: ['Pâte à crêpes', 'Chocolat fondu', 'Beurre'],
              ),
              MenuItem(
                name: 'Un fruit',
                description: 'Banane / Ananas / Fraise / Pêche',
                price: 350,
                ingredients: ['Pâte à crêpes', 'Fruit frais', 'Chocolat', 'Crème'],
              ),
              MenuItem(
                name: 'Deux fruits',
                price: 450,
                ingredients: ['Pâte à crêpes', 'Deux fruits frais', 'Chocolat', 'Crème'],
              ),
              MenuItem(
                name: '03 chocolats',
                price: 500,
                ingredients: ['Pâte à crêpes', 'Chocolat noir', 'Chocolat au lait', 'Chocolat blanc'],
              ),
              MenuItem(
                name: 'Angora',
                price: 600,
                ingredients: ['Pâte à crêpes', 'Chocolat', 'Fruits', 'Crème', 'Noisettes'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Crêpes Croustillantes MEGA',
            items: [
              MenuItem(
                name: 'Chocolat',
                price: 2500,
                ingredients: ['Pâte croustillante', 'Chocolat fondu', 'Beurre', 'Sucre glace'],
              ),
              MenuItem(
                name: 'Aux fruits',
                price: 3000,
                ingredients: ['Pâte croustillante', 'Fruits frais', 'Chocolat', 'Crème', 'Sirop'],
              ),
              MenuItem(
                name: 'Angora',
                price: 5000,
                ingredients: ['Pâte croustillante', 'Chocolat', 'Fruits', 'Crème', 'Noisettes', 'Glace'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Pancakes (à partir de 03 étages)',
            items: [
              MenuItem(
                name: 'Chocolat',
                price: 300,
                ingredients: ['Pâte à pancakes', 'Chocolat fondu', 'Beurre', 'Sirop d\'érable'],
              ),
              MenuItem(
                name: 'Un fruit',
                description: 'Banane / Ananas / Fraise / Pêche',
                price: 400,
                ingredients: ['Pâte à pancakes', 'Fruit frais', 'Chocolat', 'Crème'],
              ),
              MenuItem(
                name: 'Deux fruits',
                price: 450,
                ingredients: ['Pâte à pancakes', 'Deux fruits frais', 'Chocolat', 'Crème'],
              ),
              MenuItem(
                name: '03 chocolats',
                price: 500,
                ingredients: ['Pâte à pancakes', 'Chocolat noir', 'Chocolat au lait', 'Chocolat blanc'],
              ),
              MenuItem(
                name: 'Angora',
                price: 600,
                ingredients: ['Pâte à pancakes', 'Chocolat', 'Fruits', 'Crème', 'Noisettes'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Gaufres',
            items: [
              MenuItem(
                name: 'Chocolat',
                price: 350,
                ingredients: ['Pâte à gaufres', 'Chocolat fondu', 'Beurre', 'Sucre glace'],
              ),
              MenuItem(
                name: 'Un fruit',
                description: 'Banane / Ananas / Fraise / Pêche',
                price: 450,
                ingredients: ['Pâte à gaufres', 'Fruit frais', 'Chocolat', 'Crème'],
              ),
              MenuItem(
                name: 'Deux fruits',
                price: 500,
                ingredients: ['Pâte à gaufres', 'Deux fruits frais', 'Chocolat', 'Crème'],
              ),
              MenuItem(
                name: '03 chocolats',
                price: 550,
                ingredients: ['Pâte à gaufres', 'Chocolat noir', 'Chocolat au lait', 'Chocolat blanc'],
              ),
              MenuItem(
                name: 'Angora',
                price: 650,
                ingredients: ['Pâte à gaufres', 'Chocolat', 'Fruits', 'Crème', 'Noisettes'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Cheesecake',
            items: [
              MenuItem(
                name: 'Bueno',
                price: 350,
                ingredients: ['Base biscuits', 'Crème fraîche', 'Kinder Bueno', 'Chocolat blanc'],
              ),
              MenuItem(
                name: 'Pistachio',
                price: 350,
                ingredients: ['Base biscuits', 'Crème fraîche', 'Pâte de pistache', 'Pistaches'],
              ),
              MenuItem(
                name: 'Dubai',
                price: 350,
                ingredients: ['Base biscuits', 'Crème fraîche', 'Pistache', 'Kunafa', 'Chocolat'],
              ),
              MenuItem(
                name: 'Tiramisu',
                price: 250,
                ingredients: ['Biscuits cuillère', 'Mascarpone', 'Café', 'Cacao'],
              ),
              MenuItem(
                name: 'Verrine',
                price: 250,
                ingredients: ['Biscuits', 'Crème', 'Fruits', 'Chocolat'],
              ),
              MenuItem(
                name: 'Brownies',
                price: 200,
                ingredients: ['Chocolat noir', 'Beurre', 'Sucre', 'Œufs', 'Farine', 'Noix'],
              ),
            ],
          ),
        ],
      ),
      MenuCategory(
        id: 'boissons_chaudes',
        name: 'Boissons Chaudes',
        icon: '☕',
        items: [
          MenuItem(
            name: 'Café noir',
            description: 'Espresso / Capsule',
            isMultiPriced: true,
            prices: {'espresso': 30, 'capsule': 100},
            ingredients: ['Café moulu', 'Eau chaude'],
          ),
          MenuItem(
            name: 'Crème',
            price: 50,
            ingredients: ['Café', 'Lait chaud', 'Crème'],
          ),
          MenuItem(
            name: 'Cappuccino',
            price: 150,
            ingredients: ['Espresso', 'Lait moussu', 'Cacao'],
          ),
          MenuItem(
            name: 'Lait au chocolat',
            price: 150,
            ingredients: ['Lait chaud', 'Chocolat en poudre', 'Sucre'],
          ),
          MenuItem(
            name: 'Thé maison',
            isMultiPriced: true,
            prices: {'petit_verre': 50, 'grand_verre': 70},
            ingredients: ['Thé vert', 'Eau bouillante', 'Menthe'],
          ),
          MenuItem(
            name: 'Maxwell',
            price: 70,
            ingredients: ['Café Maxwell', 'Eau chaude', 'Lait (optionnel)'],
          ),
        ],
      ),
      MenuCategory(
        id: 'boissons_froides',
        name: 'Boissons Froides',
        icon: '🥤',
        subcategories: [
          MenuSubcategory(
            name: 'Mojito',
            items: [
              MenuItem(
                name: 'Classique',
                price: 300,
                ingredients: ['Menthe fraîche', 'Citron vert', 'Sucre', 'Eau gazeuse', 'Glaçons'],
              ),
              MenuItem(
                name: 'Bleu',
                price: 350,
                ingredients: ['Menthe fraîche', 'Citron vert', 'Sirop bleu', 'Eau gazeuse', 'Glaçons'],
              ),
              MenuItem(
                name: 'Rouge',
                price: 350,
                ingredients: ['Menthe fraîche', 'Citron vert', 'Sirop rouge', 'Eau gazeuse', 'Glaçons'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Milkshake',
            items: [
              MenuItem(
                name: 'Nutella',
                price: 400,
                ingredients: ['Lait', 'Nutella', 'Glace vanille', 'Crème'],
              ),
              MenuItem(
                name: 'Bueno',
                price: 450,
                ingredients: ['Lait', 'Kinder Bueno', 'Glace vanille', 'Crème'],
              ),
              MenuItem(
                name: 'Pistachio',
                price: 450,
                ingredients: ['Lait', 'Pâte de pistache', 'Glace vanille', 'Crème'],
              ),
              MenuItem(
                name: 'Oreo / Ferrero Rocher',
                price: 450,
                ingredients: ['Lait', 'Oreo ou Ferrero Rocher', 'Glace vanille', 'Crème'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Jus & Boissons Gazeuses',
            items: [
              MenuItem(
                name: 'Jus pressé',
                description: 'Fruit de saison',
                price: 300,
                ingredients: ['Fruit frais', 'Sucre', 'Eau'],
              ),
              MenuItem(
                name: 'Jus cocktail',
                price: 450,
                ingredients: ['Multiples fruits', 'Sirop', 'Eau', 'Glaçons'],
              ),
              MenuItem(
                name: 'Jus 33cl',
                price: 80,
                ingredients: ['Jus industriel 33cl'],
              ),
              MenuItem(
                name: 'Canette',
                price: 100,
                ingredients: ['Boisson gazeuse 33cl'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Eau Minérale',
            items: [
              MenuItem(
                name: 'Petite format',
                price: 30,
                ingredients: ['Eau minérale 50cl'],
              ),
              MenuItem(
                name: 'Grande format',
                price: 50,
                ingredients: ['Eau minérale 1.5L'],
              ),
            ],
          ),
        ],
      ),
      MenuCategory(
        id: 'pizzas_tacos',
        name: 'Pizzas & Tacos',
        icon: '🍕',
        subcategories: [
          MenuSubcategory(
            name: 'Pizzas',
            items: [
              MenuItem(
                name: 'Pizza Marguerite',
                description: 'Sauce tomate, Cheddar, Olive',
                price: 300,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Cheddar', 'Olives'],
              ),
              MenuItem(
                name: 'Pizza Poulet',
                description: 'Sauce blanche, Poulet, Cheddar, Mozzarella',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce blanche', 'Poulet grillé', 'Cheddar', 'Mozzarella'],
              ),
              MenuItem(
                name: 'Pizza Viande Hachée',
                description: 'Sauce tomate, Viande hachée, Cheddar, Mozzarella',
                price: 400,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Viande hachée', 'Cheddar', 'Mozzarella'],
              ),
              MenuItem(
                name: 'Pizza Thon',
                description: 'Sauce tomate, Thon, Cheddar, Mozzarella',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Thon', 'Cheddar', 'Mozzarella'],
              ),
              MenuItem(
                name: 'Pizza Mix',
                description: 'Sauce tomate, Poulet, Viande hachée, Fromage',
                price: 500,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Poulet', 'Viande hachée', 'Fromage'],
              ),
              MenuItem(
                name: 'Pizza Végétarienne',
                description: 'Sauce tomate, Poivrons, Champignon, Maïs',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce tomate', 'Poivrons', 'Champignons', 'Maïs'],
              ),
              MenuItem(
                name: 'Pizza 4 Fromages',
                description: 'Cheddar, Mozzarella, Gouda, Camembert',
                price: 700,
                ingredients: ['Pâte à pizza', 'Cheddar', 'Mozzarella', 'Gouda', 'Camembert'],
              ),
              MenuItem(
                name: 'Pizza Poulet Fumé',
                description: 'Sauce blanche, Poulet fumé, Cheddar, Mozzarella',
                price: 450,
                ingredients: ['Pâte à pizza', 'Sauce blanche', 'Poulet fumé', 'Cheddar', 'Mozzarella'],
              ),
              MenuItem(
                name: 'Pizza MEGA Mix',
                description: 'Viande hachée, Poulet, Thon, Fromage',
                price: 1800,
                ingredients: ['Pâte à pizza double', 'Viande hachée', 'Poulet', 'Thon', 'Fromage'],
              ),
              MenuItem(
                name: 'Pizza MEGA Angora',
                description: 'Doublé: VH, Poulet, Poulet fumé, Fromage',
                price: 2000,
                ingredients: ['Pâte à pizza double', 'Viande hachée', 'Poulet', 'Poulet fumé', 'Fromage'],
              ),
            ],
          ),
          MenuSubcategory(
            name: 'Tacos',
            items: [
              MenuItem(
                name: 'Tacos Poulet',
                description: 'Poulet, Frites, Fromage, Sauce',
                price: 400,
                ingredients: ['Tortilla', 'Poulet grillé', 'Frites', 'Fromage', 'Sauce'],
              ),
              MenuItem(
                name: 'Tacos Viande Hachée',
                description: 'Viande hachée, Frites, Fromage, Sauce',
                price: 500,
                ingredients: ['Tortilla', 'Viande hachée', 'Frites', 'Fromage', 'Sauce'],
              ),
              MenuItem(
                name: 'Tacos Mix',
                description: 'Viande hachée, Poulet, Frites, Fromage, Sauce',
                price: 700,
                ingredients: ['Tortilla', 'Viande hachée', 'Poulet', 'Frites', 'Fromage', 'Sauce'],
              ),
            ],
          ),
        ],
      ),
    ];
