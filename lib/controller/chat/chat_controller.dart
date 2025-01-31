import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/firebase_const.dart';
import 'package:mood_prints/model/chat/chat_thread_model.dart';
import 'package:mood_prints/model/chat/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  TextEditingController textMessageController = TextEditingController();
  // List participantsIDs = [];
  RxBool isLoading = false.obs;
  var uuid = Uuid();
  DateTime currentDateTime = DateTime.now();

  Future<void> creatingChatThread({
    required List<String> participants,
    // required String participantsID,
    // required String myID,
    required String chatThreadId,
    // required chatName,
    // required chatImage
  }) async {
    try {
      ChatThreadModel chatThreadModel = ChatThreadModel(
          createdAt: currentDateTime,
          chatType: participants.length > 2 ? 'group' : 'one-to-one',
          lastMessage: '',
          lastMessageType: '',
          unSeenMessage: false,
          lastMessageSeenBy: [],
          likedBy: [],
          deletedBy: [],
          participants: participants,
          // [
          //   '$participantsID',
          //   '$myID',
          // ],
          receiverImage: '',
          receiverName: '',
          chatThreadId: chatThreadId,
          receiverID: '');

      await chatCollection.doc(chatThreadId).set(chatThreadModel.toMap());

      log('Chat-thread created');
    } catch (e) {
      log('Chat-thread Error while creating: -----> $e');
    }
  }

  // -------> Update chat thread <----------

  Future<void> updateChatThread({
    required String chatThreadId,
    required String chatImage,
    required String chatName,
    required DateTime lastMessageTime,
    required String lastMessageType,
    required bool unSeenMessage,
    required String lastTextMessage,
  }) async {
    try {
      await chatCollection.doc(chatThreadId).update({
        // 'eventImage': eventImage,
        'chatThreadId': chatThreadId,
        'chatName': chatName,
        'chatImage': chatImage,
        'lastMessageTime': lastMessageTime,
        'lastMessage': lastTextMessage,
        'lastMessageType': lastMessageType,
        'unSeenMessage': unSeenMessage,
      });

      log('---> Chat thread Updated <---');
    } catch (e) {
      log('Error Occurs during updating chat thread: ---> $e');
    }
  }

  Future<void> messagesHandler({
    required dynamic type,
    required String userID,
    required String senderName,
    required String senderProfileImage,
    required String threadID,
    String? newMessage,
  }) async {
    try {
      isLoading.value = true;

      String newDocId = uuid.v4();
      // DateTime currentDateTime = DateTime.now();

      MessageModel msgModel = MessageModel(
        sentBy: userID,
        sentAt: currentDateTime,
        senderName: senderName,
        senderProfileImage: senderProfileImage,
        messageId: newDocId,
        messageType: type,
        textMessage: textMessageController.text.trim(),
        isSeen: false,
        seenBy: [],
        deletedBy: [],
      );

      await chatCollection
          .doc(threadID)
          .collection('messages')
          .doc(newDocId)
          .set(msgModel.toMap());

      await updateChatThread(
        chatThreadId: threadID,
        lastTextMessage: textMessageController.text.trim(),
        lastMessageTime: currentDateTime,
        chatImage: senderProfileImage,
        chatName: senderName,
        lastMessageType: type,
        unSeenMessage: false,
      );

      // Update Chat thread

      // await chatCollection.doc(threadID).update({
      //   'lastMessage': newMessage,
      //   'lastMessageDateTime': currentDateTime.toLocal(),
      //   'lastMessageType': type,
      // });

      log("Message send");

      textMessageController.clear();
      isLoading.value = false;

      // chatCollection
    } catch (e) {
      isLoading.value = false;
      log("Message sending erorr: $e");
    }
  }

  // String sortIds({String ids = '5678-1234'}) {
  //   List<String> parts = ids.split('-').map((part) => part.trim()).toList();
  //   log("Pats:--> ${parts}");

  //   parts.sort();
  //   var result = parts.join('-');
  //   log("Result:--> ${result}");
  //   return result;
  // }
}
