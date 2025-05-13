
import 'package:equatable/equatable.dart';
import '../models/todo.dart';

enum Filter { all, active, completed }

class TodoState extends Equatable {
  final List<Todo> todos;
  final Filter filter;
  final bool isDarkMode;

  const TodoState({
    this.todos = const [],
    this.filter = Filter.all,
    this.isDarkMode = false,
  });

  List<Todo> get filteredTodos {
    switch (filter) {
      case Filter.active:
        return todos.where((todo) => !todo.done).toList();
      case Filter.completed:
        return todos.where((todo) => todo.done).toList();
      case Filter.all:
      default:
        return todos;
    }
  }

  TodoState copyWith({
    List<Todo>? todos,
    Filter? filter,
    bool? isDarkMode,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [todos, filter, isDarkMode];
}
