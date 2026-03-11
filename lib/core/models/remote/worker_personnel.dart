class WorkerPersonnel {
  final String personnelNumber;
  final String workerName;
  final String workerId;

  WorkerPersonnel({
    required this.personnelNumber,
    required this.workerName,
    required this.workerId,
  });

  factory WorkerPersonnel.fromJson(Map<String, dynamic> json) {
    return WorkerPersonnel(
      personnelNumber: json['PersonnelNumber'],
      workerName: json['WorkerName'],
      workerId: json['Worker'],
    );
  }
}
