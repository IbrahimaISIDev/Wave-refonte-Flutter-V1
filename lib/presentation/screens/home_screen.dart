import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wave_app/data/models/transaction.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_history_screen.dart';
import 'package:wave_app/presentation/screens/profile/profile_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );

  late TabController _tabController;
  bool _isBalanceVisible = true;
  final MobileScannerController _scannerController = MobileScannerController();

  int _selectedIndex = 0; // Ajout de l'index sélectionné pour la navigation

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  final double balance = 250000;
  final List<Transaction> recentTransactions = [
    Transaction(
      type: TransactionType.sent,
      amount: 50000,
      recipient: "Marie Diop",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      type: TransactionType.received,
      amount: 100000,
      recipient: "John Doe",
      date: DateTime.now().subtract(const Duration(hours: 1)),
      status: TransactionStatus.pending,
    ),
    Transaction(
      type: TransactionType.sent,
      amount: 20000,
      recipient: "Jane Smith",
      date: DateTime.now().subtract(const Duration(hours: 3)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      type: TransactionType.received,
      amount: 75000,
      recipient: "Emma Watson",
      date: DateTime.now().subtract(const Duration(hours: 4)),
      status: TransactionStatus.pending,
    ),
    Transaction(
      type: TransactionType.sent,
      amount: 15000,
      recipient: "David Johnson",
      date: DateTime.now().subtract(const Duration(hours: 5)),
      status: TransactionStatus.completed,
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreenContent(),
          const TransferHistoryScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
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
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            _buildModalHeader(),
            const SizedBox(height: 30),
            QrImageView(
              data: 'wave:user:amadou123',
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Scannez ce code pour m\'envoyer de l\'argent',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startScanning() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            _buildModalHeader(),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        debugPrint('Code scanné: ${barcode.rawValue}');
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget _buildHomeScreenContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildActionButtons(),
        _buildQuickActions(),
        _buildTabs(),
        _buildTabContent(),
      ],
    );
  }

Widget _buildAppBar() {
  return SliverAppBar(
    expandedHeight: 200,
    pinned: true,
    backgroundColor: Colors.transparent,
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.9),
              Theme.of(context).primaryColor.withOpacity(0.6),
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: _buildUserInfo(),
          ),
        ),
      ),
    ),
  );
}

Widget _buildUserInfo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Bonjour, Amadou',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _buildBalanceDisplay(),
            ),
          ),
        ],
      ),
      _buildProfileButton(),
    ],
  );
}

Widget _buildBalanceDisplay() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        _isBalanceVisible
            ? currencyFormat.format(balance)
            : '• • • • • • • • • •',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(width: 8),
      Icon(
        _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.white.withOpacity(0.8),
        size: 20,
      ),
    ],
  );
}

Widget _buildProfileButton() {
  return Material(
    color: Colors.transparent,
    shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () {},
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white.withOpacity(0.2),
        child: const Icon(Icons.person, color: Colors.white, size: 24),
      ),
    ),
  );
}


  Widget _buildActionButtons() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.qr_code,
                label: 'Mon QR Code',
                onTap: () => _showQRCode(context),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActionButton(
                icon: Icons.qr_code_scanner,
                label: 'Scanner',
                onTap: _startScanning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionButton(
              icon: Icons.send,
              label: 'Envoyer',
              color: Theme.of(context).primaryColor,
              onTap: () {
                // Naviguez vers la page de transfert
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionButton(
              icon: Icons.account_balance_wallet,
              label: 'Recharger',
              color: Colors.green,
              onTap: () {
                // // Naviguez vers la page de rechargement
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const RechargeScreen(),
                //   ),
                // );
              },
            ),
            _buildQuickActionButton(
              icon: Icons.receipt_long,
              label: 'Factures',
              color: Colors.orange,
              onTap: () {
                // // Naviguez vers la page des factures
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const InvoiceScreen(),
                //   ),
                // );
              },
            ),
            _buildQuickActionButton(
              icon: Icons.more_horiz,
              label: 'Plus',
              color: Colors.purple,
              onTap: () {
                // // Naviguez vers la page des paramètres
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const SettingsScreen(),
                //   ),
                // );
              },
            ),
          ],
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
    onTap: () {
      if (label == 'Envoyer') {
        // Naviguez vers la page de transfert
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransferScreen(),
          ),
        );
      } else {
        onTap();
      }
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTabs() {
  return SliverToBoxAdapter(
    child: Container(
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1), // Ombre légère pour profondeur
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DefaultTabController(
          length: 2,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Theme.of(context).primaryColor, // Couleur dynamique de l’indicateur
              borderRadius: BorderRadius.circular(16),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              _buildTab("Transactions", Icons.swap_horiz, 5), // Badge pour Transactions
              _buildTab("Favoris", Icons.favorite, 2), // Badge pour Favoris
            ],
          ),
        ),
      ),
    ),
  );
}

// Widget pour ajouter un badge aux onglets
Widget _buildTab(String title, IconData icon, int badgeCount) {
  return Tab(
    icon: Stack(
      children: [
        Icon(icon, size: 24),
        if (badgeCount > 0) // Affichage du badge si nécessaire
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
    text: title,
  );
}

Widget _buildTabContent() {
  return SliverFillRemaining(
    child: TabBarView(
      controller: _tabController,
      children: [
        _buildTransactionsList(),
        _buildFavoritesList(),
      ],
    ),
  );
}


  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildFavoriteItem(index);
      },
    );
  }

  Widget _buildFavoriteItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildFavoriteAvatar(index),
        title: Text(
          'Contact Favori ${index + 1}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: const Text(
          '7X XXX XX XX',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          color: Theme.of(context).primaryColor,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildFavoriteAvatar(int index) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Text(
        String.fromCharCode('A'.codeUnitAt(0) + index),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTransactionHeader(transaction),
            if (transaction.status == TransactionStatus.pending)
              _buildTransactionProgress(transaction),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader(Transaction transaction) {
    return Row(
      children: [
        _buildTransactionTypeIcon(transaction),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTransactionDetails(transaction),
        ),
        _buildTransactionAmountAndStatus(transaction),
      ],
    );
  }

  Widget _buildTransactionTypeIcon(Transaction transaction) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: transaction.type == TransactionType.sent
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        transaction.type == TransactionType.sent
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: transaction.type == TransactionType.sent
            ? Colors.red
            : Colors.green,
        size: 20,
      ),
    );
  }

  Widget _buildTransactionDetails(Transaction transaction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transaction.recipient,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('dd MMM yyyy, HH:mm').format(transaction.date),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionAmountAndStatus(Transaction transaction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${transaction.type == TransactionType.sent ? "-" : "+"} ${currencyFormat.format(transaction.amount)}',
          style: TextStyle(
            color: transaction.type == TransactionType.sent
                ? Colors.red
                : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        _buildTransactionStatus(transaction),
      ],
    );
  }

  Widget _buildTransactionStatus(Transaction transaction) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: transaction.status == TransactionStatus.completed
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        transaction.status == TransactionStatus.completed
            ? 'Complété'
            : 'En cours',
        style: TextStyle(
          color: transaction.status == TransactionStatus.completed
              ? Colors.green
              : Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTransactionProgress(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'En attente de confirmation',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
