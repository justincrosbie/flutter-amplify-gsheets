class GoogleData {
  final String task;
  final String detail;
  final String dateComplete;

  GoogleData({required this.task, required this.detail, required this.dateComplete});

  GoogleData.fromJSON(List<String> row)
      : task = row[0],
        detail = row[1],
        dateComplete = row[2];
}
