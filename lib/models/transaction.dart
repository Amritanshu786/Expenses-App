import 'package:flutter/foundation.dart';

class Transaction {
  String id;
  String title;
  double amount;
  String date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });

  
  	// Convert a Transaction object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = id;
		}
		map['title'] = title;
    map['amount'] = amount;
		map['date'] = date;

		return map;
	}

  	// Extract a Note object from a Map object
	Transaction.fromMapObject(Map<String, dynamic> map) {
		this.id = map['id'];
		this.title = map['title'];
    this.amount = map['amount'];
		this.date = map['date'];
	}
}
