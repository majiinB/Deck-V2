class Task {
  final String _uid;
  final String _title;
  final String _description;
  final String _userId;
  bool isDone = false;
  final DateTime _createdAt, _deadline;
  bool isDeleted;
  final DateTime _doneDate;

  Task(this._uid, this._title, this._description, this._userId, this.isDone, this._createdAt, this._deadline, this.isDeleted, this._doneDate);
  String get uid => _uid;
  String get userId => _userId;
  String get title => _title;
  bool get getIsDone => isDone;
  set setIsDone (bool value){
    isDone = value;
  }
  String get description => _description;
  DateTime get createdAt => _createdAt;
  DateTime get deadline => _deadline;
  bool get getIsDeleted => isDeleted;
  set setIsDeleted (bool value) {
    isDeleted = value;
  }
  DateTime get doneDate => _doneDate;
}