import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/todo.dart';
import '../widgets/todo_tile.dart';
import '../widgets/loading_widget.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  bool isLoading = true;
  String? errorMessage;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      final data = await ApiService.getTodos();
      setState(() {
        todos = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load todos: ${e.toString()}";
      });
    }
  }

  Future<void> addTodo() async {
    if (controller.text.trim().isEmpty) return;

    try {
      final newTodo = await ApiService.addTodo(controller.text);
      setState(() => todos.add(newTodo));
      controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add todo: ${e.toString()}")),
      );
    }
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    try {
      final updated = await ApiService.toggleTodo(todo.id, !todo.isCompleted);
      setState(() {
        int index = todos.indexWhere((t) => t.id == todo.id);
        todos[index] = updated;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update todo: ${e.toString()}")),
      );
    }
  }

  Future<void> deleteTodoItem(String id) async {
    try {
      await ApiService.deleteTodo(id);
      setState(() => todos.removeWhere((t) => t.id == id));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete todo: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddModal(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: isLoading
            ? const LoadingWidget()
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });
                            fetchTodos();
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 8),
                      Expanded(
                        child: todos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.inbox,
                                        size: 64, color: AppColors.muted),
                                    const SizedBox(height: 12),
                                    const Text('No todos yet',
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(height: 8),
                                    const Text('Tap + to add a new task',
                                        style:
                                            TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: todos.length,
                                itemBuilder: (context, index) {
                                  final todo = todos[index];
                                  return TodoTile(
                                    todo: todo,
                                    onChanged: (value) =>
                                        toggleTodoStatus(todo),
                                    onDelete: () => deleteTodoItem(todo.id),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final TextEditingController modalController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: modalController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'What needs to be done?',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) async {
                  if (value.trim().isEmpty) return;
                  Navigator.of(ctx).pop();
                  try {
                    final newTodo = await ApiService.addTodo(value);
                    setState(() => todos.add(newTodo));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add todo: $e')));
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                      onPressed: () async {
                        final val = modalController.text;
                        if (val.trim().isEmpty) return;
                        Navigator.of(ctx).pop();
                        try {
                          final newTodo = await ApiService.addTodo(val);
                          setState(() => todos.add(newTodo));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to add todo: $e')));
                        }
                      },
                      child: const Text('Add Task'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
