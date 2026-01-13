import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final pending = provider.pendingTasks;
    final completed = provider.completedTasks;

    return Scaffold(
      backgroundColor: Colors.white10 ,
      appBar: AppBar(
        title: Text("My Tasks" , style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/task-form'),
          label: const Text("New Task"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: (pending.isEmpty && completed.isEmpty)
        ? _buildEmptyState()
          : ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          if(pending.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(20, 10, 20, 5),
              child : Text("PENDING ( ${pending.length})",style: const TextStyle(fontWeight: FontWeight.bold , color: Colors.indigo),),

            ),
            ...pending.map((task) => TaskTile(
                task: task,
                onToggle: () => provider.toggleTaskStatus(task.id, task.isCompleted),
                onTap: () => context.go('/task-form' , extra: task),
                onDelete: () => provider.deleteTask(task.id),
            )),

          ],

          if (completed.isNotEmpty) ...[
            const Divider(height: 40, thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Text("COMPLETED (${completed.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            ...completed.map((task) => TaskTile(
              task: task,
              onToggle: () => provider.toggleTaskStatus(task.id, task.isCompleted),
              onTap: () {}, // Disable editing for completed
              onDelete: () => provider.deleteTask(task.id),
            )),
          ],



        ],
      )

    );
  }

  Widget _buildEmptyState(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt , size: 80 , color: Colors.indigo.shade100),
          const SizedBox(height: 20,),
          Text("All caught up!", style: GoogleFonts.poppins(fontSize: 18)),
        ],
      )
    );

  }
}
