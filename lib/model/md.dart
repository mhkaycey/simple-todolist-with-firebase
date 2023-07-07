import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late String title;
  late String? status;
  final List<Subtask>? tasks;
  final DocumentReference? reference;

  Task({required this.title, this.status, this.tasks, this.reference});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      // 'status': status,
      'tasks': tasks!.map((subtask) => subtask.toMap()).toList(),
    };
  }

  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
        title: doc['title'],
        // status: doc['status'],
        tasks: (doc['tasks'] as List)
            .map((subtask) => Subtask.fromMap(subtask))
            .toList(),
        reference: doc.reference);
  }
}

class Subtask {
  late String? title;
  late  String? status;

  Subtask({this.title, this.status});

  Map<String, dynamic> toMap() {
    return {'title': title, 'status': status};
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(title: map['title'], status: map['status']);
  }
}
