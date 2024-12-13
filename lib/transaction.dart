import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionReport {
  // Function to fetch transactions from Firestore
  Future<List<List<dynamic>>> fetchTransactions() async {
    final transactionsSnapshot = await FirebaseFirestore.instance.collection('orders').get();

    // Prepare the data to be displayed in a table
    List<List<dynamic>> rows = [];
    rows.add(["Transaction ID", "User ID", "TotalAmount", "Date", "Status"]);

    for (var doc in transactionsSnapshot.docs) {
      var transaction = doc.data();
      rows.add([
        doc.id,
        transaction['userId'] ?? 'N/A',
        transaction['totalPrice'] ?? 0,
        transaction['orderDate']?.toDate().toString() ?? 'N/A',
        transaction['status'] ?? 'N/A',
      ]);
    }

    return rows;
  }
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _isLoading = true;  // Flag to show loading spinner
  late Future<List<List<dynamic>>> _transactions;  // Future to fetch transactions

  final TransactionReport transactionReport = TransactionReport();

  @override
  void initState() {
    super.initState();
    _transactions = transactionReport.fetchTransactions();  // Fetch transactions on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction Report'),backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Show loading spinner if the data is still being fetched
            // if (_isLoading)
            //   CircularProgressIndicator(),
            
            // Display the data table once data is fetched
            FutureBuilder<List<List<dynamic>>>(
              future: _transactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  List<List<dynamic>> data = snapshot.data!;

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Transaction ID')),
                          DataColumn(label: Text('User ID')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: data
                            .skip(1) // Skip the header row
                            .map(
                              (transaction) => DataRow(
                                cells: transaction.map((field) {
                                  return DataCell(Text(field.toString()));
                                }).toList(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }

                return Center(child: Text('No data available.'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ReportPage(),
//   ));
// }
