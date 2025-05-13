import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';
import '../bloc/todo_event.dart';
import '../models/todo.dart';

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TodoBloc>();
    final controller = TextEditingController();

    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        final tasks = state.filteredTodos;

        return Scaffold(
          appBar: AppBar(
            title: const Text('ToDo List'),
            actions: [
              IconButton(
                icon: Icon(
                  state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                onPressed: () => bloc.add(ToggleDarkMode()),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'name') {
                    final sorted = List<Todo>.from(state.todos)
                      ..sort((a, b) => a.title.compareTo(b.title));
                    bloc.add(
                      SortTasks(sorted),
                    ); // Only sort, don't change the filter
                  } else if (value == 'status') {
                    final sorted = List<Todo>.from(state.todos)
                      ..sort((a, b) => a.done ? 1 : -1);
                    bloc.add(
                      SortTasks(sorted),
                    ); // Only sort, don't change the filter
                  }
                },
                itemBuilder:
                    (_) => [
                      const PopupMenuItem(
                        value: 'name',
                        child: Text('Sort by Name'),
                      ),
                      const PopupMenuItem(
                        value: 'status',
                        child: Text('Sort by Status'),
                      ),
                    ],
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Task input section
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Enter a task',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        bloc.add(AddTask(controller.text));
                        controller.clear();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Filter section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: state.filter == Filter.all,
                      onSelected: (_) => bloc.add(SetFilter(Filter.all)),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Active'),
                      selected: state.filter == Filter.active,
                      onSelected: (_) => bloc.add(SetFilter(Filter.active)),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Completed'),
                      selected: state.filter == Filter.completed,
                      onSelected: (_) => bloc.add(SetFilter(Filter.completed)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Task list section
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final actualIndex = state.todos.indexOf(task);

                      return ListTile(
                       
                        title: Row(
                          children: [
                            Text('${index + 1}. '), // Task number
                            Checkbox(
                              value: task.done,
                              onChanged:
                                  (_) => bloc.add(ToggleDone(actualIndex)),
                            ),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  decoration:
                                      task.done
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final edited = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    final editController =
                                        TextEditingController(text: task.title);
                                    return AlertDialog(
                                      title: const Text('Edit Task'),
                                      content: TextField(
                                        controller: editController,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(
                                                context,
                                                editController.text,
                                              ),
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (edited != null &&
                                    edited.trim().isNotEmpty) {
                                  bloc.add(EditTask(actualIndex, edited));
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () => bloc.add(DeleteTask(actualIndex)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
