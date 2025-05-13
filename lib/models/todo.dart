import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String title;
  final bool done;

  const Todo({
    required this.title,
    this.done = false,
  });

  Todo copyWith({String? title, bool? done}) {
    return Todo(
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'done': done};

  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(title: json['title'], done: json['done']);

  @override
  List<Object?> get props => [title, done];
}
