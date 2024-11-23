import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class DistributorHomeScreen extends StatefulWidget {
  const DistributorHomeScreen({super.key});

  @override
  State<DistributorHomeScreen> createState() => _DistributorHomeScreenState();
}

class _DistributorHomeScreenState extends State<DistributorHomeScreen>
    with SingleTickerProviderStateMixin {
  final currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );

  late TabController _tabController;
  bool _isBalanceVisible = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkFirstLogin();
  }

  void _checkFirstLogin() {
    // Vérifier si c'est la première connexion
    final isFirstLogin = true; // À remplacer par la vraie logique
    if (isFirstLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showChangePasswordDialog();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: HomeScreenStyles.navigationBarTheme,
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreenContent(),
            _buildTransactionHistory(),
            _buildProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  NavigationBar _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Tableau de bord',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Historique',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  Widget _buildHomeScreenContent() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(state),
              _buildQuickActions(),
              _buildTabs(),
              _buildTabContent(),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAppBar(AuthSuccess state) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: HomeScreenStyles.getHeaderGradient(context),
          child: SafeArea(
            child: Padding(
              padding: HomeScreenStyles.defaultScreenPadding,
              child: _buildDistributorInfo(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistributorInfo(AuthSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: HomeScreenStyles.largeSpacing),
            Text(
              'Point de service: ${state.user.prenom}',
              style: HomeScreenStyles.greetingTextStyle,
            ),
            const SizedBox(height: HomeScreenStyles.smallSpacing),
            GestureDetector(
              onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
              child: _buildBalance(state.user.solde),
            ),
          ],
        ),
        _buildProfileAvatar(state.user.photo),
      ],
    );
  }

  Widget _buildBalance(double balance) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isBalanceVisible
                ? currencyFormat.format(balance)
                : '• • • • • • • • • • • •',
            style: HomeScreenStyles.balanceTextStyle,
          ),
          const SizedBox(width: HomeScreenStyles.smallSpacing),
          Icon(
            _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.arrow_upward,
        'label': 'Dépôt',
        'color': Colors.green,
        'onTap': () => _showTransactionForm(isDeposit: true),
      },
      {
        'icon': Icons.arrow_downward,
        'label': 'Retrait',
        'color': Colors.orange,
        'onTap': () => _showTransactionForm(isDeposit: false),
      },
      {
        'icon': Icons.account_circle,
        'label': 'Déplafonner',
        'color': Theme.of(context).primaryColor,
        'onTap': () => _showAccountUnlockForm(),
      },
      {
        'icon': Icons.more_horiz,
        'label': 'Plus',
        'color': Colors.purple,
        'onTap': () {},
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: HomeScreenStyles.defaultSpacing,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions
              .map((action) => _buildQuickActionButton(
                    icon: action['icon'],
                    label: action['label'],
                    color: action['color'],
                    onTap: action['onTap'],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: HomeScreenStyles.getQuickActionDecoration(color),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: HomeScreenStyles.iconSize),
            const SizedBox(height: HomeScreenStyles.smallSpacing),
            Text(
              label,
              style: HomeScreenStyles.quickActionLabelStyle.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Changement de mot de passe requis'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Ancien mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Logique de changement de mot de passe
              Navigator.of(context).pop();
            },
            child: const Text('Changer'),
          ),
        ],
      ),
    );
  }

  void _showTransactionForm({required bool isDeposit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: HomeScreenStyles.modalContainerDecoration,
        child: Column(
          children: [
            _buildModalHeader(isDeposit ? 'Dépôt' : 'Retrait'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone du client',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Montant',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Logique de traitement de la transaction
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDeposit ? Colors.green : Colors.orange,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(isDeposit ? 'Effectuer le dépôt' : 'Effectuer le retrait'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountUnlockForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: HomeScreenStyles.modalContainerDecoration,
        child: Column(
          children: [
            _buildModalHeader('Déplafonner un compte'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone du client',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nouveau plafond',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Motif du déplafonnement',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Logique de déplafonnement
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Déplafonner le compte'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Les autres widgets existants restent les mêmes, adaptés au besoin
  Widget _buildTabs() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          HomeScreenStyles.defaultSpacing,
          HomeScreenStyles.largeSpacing,
          HomeScreenStyles.defaultSpacing,
          0,
        ),
        decoration: HomeScreenStyles.tabContainerDecoration,
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          tabs: const [
            Tab(text: "Transactions du jour", icon: Icon(Icons.today)),
            Tab(text: "Clients réguliers", icon: Icon(Icons.people)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyTransactionsList(),
          _buildRegularClientsList(),
        ],
      ),
    );
  }

  Widget _buildDailyTransactionsList() {
    // Simuler des transactions
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final bool isDeposit = index % 2 == 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: HomeScreenStyles.transactionItemDecoration,
          child: ListTile(
            leading: Icon(
              isDeposit ? Icons.arrow_upward : Icons.arrow_downward,
              color: isDeposit ? Colors.green : Colors.orange,
            ),
            title: const Text('7X XXX XX XX'),
            subtitle: Text(DateFormat('HH:mm').format(DateTime.now())),
            trailing: Text(
              '${isDeposit ? '+' : '-'}${currencyFormat.format(10000 * (index + 1))}',
              style: TextStyle(
                color: isDeposit ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildRegularClientsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: HomeScreenStyles.favoriteItemDecoration,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Client ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('7X XXX XX XX'),
                Text('Dernière visite: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  color: Colors.green,
                  onPressed: () => _showTransactionForm(isDeposit: true),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  color: Colors.orange,
                  onPressed: () => _showTransactionForm(isDeposit: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionHistory() {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Historique des transactions'),
          pinned: true,
          floating: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTransactionSummary(
                      title: "Dépôts du jour",
                      amount: 1500000,
                      color: Colors.green,
                      icon: Icons.arrow_upward,
                    ),
                    const Divider(),
                    _buildTransactionSummary(
                      title: "Retraits du jour",
                      amount: 750000,
                      color: Colors.orange,
                      icon: Icons.arrow_downward,
                    ),
                    const Divider(),
                    _buildTransactionSummary(
                      title: "Solde commission",
                      amount: 25000,
                      color: Theme.of(context).primaryColor,
                      icon: Icons.account_balance_wallet,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip(
                    label: 'Aujourd\'hui',
                    isSelected: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip(
                    label: 'Cette semaine',
                    isSelected: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip(
                    label: 'Ce mois',
                    isSelected: false,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildHistoryTransactionItem(index);
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSummary({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: Text(
        currencyFormat.format(amount),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool value) {
        // Implémenter la logique de filtrage
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildHistoryTransactionItem(int index) {
    final bool isDeposit = index % 2 == 0;
    final DateTime transactionDate = DateTime.now().subtract(Duration(hours: index));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: HomeScreenStyles.transactionItemDecoration,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDeposit ? Colors.green : Colors.orange).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isDeposit ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDeposit ? Colors.green : Colors.orange,
          ),
        ),
        title: const Text('7X XXX XX XX'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd/MM/yyyy HH:mm').format(transactionDate)),
            Text(
              isDeposit ? 'Dépôt' : 'Retrait',
              style: TextStyle(
                color: isDeposit ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${isDeposit ? '+' : '-'}${currencyFormat.format(10000 * (index + 1))}',
          style: TextStyle(
            color: isDeposit ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: HomeScreenStyles.getHeaderGradient(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.store, size: 50),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Point de service Wave',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: 123456789',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildProfileMenuItem(
                icon: Icons.account_balance_wallet,
                title: 'Solde disponible',
                subtitle: currencyFormat.format(1500000),
              ),
              _buildProfileMenuItem(
                icon: Icons.history,
                title: 'Commission totale',
                subtitle: currencyFormat.format(75000),
              ),
              _buildProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Changer le mot de passe',
                onTap: _showChangePasswordDialog,
              ),
              _buildProfileMenuItem(
                icon: Icons.support_agent,
                title: 'Support',
                onTap: () {
                  // Implémenter la logique pour le support
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.logout,
                title: 'Déconnexion',
                onTap: () {
                  // Implémenter la logique de déconnexion
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildModalHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String? photoUrl) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = 2),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.store,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}