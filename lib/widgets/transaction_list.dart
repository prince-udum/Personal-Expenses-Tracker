import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {super.key, required this.transactions, required this.deleteTx});

  final List<Transaction> transactions;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(
            child: Text(
            'No Transaction added yet!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ))
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColorDark)),
                      child: Text(
                        '\$${transactions[index].amount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactions[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            DateFormat.yMMMd().format(transactions[index].date),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).size.width > 360
                        ? TextButton.icon(
                            onPressed: () {
                              deleteTx(transactions[index].id);
                            },
                            label: Text('Delete'),
                            icon: Icon(Icons.delete),
                          )
                        : IconButton(
                            onPressed: () {
                              deleteTx(transactions[index].id);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.purple)
                  ],
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
