import 'package:community_marketplace/theme/color_schemas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:community_marketplace/widgets/floating_navigation_bar.dart';
import 'package:community_marketplace/providers/search_provider.dart';

class ItemSearchScreen extends StatelessWidget {
  const ItemSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: const _ItemSearchContent(),
    );
  }
}

class _ItemSearchContent extends StatelessWidget {
  const _ItemSearchContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Top Navigation Bar
                  _buildTopNavigationBar(context, provider),

                  // Content
                  Expanded(
                    child: provider.isSearchActive
                        ? _buildSearchSuggestions(context, provider)
                        : _buildTabContent(context, provider),
                  ),
                ],
              ),
            ),
            floatingActionButton: const FloatingNavigationBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }

  Widget _buildTopNavigationBar(BuildContext context, SearchProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFA4D9FF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 40),
            ),
          ),

          const SizedBox(width: 8),

          // Search bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: TextField(
                controller: provider.searchController,
                focusNode: provider.searchFocusNode,
                onSubmitted: provider.performSearch,
                decoration: InputDecoration(
                  hintText: 'ค้นหาอะไรอยู่',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  suffixIcon: provider.searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: provider.clearSearch,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[500],
                            size: 18,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, SearchProvider provider) {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: const Color(0xFFA4D9FF),
          child: TabBar(
            onTap: provider.setTabIndex,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.black,
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'ล่าสุด'),
              Tab(text: 'หมวดหมู่ทั้งหมด'),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            children: [
              _buildLatestTab(context, provider),
              _buildAllCategoriesTab(context, provider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLatestTab(BuildContext context, SearchProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History
          if (provider.searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'การค้นหาล่าสุด',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: provider.clearSearchHistory,
                  child: Text(
                    'ล้างทั้งหมด',
                    style: TextStyle(color: AppColors.primary, fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ...provider.searchHistory.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => provider.performSearch(item),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => provider.removeSearchHistoryItem(item),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],

          // Popular Categories
          const Text(
            'หมวดหมู่ยอดนิยมสูงสุด',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.popularCategories
                .map(
                  (category) => _buildCategoryChip(
                    context,
                    provider,
                    category,
                    isPopular: true,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCategoriesTab(BuildContext context, SearchProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...provider.allCategories.map(
            (category) =>
                _buildCategoryRow(context, provider, category, circleSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    SearchProvider provider,
    String category, {
    bool isPopular = false,
  }) {
    return GestureDetector(
      onTap: () => provider.selectCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPopular
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPopular
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 14,
            color: isPopular ? AppColors.primary : Colors.black87,
            fontWeight: isPopular ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    SearchProvider provider,
    String category, {
    double circleSize = 10,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => provider.selectCategory(category),
        child: Row(
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                category,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions(
    BuildContext context,
    SearchProvider provider,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (provider.searchSuggestions.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.searchSuggestions.length + 1,
                itemBuilder: (context, index) {
                  if (index < provider.searchSuggestions.length) {
                    final suggestion = provider.searchSuggestions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      title: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.north_west,
                        color: Colors.grey,
                        size: 16,
                      ),
                      onTap: () => provider.selectSearchSuggestion(suggestion),
                    );
                  } else {
                    // "View all results" section directly under last suggestion
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: GestureDetector(
                        onTap: () => provider.performSearch(
                          provider.searchController.text,
                        ),
                        child: Text(
                          'ดูผลลัพธ์ทั้งหมดของ ${provider.searchController.text}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ] else ...[
            // "View all results" section when no suggestions but has search text
            if (provider.searchController.text.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () =>
                      provider.performSearch(provider.searchController.text),
                  child: Text(
                    'ดูผลลัพธ์ทั้งหมดของ ${provider.searchController.text}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            // Show message when no suggestions
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'เริ่มพิมพ์เพื่อค้นหา',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
          // Search suggestions header when showing suggestions
          if (provider.searchSuggestions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Text(
                    'คำแนะนำในการค้นหาของ ${provider.searchController.text}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
