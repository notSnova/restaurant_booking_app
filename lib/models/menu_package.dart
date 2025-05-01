class MenuPackage {
  // class to hold details of each menu
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> menuItems;
  final Map<String, double> additionalItems;

  MenuPackage({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.menuItems,
    required this.additionalItems,
  });
}

// menu packages
final List<MenuPackage> menuPackages = [
  MenuPackage(
    name: 'Buffet Package',
    description:
        'Enjoy a premium buffet experience featuring a wide variety of local favorites and international selections. From hearty soups and pastas to fresh salads, seafood, and indulgent desserts. Perfect for someone who crave both comfort and variety, all with unlimited refills.',
    price: 49.90,
    imageUrl: 'assets/buffet.jpg',
    menuItems: [
      'Local Delights',
      'Eggs Dishes',
      'Pasta',
      'Pizza',
      'Soup',
      'Salad & Appetiser',
      'Sandwiches & Burgers',
    ],
    additionalItems: {
      'Grill Food': 8.00,
      'Chinese Food': 5.00,
      'Seafood': 8.00,
      'Desserts': 3.00,
    },
  ),
  MenuPackage(
    name: 'Seafood Package',
    description:
        'A premium selection of the freshest seafood delights, served with gourmet sides and crafted sauces. Ideal for seafood lovers who crave quality and indulgence.',
    price: 69.90,
    imageUrl: 'assets/seafood.jpg',
    menuItems: [
      'Butter Garlic Lobster',
      'Creamy Seafood Pasta',
      'Calamari Rings',
      'Fresh Oysters',
      'Fish & Chips',
      'Seafood Fried Rice',
      'Grilled Prawns',
      'Grilled Squid',
    ],
    additionalItems: {
      'Black Pepper Clam': 10.00,
      'Mango Sticky Rice': 5.00,
      'Steamed Scallops': 8.00,
      'Mussel Soup': 5.00,
      'Tempura Crab': 5.00,
    },
  ),
  MenuPackage(
    name: 'Western Package',
    description:
        'Enjoy a satisfying Western-style meal with all-time favorites like juicy steaks, creamy pasta, and delicious burgers. Perfect for comfort food cravings, this meal offers a hearty and flavorful experience to please everyone.',
    price: 59.50,
    imageUrl: 'assets/western.jpg',
    menuItems: [
      'Spaghetti Bolognese',
      'BBQ Chicken Wings',
      'Sirloin Steak',
      'Caesar Salad',
      'Cheese Burgers',
      'Garlic Bread',
      'French Fries',
      'Mushroom Soup',
    ],
    additionalItems: {
      'Mashed Potatoes': 5.00,
      'Mac & Cheese': 7.00,
      'Tiramisu': 3.00,
      'Chocolate Cake': 10.00,
    },
  ),
  MenuPackage(
    name: 'Asian Fusion',
    description:
        'Enjoy a flavorful journey across Asia with a delightful blend of local and regional delicacies. This package combines the richness of traditional tastes with a touch of modern presentation, offering an authentic yet refined dining experience.',
    price: 45.50,
    imageUrl: 'assets/asian.jpg',
    menuItems: [
      'Thai Green Curry',
      'Tom Yum Soup',
      'Sushi Rolls',
      'Dim Sum',
      'Vietnamese Spring Rolls',
      'Fried Rice with Satay',
      'Korean Fried Chicken',
    ],
    additionalItems: {
      'Chinese Egg Tarts': 4.00,
      'Mango Pudding': 4.00,
      'Fried Banana': 5.00,
      'Japanese Miso Soup': 5.00,
    },
  ),
];
