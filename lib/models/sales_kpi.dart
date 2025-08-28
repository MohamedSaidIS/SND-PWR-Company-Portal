

class SalesKPI {
  final String dataAreaId;
  final String transDate;
  final String worker;
  final double lastSalesAmount;
  final double dailySalesAmount;
  final double monthlyRate;
  final double monthlyTarget;

  SalesKPI({
    required this.dataAreaId,
    required this.transDate,
    required this.worker,
    required this.lastSalesAmount,
    required this.dailySalesAmount,
    required this.monthlyRate,
    required this.monthlyTarget,
  });

  factory SalesKPI.fromJson(Map<String, dynamic> json){
    return SalesKPI(
      dataAreaId: json ['dataAreaId'],
      transDate: json ['TransDate'],
      worker: json ['Worker'],
      lastSalesAmount: json ['LastSalesAmount'].toDouble(),
      dailySalesAmount: json ['DailySalesAmount'].toDouble(),
      monthlyRate: json ['MonthlyRate'].toDouble(),
      monthlyTarget: json ['MonthlyTarget'].toDouble(),
    );
  }
}