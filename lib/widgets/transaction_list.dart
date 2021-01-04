import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 550,  // It is used to make container height the list will scroll between this container height only 
        // If the height is greater than the screen size than it will not scroll
        // If the height is less than the screen size and the value is more than it will scroll
        child: transactions.isEmpty
            ? LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    children: [
                      Text(
                        'No transactions added yet!',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset('assets/image/waiting.png',
                            fit: BoxFit.cover),
                      ),
                    ],
                  );
                },
              )
            : ListView(
                children: transactions
                    .map((tx) => TransactionItem(
                          key: ValueKey(tx.id),
                          transaction: tx,
                          deleteTx: deleteTx,
                        ))
                    .toList(),
              ));
  }
}
