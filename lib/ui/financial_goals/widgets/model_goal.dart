class GoalModel {
  String? goalname;
  String? curentsaving;
  String? totalsaving;

  GoalModel({
    this.goalname,
    this.curentsaving,
    this.totalsaving,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
        goalname: json["goalname"],
        curentsaving: json["curentsaving"],
        totalsaving: json["totalsaving"],
      );

  Map<String, dynamic> toJson() => {
        "goalname": goalname,
        "curentsaving": curentsaving,
        "totalsaving": totalsaving,
      };
}
