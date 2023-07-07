import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/cont.dart';
import 'package:notes/model/md.dart';
import 'package:notes/screen/details.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final control = Get.put(NotesController());
  @override
  Widget build(BuildContext context) {
    // final control = Get.put(notesController());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Lists.', style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "NotoSansKR"
            ), ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: control.tasksCollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final tasks =
                  snapshot.data!.docs.map((doc) => Task.fromDocument(doc)).toList();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => DetailsPage(
                          title: task.title,
                          task: task,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.maxFinite,
                        height: 60,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(15),
                         boxShadow: [
                           BoxShadow(
                               color: Colors.black.withOpacity(0.05),
                               blurRadius: 10,
                               offset: const Offset(0.0, 4.0),)
                         ]
                       ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                          child: GestureDetector(
                                            onTap: () => _deleteTask(task),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.delete,),
                                                Text("Delete")
                                              ],
                                            ),
                                          )
                                      ),
                                      PopupMenuItem(
                                          value: 2,
                                          child: GestureDetector(
                                            onTap: () => _editTask(task),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.edit_document,),
                                                Text("Edit")
                                              ],
                                            ),
                                          )
                                      )
                                    ],
                                  )

                                 ,
                                ),
                              ],
                            ),
                             const Spacer(),
                             Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(left: 10, bottom: 20,),
                              child: task.tasks!.length == 1 ?
                              Text(
                                '${task.tasks!.length.toString()} TASK',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ) :   Text(
                                '${task.tasks!.length.toString()} TASKS',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )

                          ],
                        )



                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createTask() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: control.taskController,
                decoration: const InputDecoration(
                    hintText: 'Enter the name of the task'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final task = Task(
                  title: control.taskController.text,
                  tasks: [],
                );
                await control.tasksCollection.add(task.toMap());
                Get.back();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
    control.taskController.clear();
  }

  void _editTask(Task task) async {
    await showDialog(
      context: context,
      builder: (context) {
        final subtaskController =
            TextEditingController(); // Add a controller for subtask input
        subtaskController.text = task.title; // Pre-fill subtask value
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subtaskController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                task.title = subtaskController.text;

                await task.reference!.update(task.toMap());
                Get.back();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
    control.taskController.clear();
  }

  void _deleteTask(Task task) async {
    await task.reference!.delete();
  }
}
