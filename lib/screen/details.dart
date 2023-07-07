import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/model/md.dart';
import 'package:notes/screen/widgets/bottom_bar.dart';
import 'package:notes/screen/widgets/bottom_drag.dart';
import 'package:notes/screen/widgets/completed.dart';

class DetailsPage extends StatefulWidget {
  final Task task;
  final String? title;
  const DetailsPage({super.key, required this.task, this.title});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // To get ongoing task
    final List<Subtask> subtasks = widget.task.tasks!
        .where((subtask) => subtask.status == 'incomplete')
        .toList();

    // To get only the completed task
    final List<Subtask> doneSubtasks = widget.task.tasks!
        .where((subtask) => subtask.status == 'Complete')
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: subtasks.length,
              itemBuilder: (context, index) {
                final subtask = subtasks[index];

                // Update, Delete and Mark Completed
                return InkWell(
                  onTap: () => Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.only(top: 4),
                      height: widget.task.status == "incomplete"
                          ? MediaQuery.of(context).size.height * 0.24
                          : MediaQuery.of(context).size.height * 0.32,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 6,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                          ),
                          const Spacer(),
                          subtask.status == "Complete"
                              ? Container()
                              : BottomBarBotton(
                                  label: "Mark Completed",
                                  onTap: () {
                                    _markSubtaskAsDone(
                                        context, widget.task, subtask);
                                  },
                                  clr: Colors.blue.withOpacity(0.5),
                                ),
                          const SizedBox(height: 0),
                          BottomBarBotton(
                            label: "Cancel and Delete",
                            onTap: () {
                              Get.back();
                            },
                            clr: Colors.red.shade600,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(subtask.title.toString()),
                    subtitle: Text(subtask.status.toString()),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit_document),
                        onPressed: () =>
                            _editSubtask(context, widget.task, subtask)),
                  ),
                );
              },
            ),
            // Spacer(),

            // To display the bottomdrag, the user can view the completed task
            BottomDrag(
              child: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 8,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Center(
                  child: Text(
                    "COMPLETED (${doneSubtasks.length})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CompletedPage(task: widget.task)
              ],
            )
          ],
        ),
      ),

      // Use to create taskks
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final subtaskController = TextEditingController();
          Get.defaultDialog(
            title: widget.task.title,
            content: TextField(
              controller: subtaskController,
              decoration: const InputDecoration(
                hintText: 'Create Task',
              ),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final newSubtask = Subtask(
                    title: subtaskController.text,
                    status: 'incomplete',
                  );
                  widget.task.tasks!.add(newSubtask);
                  await widget.task.reference!.update({
                    'tasks': widget.task.tasks!
                        .map((subtask) => subtask.toMap())
                        .toList()
                  });
                  Get.back();
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

//MarkDone
  void _markSubtaskAsDone(
      BuildContext context, Task task, Subtask subtask) async {
    subtask.status = 'Complete';
    await task.reference!.update({
      'tasks': task.tasks!.map((subtask) => subtask.toMap()).toList(),
    });
  }

//Edit Subtask
  void _editSubtask(BuildContext context, Task task, Subtask subtask) async {
    final subtaskController = TextEditingController(text: subtask.title);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Subtask'),
          content: TextField(
            controller: subtaskController,
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                subtask.title = subtaskController.text;
                await task.reference!.update({
                  'tasks':
                      task.tasks!.map((subtask) => subtask.toMap()).toList(),
                });
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    subtaskController.clear();
  }
}
