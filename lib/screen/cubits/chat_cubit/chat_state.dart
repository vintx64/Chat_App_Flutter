part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSucess extends ChatState {
  List<Message> messages;
  ChatSucess({required this.messages});
}
