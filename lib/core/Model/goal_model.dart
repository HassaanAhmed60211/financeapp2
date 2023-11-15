class GoalModel {
  final String goalname;
  final String curentsaving;
  final String totalsaving;

  GoalModel({
    required this.goalname,
    required this.curentsaving,
    required this.totalsaving,
  });

  Map<String, dynamic> toMap() {
    return {
      'goalname': goalname,
      'curentsaving': curentsaving,
      'totalsaving': totalsaving,
    };
  }
}
