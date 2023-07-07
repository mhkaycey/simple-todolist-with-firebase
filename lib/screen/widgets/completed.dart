import 'package:flutter/material.dart';

import '../../model/md.dart';

class CompletedPage extends StatelessWidget {
  final Task task;
   const CompletedPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final List<Subtask> doneSubtasks =
    task.tasks!.where((subtask) => subtask.status == 'Complete').toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: doneSubtasks.length,
      itemBuilder: (BuildContext context, int index) {
       final completed = doneSubtasks[index];
        return Card(
          shadowColor: Colors.grey,
          child: Padding(padding: const EdgeInsets.all(8),
          child: Text(completed.title.toString()),
          ),

        );
      },

    );
  }
}
