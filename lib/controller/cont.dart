import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesController extends GetxController {
  TextEditingController taskController = TextEditingController();

  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
}
