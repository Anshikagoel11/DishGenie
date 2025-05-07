import 'package:dishgenie/screens/aichat.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;

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
      'title': 'Spicy Paneer ',
      'calories': '330 cal',
      'rating': 4.7,
      'reviewCount': 105,
      'quote': '"Vegetarian delight with a kick!"'
    },
  ];

  // Sample recipes data
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('DishGenie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
                                  child: const Icon(Icons.fastfood, size: 50),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        const Icon(Icons.local_fire_department,
                                            size: 16, color: Colors.white),
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
                                ? theme.colorScheme.primary
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

//ai chatbot column
            Column(
              children: [
                // Animated Orange Button Heading
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[300],
                              foregroundColor:
                                  const Color.fromARGB(255, 54, 54, 54),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Slightly rounded
                              ),
                              elevation: 4,
                              shadowColor: Colors.orange.withOpacity(0.2),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'Ask Our Recipe Genie',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Image with Button Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background image container
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/ai2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.orange.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Floating Action Button
                      Positioned(
                        bottom: 20,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecipeAIBotScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 90, 90, 88),
                            foregroundColor:
                                const Color.fromARGB(255, 234, 191, 91),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(6), // Minimal rounding
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 10),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 20),
                          label: const Text(
                            'Chat with Genie',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
                              color: theme.colorScheme.onBackground,
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
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Show only 2 recipe cards on home screen
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
                              ),
                            )),
                  ),

                  // Beautiful "View All" button
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
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text(
                        'View All Recipes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Seasonal recipes section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Seasonal Vegetable Recipes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: RecipeCard(
                            title: 'Seasonal Veg ${index + 1}',
                            calories: '${160 + index * 40} cal',
                            time: '${12 + index * 5} mins',
                            rating: 4.0 + (index * 0.15),
                            imageUrl: 'assets/images/seasonal${index + 1}.jpg',
                            width: 150,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Ask to AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AllRecipesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  const AllRecipesScreen({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Show all recipes in a column
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recipes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return ExpandableRecipeCard(
                  title: recipes[index]['title'],
                  calories: recipes[index]['calories'],
                  time: recipes[index]['time'],
                  rating: recipes[index]['rating'],
                  imageUrl: recipes[index]['image'],
                  ingredients: recipes[index]['ingredients'],
                  instructions: recipes[index]['instructions'],
                );
              },
            ),
          ],
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

  const ExpandableRecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.time,
    required this.rating,
    required this.imageUrl,
    this.ingredients,
    this.instructions,
  });

  @override
  State<ExpandableRecipeCard> createState() => _ExpandableRecipeCardState();
}

class _ExpandableRecipeCardState extends State<ExpandableRecipeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Image and Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 40),
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
                          color: theme.colorScheme.onBackground,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 14,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            widget.calories,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 14,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rating
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
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

            // Short Description (always visible)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'A delicious ${widget.title.toLowerCase()} that can be prepared in just ${widget.time}. Perfect for quick meals!',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onBackground.withOpacity(0.8),
                ),
              ),
            ),

            // Expandable Content
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text(
                'Ingredients:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.ingredients
                        ?.map((ingredient) => Text(
                              '• $ingredient',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.8),
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
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.instructions
                        ?.asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${entry.key + 1}. ${entry.value}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.8),
                                ),
                              ),
                            ))
                        .toList() ??
                    [],
              ),
            ],

            // View More/Less Button
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
                    color: theme.colorScheme.primary,
                    fontSize: 12,
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

class RecipeCard extends StatelessWidget {
  final String title;
  final String calories;
  final String time;
  final double rating;
  final String imageUrl;
  final double? width;

  const RecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.time,
    required this.rating,
    required this.imageUrl,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imageUrl,
                height: width == null ? 120 : 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: width == null ? 120 : 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14,
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(time,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.6),
                          )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 14,
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(calories,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.6),
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
