import 'dart:io';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses Tracker',
      theme: ThemeData(
        datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: Colors.purple,
            headerForegroundColor: Colors.white),
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            titleLarge: TextStyle(
                fontFamily: 'Opensans',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'Opensans', fontSize: 20, color: Colors.black)),
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 100.10,
      date: DateTime.now(),
    )
  ];

  void deleteTransaction(id) {
    final newTx = _userTransactions.where((tx) => tx.id != id).toList();

    setState(() {
      _userTransactions = newTx;
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  bool _showChart = false;

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosenDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(addNewTransaction: _addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      title: const Text('Personal Expenses Tracker'),
      actions: [
        IconButton(
            onPressed: () {
              _startAddNewTransaction(context);
            },
            icon: Icon(Icons.add))
      ],
    );

    final txListWidget = SizedBox(
      height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTx: deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Chart'),
                    Switch.adaptive(
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        })
                  ],
                ),
              if (!isLandscape)
                SizedBox(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(
                    recentTransactions: _recentTransactions,
                  ),
                ),
              if (!isLandscape) txListWidget,
              if (isLandscape)
                _showChart
                    ? SizedBox(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                        child: Chart(
                          recentTransactions: _recentTransactions,
                        ),
                      )
                    : txListWidget
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                _startAddNewTransaction(context);
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
