import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
    required this.userId,
  });

  factory TaskModel.fromMap(Map<String, dynamic> data, String documentId){
    return TaskModel(
        id: documentId,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isCompleted: data['isCompleted'] ?? false,
        dueDate: data['dueDate'] != null
        ? (data['dueDate'] as Timestamp).toDate() : null,
        userId: data['userId'] ?? '' ,
    );
  }


  Map<String , dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'userId': userId,
    };
  }
}

