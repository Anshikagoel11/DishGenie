import 'package:dishgenie/screens/feed.dart';
import 'package:dishgenie/screens/postRecipe.dart';
import 'package:dishgenie/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:dishgenie/screens/aichat.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  int _currentNavIndex = 0;
  late AnimationController _navAnimationController;
  late Animation<double> _navAnimation;

  // Define orange color palette
  final Color _primaryOrange = const Color(0xFFFF6D00);
  final Color _lightOrange = const Color(0xFFFF9E40);
  final Color _darkOrange = const Color(0xFFFF3D00);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _textColor = const Color(0xFF333333);

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': "assets/images/nonveg.png",
      'title': 'non-veg',
      'calories': '450 cal',
      'rating': 4.8,
      'reviewCount': 152,
      'quote': '"A wholesome experience!"'
    },
    {
      'image': "assets/images/salad2.png",
      'title': 'Rainbow Summer Salad',
      'calories': '210 cal',
      'rating': 4.9,
      'reviewCount': 134,
      'quote': '"Colorful, crunchy, and refreshing!"'
    },
    {
      'image': "assets/images/meal.png",
      'title': 'Grilled Chicken Meal',
      'calories': '320 cal',
      'rating': 4.6,
      'reviewCount': 87,
      'quote': '"Protein-packed and satisfying"'
    },
    {
      'image': "assets/images/sweet.png",
      'title': 'gulab jamun',
      'calories': '390 cal',
      'rating': 4.7,
      'reviewCount': 98,
      'quote': '"Rich, tender, and flavorful"'
    },
    {
      'image': "assets/images/pastry.png",
      'title': 'Mixed Berry Pastry',
      'calories': '290 cal',
      'rating': 4.4,
      'reviewCount': 70,
      'quote': '"A sweet and fruity indulgence"'
    },
    {
      'image': "assets/images/paneer.png",
      'title': 'Spicy Paneer',
      'calories': '330 cal',
      'rating': 4.7,
      'reviewCount': 105,
      'quote': '"Vegetarian delight with a kick!"'
    },
  ];

  final List<Map<String, dynamic>> _quickRecipes = [
    {
      'title': 'Avocado Toast',
      'calories': '220 cal',
      'time': '5 mins',
      'rating': 4.3,
      'image': 'assets/images/avocado_toast.png',
      'ingredients': [
        '2 slices whole grain bread',
        '1 ripe avocado',
        '1 tbsp lemon juice',
        'Salt and pepper to taste',
        'Red pepper flakes (optional)',
        '2 eggs (optional)'
      ],
      'instructions': [
        'Toast the bread until golden and crisp',
        'Mash the avocado with lemon juice, salt and pepper',
        'Spread the avocado mixture on the toast',
        'Add optional toppings like eggs or red pepper flakes',
        'Serve immediately'
      ]
    },
    {
      'title': 'Peanut Butter Banana Toast',
      'calories': '280 cal',
      'time': '3 mins',
      'rating': 4.2,
      'image': 'assets/images/toast.png',
      'ingredients': [
        '2 slices whole wheat bread',
        '2 tbsp peanut butter',
        '1 banana, sliced',
        '1 tsp honey',
        'Pinch of cinnamon'
      ],
      'instructions': [
        'Toast the bread',
        'Spread peanut butter on toast',
        'Top with banana slices',
        'Drizzle with honey and sprinkle cinnamon',
        'Serve immediately'
      ]
    },
    {
      'title': 'Berry Smoothie',
      'calories': '180 cal',
      'time': '3 mins',
      'rating': 4.5,
      'image': 'assets/images/smoothie.png',
      'ingredients': [
        '1 cup mixed berries (fresh or frozen)',
        '1 banana',
        '1 cup almond milk',
        '1 tbsp honey',
        '1 tsp chia seeds'
      ],
      'instructions': [
        'Add all ingredients to a blender',
        'Blend until smooth',
        'Add more milk if too thick',
        'Pour into a glass and enjoy'
      ]
    },
    {
      'title': 'Veggie Omelette',
      'calories': '250 cal',
      'time': '8 mins',
      'rating': 4.6,
      'image': 'assets/images/omelette.png',
      'ingredients': [
        '2 eggs',
        '1/4 cup diced bell peppers',
        '1/4 cup diced onions',
        '1/4 cup chopped spinach',
        '1 tbsp olive oil',
        'Salt and pepper to taste'
      ],
      'instructions': [
        'Heat oil in a pan over medium heat',
        'Sauté vegetables for 2-3 minutes',
        'Whisk eggs with salt and pepper',
        'Pour eggs over vegetables',
        'Cook until set, then fold and serve'
      ]
    },
    {
      'title': 'Greek Yogurt Parfait',
      'calories': '200 cal',
      'time': '2 mins',
      'rating': 4.4,
      'image': 'assets/images/parfait.png',
      'ingredients': [
        '1 cup Greek yogurt',
        '1/2 cup granola',
        '1/2 cup mixed berries',
        '1 tbsp honey'
      ],
      'instructions': [
        'Layer yogurt, granola and berries in a glass',
        'Drizzle with honey',
        'Repeat layers',
        'Serve immediately'
      ]
    },
    {
      'title': 'Caprese Sandwich',
      'calories': '320 cal',
      'time': '7 mins',
      'rating': 4.7,
      'image': 'assets/images/sandwich.png',
      'ingredients': [
        '2 slices ciabatta bread',
        '1 large tomato, sliced',
        '4 oz fresh mozzarella',
        'Fresh basil leaves',
        '1 tbsp balsamic glaze',
        '1 tbsp olive oil'
      ],
      'instructions': [
        'Brush bread with olive oil and toast lightly',
        'Layer tomato, mozzarella and basil on bread',
        'Drizzle with balsamic glaze',
        'Close sandwich and serve'
      ]
    },
    {
      'title': 'Oatmeal with Nuts',
      'calories': '300 cal',
      'time': '5 mins',
      'rating': 4.3,
      'image': 'assets/images/oatmeal.png',
      'ingredients': [
        '1/2 cup rolled oats',
        '1 cup milk or water',
        '1 tbsp honey',
        '1 tbsp chopped nuts',
        '1/2 tsp cinnamon'
      ],
      'instructions': [
        'Bring milk/water to a boil',
        'Add oats and reduce heat',
        'Cook for 3-4 minutes, stirring occasionally',
        'Top with honey, nuts and cinnamon',
        'Serve warm'
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _autoScrollCarousel();
    _navAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _navAnimation = CurvedAnimation(
      parent: _navAnimationController,
      curve: Curves.easeInOut,
    );
    _navAnimationController.forward();
  }

  void _autoScrollCarousel() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentCarouselIndex < _carouselItems.length - 1) {
        _carouselController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _carouselController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _autoScrollCarousel();
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _navAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(
          primary: _primaryOrange,
          secondary: _lightOrange,
          surface: Colors.white,
          background: _backgroundColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: _textColor,
          onBackground: _textColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: _textColor),
          titleTextStyle: TextStyle(
            color: _textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: _primaryOrange,
          unselectedItemColor: Colors.grey[600],
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: const Text('DishGenie'),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: _textColor),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Carousel Section
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _carouselController,
                      itemCount: _carouselItems.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = _carouselItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Image.asset(
                                  item['image'],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.fastfood,
                                        size: 50, color: _primaryOrange),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.local_fire_department,
                                              size: 16,
                                              color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['calories'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.star,
                                              size: 16, color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item['rating']} (${item['reviewCount']})',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['quote'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _carouselItems.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselIndex == index
                                  ? _primaryOrange
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // AI Chatbot Section
              Column(
                children: [
                  // Orange Gradient Card for "Ask Our Recipe Genie"
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _lightOrange,
                          _primaryOrange,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryOrange.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeAIBotScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome,
                                  size: 24, color: Colors.white),
                              const SizedBox(width: 12),
                              Text(
                                'Ask Our Recipe Genie',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // AI Chat Image Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/ai2.png',
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  _primaryOrange.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeAIBotScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: _primaryOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 8),
                                  elevation: 4,
                                ),
                                icon: Icon(Icons.chat, size: 17),
                                label: Text(
                                  'Chat with AI Chef',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recipes Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Recipes You Can Make Now',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllRecipesScreen(recipes: _quickRecipes),
                                ),
                              );
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: _primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recipe Cards
                    Column(
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: RecipeCard(
                            title: _quickRecipes[index]['title'],
                            calories: _quickRecipes[index]['calories'],
                            time: _quickRecipes[index]['time'],
                            rating: _quickRecipes[index]['rating'],
                            imageUrl: _quickRecipes[index]['image'],
                            primaryColor: _primaryOrange,
                          ),
                        ),
                      ),
                    ),

                    // View All Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllRecipesScreen(recipes: _quickRecipes),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _lightOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26, vertical: 12),
                          elevation: 2,
                          shadowColor: _primaryOrange.withOpacity(0.3),
                        ),
                        child: const Text(
                          'View All Recipes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: _navAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - _navAnimation.value) * 50),
              child: Opacity(
                opacity: _navAnimation.value,
                child: child,
              ),
            );
          },
          child: BottomNavigationBar(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });

              switch (index) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeAIBotScreen(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostRecipeScreen(email: widget.email),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecipeFeedScreen(),
                    ),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                  break;
              }

              _navAnimationController.reset();
              _navAnimationController.forward();
            },
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.home,
                    key: ValueKey<bool>(_currentNavIndex == 0),
                    color: _currentNavIndex == 0
                        ? _primaryOrange
                        : Colors.grey[600],
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chat_bubble,
                    key: ValueKey<bool>(_currentNavIndex == 1),
                    color: _currentNavIndex == 1
                        ? _primaryOrange
                        : Colors.grey[600],
                  ),
                ),
                label: 'Ask Genie',
              ),
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.smart_button,
                    key: ValueKey<bool>(_currentNavIndex == 2),
                    color: _currentNavIndex == 2
                        ? _primaryOrange
                        : Colors.grey[600],
                  ),
                ),
                label: 'Posts',
              ),
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chat_sharp,
                    key: ValueKey<bool>(_currentNavIndex == 3),
                    color: _currentNavIndex == 3
                        ? _primaryOrange
                        : Colors.grey[600],
                  ),
                ),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.person,
                    key: ValueKey<bool>(_currentNavIndex == 4),
                    color: _currentNavIndex == 3
                        ? _primaryOrange
                        : Colors.grey[600],
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String calories;
  final String time;
  final double rating;
  final String imageUrl;
  final double? width;
  final Color primaryColor;

  const RecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.time,
    required this.rating,
    required this.imageUrl,
    this.width,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with orange overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imageUrl,
                    height: width == null ? 140 : 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: width == null ? 140 : 120,
                      color: Colors.grey[200],
                      child:
                          Icon(Icons.fastfood, size: 40, color: primaryColor),
                    ),
                  ),
                ),
                Container(
                  height: width == null ? 140 : 120,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        primaryColor.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          )),
                      const Spacer(),
                      Icon(Icons.local_fire_department,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(calories,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllRecipesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  const AllRecipesScreen({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final Color primaryOrange = const Color(0xFFFF6D00);
    final Color textColor = const Color(0xFF333333);
    final Color lightBackground = const Color(0xFFF5F5F5);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryOrange,
              secondary: const Color(0xFFFF9E40),
            ),
      ),
      child: Scaffold(
        backgroundColor: lightBackground,
        appBar: AppBar(
          title: Text(
            'All Recipes',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search bar with orange accent
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: Icon(Icons.search, color: primaryOrange),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              // Recipe list with orange theme
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recipes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return ExpandableRecipeCard(
                    title: recipes[index]['title'],
                    calories: recipes[index]['calories'],
                    time: recipes[index]['time'],
                    rating: recipes[index]['rating'],
                    imageUrl: recipes[index]['image'],
                    ingredients: recipes[index]['ingredients'],
                    instructions: recipes[index]['instructions'],
                    primaryColor: primaryOrange,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableRecipeCard extends StatefulWidget {
  final String title;
  final String calories;
  final String time;
  final double rating;
  final String imageUrl;
  final List<String>? ingredients;
  final List<String>? instructions;
  final Color primaryColor;

  const ExpandableRecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.time,
    required this.rating,
    required this.imageUrl,
    this.ingredients,
    this.instructions,
    required this.primaryColor,
  });

  @override
  State<ExpandableRecipeCard> createState() => _ExpandableRecipeCardState();
}

class _ExpandableRecipeCardState extends State<ExpandableRecipeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Image and Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Image with orange border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.asset(
                      widget.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: Icon(Icons.fastfood,
                            size: 40, color: widget.primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.local_fire_department,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            widget.calories,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rating with orange background
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.white),
                      const SizedBox(width: 2),
                      Text(
                        widget.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Expandable Content
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'Ingredients:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.ingredients
                        ?.map((ingredient) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '• ',
                                    style: TextStyle(
                                      color: widget.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ingredient,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList() ??
                    [],
              ),
              const SizedBox(height: 12),
              Text(
                'Instructions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.instructions
                        ?.asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${entry.key + 1}. ',
                                    style: TextStyle(
                                      color: widget.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList() ??
                    [],
              ),
            ],

            // View More/Less Button with orange color
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  _isExpanded ? 'View Less' : 'View More',
                  style: TextStyle(
                    color: widget.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
