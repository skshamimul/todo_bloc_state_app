
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<AddTask>(_onAddTask);
    on<EditTask>(_onEditTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleDone>(_onToggleDone);
    on<SetFilter>(_onSetFilter);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<SortTasks>((event, emit) {
      emit(state.copyWith(todos: event.sortedTodos));
    });

    _loadInitialData();
  }

  void _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('darkMode') ?? false;
    final saved = prefs.getString('tasks');
    final tasks =
        saved != null
            ? (json.decode(saved) as List)
                .map((e) => Todo.fromJson(e as Map<String, dynamic>))
                .toList()
            : <Todo>[];

    emit(state.copyWith(todos: tasks, isDarkMode: isDark));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TodoState> emit) async {
    if (event.title.trim().isEmpty) return;
    final updated = [...state.todos, Todo(title: event.title)];
    _saveAndEmit(updated);
  }

  Future<void> _onEditTask(EditTask event, Emitter<TodoState> emit) async {
    final updated = List<Todo>.from(state.todos);
    updated[event.index] = updated[event.index].copyWith(
      title: event.newTitle.trim(),
    );
    _saveAndEmit(updated);
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TodoState> emit) async {
    final updated = List<Todo>.from(state.todos)..removeAt(event.index);
    _saveAndEmit(updated);
  }

  Future<void> _onToggleDone(ToggleDone event, Emitter<TodoState> emit) async {
    final updated = List<Todo>.from(state.todos);
    updated[event.index] = updated[event.index].copyWith(
      done: !updated[event.index].done,
    );
    _saveAndEmit(updated);
  }

  Future<void> _onSetFilter(SetFilter event, Emitter<TodoState> emit) async {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkMode event,
    Emitter<TodoState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = !state.isDarkMode;
    prefs.setBool('darkMode', newMode);
    emit(state.copyWith(isDarkMode: newMode));
  }

  Future<void> _saveAndEmit(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'tasks',
      json.encode(todos.map((e) => e.toJson()).toList()),
    );
    emit(state.copyWith(todos: todos));
  }
}
