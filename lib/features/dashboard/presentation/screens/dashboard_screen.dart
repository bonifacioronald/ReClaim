import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/features/barcode-scan/presentation/data/models/transaction_model.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/providers/transaction_provider.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/main_balance_card.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import '../../../../core/navigation/navigation.dart';
import '../widgets/main_menu_action_button.dart';
import '../widgets/recent_transaction_card.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard-screen';
  final AppUser user;

  DashboardScreen({required this.user});


  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  TransactionProvider _transactionProvider = TransactionProvider();
  @override
  void initState() {
    super.initState();
    _fetchAllTransaction();
  }

  Future<void> _fetchAllTransaction() async {
    await _transactionProvider.fetchTransactionId();
    await _transactionProvider.fetchAllTransactions();
    // Use the fetched transaction data in your page
    _displayTransactionDetails();
  }

  void _displayTransactionDetails() {
    // Access the fetched transaction data from _transactionProvider.loadedTransactionList
    TransactionModel fetchedTransaction = _transactionProvider.loadedTransactionList.first;
    if (_transactionProvider.loadedTransactionList.isEmpty) {
    print("No transactions found.");
    }else{
    // Display the transaction details in your page
    print("the fetched transaction sample are = ${_transactionProvider.loadedTransactionList[2]}");
    return; // Exit the method early
    }
  }

  //Get BottomNavBar from GlobalKey to access onTap
  BottomNavigationBar get navigationBar {
    return NavigationState.globalKey.currentWidget as BottomNavigationBar;
  }

  @override
  Widget build(BuildContext context) {
    double lifetimeEarnings = 0.00;
    int lifetimeRecycledItems = 33;
    AppUser user = widget.user; 
    print("In dashboard screen: ${user.email}"); 

    


    return Container(
      color: custom_colors.primaryBackground,
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        color: custom_colors.accentGreen,
        onRefresh: () async {
          return Future<void>.delayed(
            const Duration(seconds: 1),
            (() {
              // Provider.of<TransactionProvider>(context, listen: false)
              //     .updateTransactionData();
              // Provider.of<UserProvider>(context, listen: false)
              //     .updateUserData();
            }),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  MainBalanceCard(),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Expanded(
              child: DraggableBottomSheet(
                minExtent: 110,
                barrierColor: Colors.transparent,
                curve: Curves.easeIn,
                expansionExtent: 0.5,
                onDragging: (pos) {},
                previewWidget: RecentTransactionsCard(),
                expandedWidget: ExpandedRecentTransactionsCard(),
                backgroundWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: const MainMenuActionButton(
                              'Insight',
                              custom_colors.accentGreen,
                              Icons.bar_chart,
                            ),
                            onTap: () {
                              navigationBar.onTap!(1);
                            },
                          ),
                          GestureDetector(
                            child: const MainMenuActionButton(
                                'Adjust',
                                custom_colors.accentGreenVariant,
                                Icons.settings),
                            // onTap: (() => Navigator.of(context)
                            //     .pushNamed(SettingScreen.routeName)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Lifetime Earnings',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$lifetimeEarnings APT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$lifetimeRecycledItems items recycled',
                            style: TextStyle(
                                color: custom_colors.accentGreen, fontSize: 16),
                          )
                        ],
                      )
                    ],
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
