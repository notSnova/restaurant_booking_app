class MenuPackage {
  // class to hold details of each menu
  final String name;
  final String description;
  final String imageUrl;
  final List<String> menuItems;
  final List<String> additionalItems;

  MenuPackage({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.menuItems,
    required this.additionalItems,
  });
}

// menu packages
final List<MenuPackage> menuPackages = [
  MenuPackage(
    name: 'Buffet Package',
    description: 'A variety of food options with unlimited food refills',
    imageUrl: 'assets/buffet.jpg',
    menuItems: [
      'Local Delights',
      'Salad & Appetiser',
      'Soup',
      'Pasta',
      'Pizza',
      'Eggs Dishes',
      'Sandwiches & Burgers',
    ],
    additionalItems: [
      'Chinese Comfort Food',
      'Seafood',
      'Grill Food',
      'Desserts',
    ],
  ),
];
