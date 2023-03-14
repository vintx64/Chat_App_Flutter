import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/message.dart';
import '../../../widgets/constants.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  List<Message> messagesList = [];
  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        kMessage: message,
        kTimeMessage: DateTime.now(),
        'id': email,
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  void getMessages() {
    messages
        .orderBy(kTimeMessage, descending: true)
        .snapshots()
        .listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSucess(messages: messagesList));
    });
  }
}
