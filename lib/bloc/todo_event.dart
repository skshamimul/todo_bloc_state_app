import 'todo_state.dart';
import '../models/todo.dart';
// Abstract base class for all events
abstract class TodoEvent {}

// Event to add a new task
class AddTask extends TodoEvent {
  final String title;
  AddTask(this.title);
}

// Event to sort the tasks
class SortTasks extends TodoEvent {
  final List<Todo> sortedTodos;
  SortTasks(this.sortedTodos);
}

// Event to edit a task's title
class EditTask extends TodoEvent {
  final int index;
  final String newTitle;
  EditTask(this.index, this.newTitle);
}

// Event to delete a task
class DeleteTask extends TodoEvent {
  final int index;
  DeleteTask(this.index);
}

// Event to toggle the completion status of a task
class ToggleDone extends TodoEvent {
  final int index;
  ToggleDone(this.index);
}

// Event to set the filter for the tasks
class SetFilter extends TodoEvent {
  final Filter filter;
  SetFilter(this.filter);
}

// Event to toggle dark mode on or off
class ToggleDarkMode extends TodoEvent {}
