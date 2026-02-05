import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/locator.dart';
import '../../domain/repositories/supplement_repository.dart';

import '../navigation/app_router.dart';
import '../theme/app_theme.dart';
import '../../domain/entities/supplement.dart';

class GlobalSearchDelegate extends SearchDelegate<dynamic> {
  final _supplementRepository = locator<SupplementRepository>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: GoogleFonts.lexend(color: Colors.grey),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: GoogleFonts.lexend(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder(
      future: _supplementRepository.searchSupplements(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error searching: ${snapshot.error}',
              style: GoogleFonts.lexend(),
            ),
          );
        }

        final supplements = snapshot.data as List<Supplement>? ?? [];

        if (supplements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No results found for "$query"',
                  style: GoogleFonts.lexend(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (supplements.isNotEmpty) ...[
              Text(
                'Supplements',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ...supplements.map((s) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors.primaryGold.withValues(alpha: 0.2),
                      child: const Icon(Icons.medication,
                          color: AppColors.primaryGold, size: 20),
                    ),
                    title: Text(s.name, style: GoogleFonts.lexend()),
                    subtitle: Text(s.category, style: GoogleFonts.lexend()),
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.supplementDetail,
                          arguments: s);
                    },
                  )),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Basic suggestion: Help text
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Search for supplements',
            style: GoogleFonts.lexend(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
