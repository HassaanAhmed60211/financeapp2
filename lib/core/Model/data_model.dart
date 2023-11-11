class DataModel {
  final String expensename;
  final String expenseprice;

  DataModel({
    required this.expensename,
    required this.expenseprice,
  });

  Map<String, dynamic> toMap() {
    return {
      'expensename': expensename,
      'expenseprice': expenseprice,
    };
  }
}
