import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<TaskModel> _tasks = [];

  List<TaskModel> get pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();

  List<TaskModel> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();

  void initTaskListener(){
    final user = _auth.currentUser;
    if(user == null) return ;
    _firestore
    .collection('tasks')
    .where('userId', isEqualTo: user.uid)
    .snapshots()
    .listen((snapshot){
      _tasks = snapshot.docs.map((doc){
        return TaskModel.fromMap(doc.data(), doc.id);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addTask(String title, String desc, DateTime? date) async{
    final user = _auth.currentUser;
    if(user == null) return;

    await _firestore.collection('tasks').add({
      'title': title,
      'description': desc,
      'isCompleted': false,
      'dueDate': date != null ? Timestamp.fromDate(date) : null,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),

    });
  }

  Future<void> updateTask(String id , String title, String desc , DateTime? date) async {
    await _firestore.collection('tasks').doc(id).update({
      'title' : title,
      'description' : desc,
      'dueDate' : date != null ? Timestamp.fromDate(date): null,
    });
  }

  Future<void> toggleTaskStatus(String id, bool currentStatus) async{
    await _firestore.collection("tasks").doc(id).update({
      'isCompleted' : !currentStatus,
    });
  }

  Future<void> deleteTask(String id) async{
    await _firestore.collection('tasks').doc(id).delete();
  }
}