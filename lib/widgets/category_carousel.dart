import 'package:book_store_mobile/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCarousel extends StatefulWidget {
  const CategoryCarousel({super.key});

  @override
  State<CategoryCarousel> createState() => _CategoryCarouselState();
}

class _CategoryCarouselState extends State<CategoryCarousel> {
  late PageController _pageController;
  late BookProvider bookProvider;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.4);
    bookProvider = Provider.of<BookProvider>(context, listen: false);

    _pageController.addListener(() {
      double? page = _pageController.page;
      if (page != null) {
        bookProvider.currentPos = page;
        if (page == 0) {
          bookProvider.fetchBooks();
        } else if (page == page.toInt()) {
          bookProvider.fetchBooksByCategory();
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final categories = bookProvider.categories;

    return SizedBox(
      height: 215,
      child: PageView.builder(
        controller: _pageController,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0;
              if (_pageController.hasClients) {
                double page =
                    _pageController.page ??
                    _pageController.initialPage.toDouble();
                value = page - index;
              }

              // Scale từ 0.7 -> 1.0
              double scale = (1 - value.abs() * 0.3).clamp(0.7, 1.0);

              // Góc xoay nhẹ, ví dụ -0.2 đến 0.2 radian (~11 độ)
              double rotation = value * 0.2;

              final category = categories[index];

              return Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(scale)
                    ..rotateZ(rotation),
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Image.network(
                              category.cover_url,
                              width: 120,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
