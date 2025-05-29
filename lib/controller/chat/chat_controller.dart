import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/firebase_const.dart';
import 'package:mood_prints/model/chat/chat_thread_model.dart';
import 'package:mood_prints/model/chat/message_model.dart';
import 'package:mood_prints/services/firebase_storage/firebase_storage_service.dart';
import 'package:mood_prints/services/image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  TextEditingController textMessageController = TextEditingController();
  RxBool isLoading = false.obs;
  var uuid = Uuid();
  // Image Selection
  Rxn<String> selectedImage = Rxn<String>(null);

  // ---------------- Creating Chat Thread Model ---------------------

  Future<void> creatingChatThread({
    required String participantsID,
    required String myID,
  }) async {
    try {
      DateTime currentDateTime = DateTime.now();
      String chatThreadId = "$myID-$participantsID";
      ChatThreadModel chatThreadModel = ChatThreadModel(
          createdAt: currentDateTime,
          chatType: 'one-to-one',
          lastMessage: '',
          lastMessageType: '',
          unSeenMessage: false,
          lastMessageSeenBy: [],
          likedBy: [],
          deletedBy: [],
          participants: [
            myID,
            participantsID,
          ],
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
    String? lastTextMessage,
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
    required String senderID,
    required String senderName,
    required String senderProfileImage,
    required String threadID,
    String? newMessage,
  }) async {
    try {
      isLoading.value = true;

      String newDocId = uuid.v4();

      MessageModel msgModel = MessageModel(
        sentBy: senderID,
        sentAt: DateTime.now(),
        senderName: senderName,
        senderProfileImage: senderProfileImage,
        messageId: newDocId,
        // messageType: type,
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
        lastMessageTime: DateTime.now(),
        chatImage: senderProfileImage,
        chatName: senderName,
        lastMessageType: type,
        unSeenMessage: false,
      );

      log("Message send");

      textMessageController.clear();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log("Message sending erorr: $e");
    }
  }

  // --------- Image Type Chat -------------

  Future<void> imageFromGallery() async {
    await ImagePickerService().pickMedia(isImage: true, fromGallery: true);
    selectedImage.value = ImagePickerService().activeMedia.value;
    Get.close(1);
  }

  Future<void> imageFromCamera() async {
    await ImagePickerService().pickMedia(isImage: true, fromGallery: false);
    selectedImage.value = ImagePickerService().activeMedia.value;
    Get.close(1);
  }

  // Image from gallery

  Future<void> messagesPictureHandler({
    required dynamic type,
    required String senderID,
    required String senderName,
    required String senderProfileImage,
    required String threadID,
  }) async {
    try {
      isLoading.value = true;

      String newDocId = uuid.v4();

      String? downloadImageUrl;
      if (selectedImage.value != null) {
        downloadImageUrl = await FirebaseStorageService.instance.uploadImage(
            imagePath: selectedImage.value!, storageFolderPath: 'chat_images');
      }
      log('download url is: $downloadImageUrl');

      MessageModel msgModel = MessageModel(
        sentBy: senderID,
        sentAt: DateTime.now(),
        senderName: senderName,
        senderProfileImage: senderProfileImage,
        messageId: newDocId,
        messageType: type,
        pictureMedia: downloadImageUrl,
        isSeen: false,
        textMessage: '',
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
        lastTextMessage: 'Picture',
        lastMessageTime: DateTime.now(),
        chatImage: senderProfileImage,
        chatName: senderName,
        lastMessageType: type,
        unSeenMessage: false,
      );

      log("Picture Message send");
      selectedImage.value = null;
      downloadImageUrl = null;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log("Message sending erorr: $e");
    }
  }
}
