import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wave_app/bloc/transaction/transaction_event.dart';
import 'package:wave_app/bloc/transaction/transaction_state.dart';
import 'package:wave_app/bloc/transaction/transaction_bloc.dart';
import 'package:wave_app/data/models/transaction.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_history_screen.dart';
import 'package:wave_app/presentation/screens/profile/profile_screen.dart';
import 'package:wave_app/presentation/screens/transfer/transfer_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/bloc/auth/auth_state.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

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

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scannerController.dispose();
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
            const TransferHistoryScreen(),
            const ProfileScreen(),
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
    );
  }

  Widget _buildHomeScreenContent() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(state),
              _buildActionButtons(state),
              _buildQuickActions(),
              _buildTabs(),
              _buildTabContent(state),
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
              child: _buildUserInfo(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(AuthSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: HomeScreenStyles.largeSpacing),
            Text(
              'Bonjour, ${state.user.prenom}',
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
                : '• • • • • • • • • •',
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

  Widget _buildProfileAvatar(String? photoUrl) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = 2),
        child: Container(
          decoration: HomeScreenStyles.avatarDecoration,
          child: CircleAvatar(
            radius: HomeScreenStyles.avatarSize / 2,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(AuthSuccess state) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(HomeScreenStyles.defaultSpacing),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.qr_code,
                label: 'Mon QR Code',
                onTap: () => _showQRCode(context, state.user.numeroCompte ?? ''),
              ),
            ),
            const SizedBox(width: HomeScreenStyles.smallSpacing),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: HomeScreenStyles.transactionItemDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: HomeScreenStyles.smallSpacing),
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
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.send,
        'label': 'Transfert',
        'color': Theme.of(context).primaryColor,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferScreen()),
            ),
      },
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Recharger',
        'color': Colors.green,
        'onTap': () {},
      },
      {
        'icon': Icons.receipt_long,
        'label': 'Factures',
        'color': Colors.orange,
        'onTap': () {},
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DefaultTabController(
            length: 2,
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: HomeScreenStyles.tabLabelStyle,
              tabs: [
                _buildTab("Transactions", Icons.swap_horiz, 5),
                _buildTab("Favoris", Icons.favorite, 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, IconData icon, int badgeCount) {
    return Tab(
      icon: Stack(
        children: [
          Icon(icon, size: HomeScreenStyles.iconSize),
          if (badgeCount > 0)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: HomeScreenStyles.badgeDecoration,
                constraints: const BoxConstraints(
                  minWidth: HomeScreenStyles.badgeSize,
                  minHeight: HomeScreenStyles.badgeSize,
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
  
   void _startScanning() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: HomeScreenStyles.modalContainerDecoration,
        child: Column(
          children: [
            _buildModalHeader('Scanner un QR Code'),
            const SizedBox(height: HomeScreenStyles.largeSpacing),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: HomeScreenStyles.scannerContainerDecoration,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: _handleScannedCode,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _handleScannedCode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferScreen(
              recipientId: barcode.rawValue,
            ),
          ),
        );
        break;
      }
    }
  }

  void _showQRCode(BuildContext context, String qrData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: HomeScreenStyles.modalContainerDecoration,
        child: Column(
          children: [
            _buildModalHeader('Mon QR Code'),
            const SizedBox(height: HomeScreenStyles.largeSpacing),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: HomeScreenStyles.largeSpacing),
            Text(
              'Scannez ce code pour m\'envoyer de l\'argent',
              style: HomeScreenStyles.qrCodeInstructionStyle,
            ),
          ],
        ),
      ),
    );
  }


Widget _buildTabContent(AuthSuccess state) {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionsList(ScrollController()),
          _buildFavoritesList(ScrollController()),
        ],
      ),
    );
  }


Widget _buildTransactionsList(ScrollController scrollController) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionError) {
          return Center(child: Text('Erreur: ${state.message}'));
        }

        if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text('Aucune transaction récente'));
          }

          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return _buildTransactionItem(transaction);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: HomeScreenStyles.defaultSpacing),
      decoration: HomeScreenStyles.transactionItemDecoration,
      child: ListTile(
        leading: Icon(
          transaction.type == TransactionType.sent
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: transaction.type == TransactionType.sent
              ? HomeScreenStyles.sentColor
              : HomeScreenStyles.receivedColor,
        ),
        title: Text(
          transaction.recipient,
          style: HomeScreenStyles.transactionTitleStyle,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: HomeScreenStyles.transactionSubtitleStyle,
        ),
        trailing: Text(
          currencyFormat.format(transaction.amount),
          style: HomeScreenStyles.getTransactionAmountStyle(transaction.type as bool),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) => _buildFavoriteItem(index),
    );
  }

  Widget _buildFavoriteItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: HomeScreenStyles.defaultSpacing),
      decoration: HomeScreenStyles.favoriteItemDecoration,
      child: ListTile(
        contentPadding: HomeScreenStyles.listItemPadding,
        leading: _buildFavoriteAvatar(index as String),
        title: Text(
          'Contact Favori ${index + 1}',
          style: HomeScreenStyles.favoriteTitleStyle,
        ),
        subtitle: Text(
          '7X XXX XX XX',
          style: HomeScreenStyles.favoriteSubtitleStyle,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          color: Theme.of(context).primaryColor,
          onPressed: () {},
        ),
      ),
    );
  }

Widget _buildModalHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: HomeScreenStyles.modalContainerDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

   Widget _buildFavoriteAvatar(String imageUrl) {
    return Container(
      decoration: HomeScreenStyles.avatarDecoration,
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: HomeScreenStyles.avatarSize / 2,
      ),
    );
  }
}