class ClassRoutine {
  final String? startTime;
  final String? endTime;
  final String? subject;
  final String? room;
  final String? period;
  String? isBreak = "No";

  ClassRoutine({this.startTime, this.endTime, this.subject, this.room,this.period,this.isBreak = "No"});

  factory ClassRoutine.fromJson(Map<String, dynamic> json) {
    return ClassRoutine(
        startTime: json['start_time'],
        endTime: json['end_time'],
        subject: json['subject_name'],
        room: json['room_no'],
        period: json['period'],
        isBreak: json['break']

    );
  }
}
