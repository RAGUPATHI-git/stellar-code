import 'package:flutter/material.dart';
import 'package:front_end/service/gemini_AI_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample transaction data (in a real app, this would come from bank statement parsing)
  List<Transaction> _transactions = [
    Transaction(
      "Salary",
      50000,
      DateTime(2023, 10, 5),
      "Income",
      "Employer Inc",
    ),
    Transaction("Rent", -15000, DateTime(2023, 10, 7), "Housing", "Landlord"),
    Transaction(
      "Groceries",
      -3500,
      DateTime(2023, 10, 8),
      "Food",
      "Supermarket",
    ),
    Transaction(
      "Electricity Bill",
      -2500,
      DateTime(2023, 10, 10),
      "Utilities",
      "Power Co",
    ),
    Transaction(
      "Restaurant",
      -1800,
      DateTime(2023, 10, 12),
      "Food",
      "Fine Dining",
    ),
    Transaction(
      "Freelance Work",
      12000,
      DateTime(2023, 10, 15),
      "Income",
      "Client Co",
    ),
    Transaction(
      "Netflix",
      -800,
      DateTime(2023, 10, 16),
      "Entertainment",
      "Netflix Inc",
    ),
    Transaction(
      "Fuel",
      -2200,
      DateTime(2023, 10, 18),
      "Transport",
      "Gas Station",
    ),
    Transaction("Shopping", -4500, DateTime(2023, 10, 20), "Shopping", "Mall"),
    Transaction(
      "Investment",
      -10000,
      DateTime(2023, 10, 22),
      "Investment",
      "Stock Broker",
    ),
    Transaction("Coffee", -300, DateTime(2023, 10, 23), "Food", "Cafe"),
    Transaction(
      "Bonus",
      8000,
      DateTime(2023, 10, 25),
      "Income",
      "Employer Inc",
    ),
  ];

  // Sample spending by category
  List<CategorySpending> _categorySpending = [
    CategorySpending("Food", 5600, Colors.amber),
    CategorySpending("Housing", 15000, Colors.blue),
    CategorySpending("Utilities", 2500, Colors.green),
    CategorySpending("Entertainment", 800, Colors.purple),
    CategorySpending("Transport", 2200, Colors.red),
    CategorySpending("Shopping", 4500, Colors.pink),
    CategorySpending("Investment", 10000, Colors.teal),
  ];

  double get totalIncome => _transactions
      .where((t) => t.amount > 0)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.amount < 0)
      .fold(0, (sum, t) => sum + t.amount);

  double get netSavings =>
      totalIncome + totalExpenses; // totalExpenses is negative

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back,",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Alex Johnson",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/32.jpg",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Financial Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildFinancialCard(
                      "Income",
                      totalIncome,
                      Colors.green,
                      Icons.arrow_upward,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildFinancialCard(
                      "Expenses",
                      totalExpenses,
                      Colors.red,
                      Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFinancialCard(
                      "Savings",
                      netSavings,
                      netSavings >= 0 ? Colors.teal : Colors.orange,
                      netSavings >= 0 ? Icons.savings : Icons.warning,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Spending Chart
              Text(
                "Spending by Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                  ),
                  series: <CircularSeries>[
                    DoughnutSeries<CategorySpending, String>(
                      dataSource: _categorySpending,
                      xValueMapper: (CategorySpending data, _) => data.category,
                      yValueMapper: (CategorySpending data, _) => data.amount,
                      pointColorMapper:
                          (CategorySpending data, _) => data.color,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View All",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Transactions List
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _transactions.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionCard(transaction);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFinancialCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    final isNegative = amount < 0;
    final displayAmount = isNegative ? -amount : amount;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "₹${displayAmount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            isNegative ? "Spent" : "Earned",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome = transaction.amount > 0;
    final icon = isIncome ? Icons.arrow_circle_up : Icons.arrow_circle_down;
    final color = isIncome ? Colors.green : Colors.red;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  transaction.merchant,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${transaction.amount.abs().toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('MMM dd').format(transaction.date),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF2575FC),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
            },
            child: Icon(Icons.chat_bubble_outline),
          ),
          label: "Assistant", // New chatbot feature
        ),
      ],
    );
  }
}

class Transaction {
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final String merchant;

  Transaction(
    this.description,
    this.amount,
    this.date,
    this.category,
    this.merchant,
  );
}

class CategorySpending {
  final String category;
  final double amount;
  final Color color;

  CategorySpending(this.category, this.amount, this.color);
}
