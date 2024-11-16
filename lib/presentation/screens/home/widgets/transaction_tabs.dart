// lib/presentation/screens/home/widgets/transaction_tabs.dart
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/home/widgets/lists/favorites_list.dart';
import 'package:wave_app/presentation/screens/home/widgets/transaction_tab.dart';
import 'package:wave_app/presentation/screens/home/widgets/transactions_list.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class TransactionTabs extends StatefulWidget {
  const TransactionTabs({super.key});

  @override
  State<TransactionTabs> createState() => _TransactionTabsState();
}

class _TransactionTabsState extends State<TransactionTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildTabBar(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TabBarView(
              controller: _tabController,
              children: const [
                TransactionsList(),
                FavoritesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        HomeScreenStyles.defaultSpacing,
        HomeScreenStyles.largeSpacing,
        HomeScreenStyles.defaultSpacing,
        0,
      ),
      decoration: HomeScreenStyles.tabContainerDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: HomeScreenStyles.tabLabelStyle,
          tabs: const [
            TransactionTab(
              title: "Transactions",
              icon: Icons.swap_horiz,
              badgeCount: 5,
            ),
            TransactionTab(
              title: "Favoris",
              icon: Icons.favorite,
              badgeCount: 2,
            ),
          ],
        ),
      ),
    );
  }
}