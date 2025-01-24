import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/board_model/board_model.dart';
import 'package:mood_prints/model/mood_models/block_model.dart';
import 'package:mood_prints/model/mood_models/mood_indicator_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/firebase_storage/firebase_storage_service.dart';

class ModeManagerController extends GetxController {
  GetStorage storage = GetStorage();
  TextEditingController commonTextController = TextEditingController();
  RxList<BlockModel> activeWidgets = <BlockModel>[].obs;
  RxList<BlockModel> hiddenWidgets = <BlockModel>[].obs;
  RxString selectedEmoji = ''.obs;
  Map<int, bool> visibilityDisplayCustomCards = {};
  Rx<MoodModel> selectedMood = modeIndicatorItems.first.obs;
  Rx<int?> stressIconHandler = Rx<int?>(null);
  int? stressLevel;

  final selectedEmojiTextModel = Rxn<EmojiWithText>();
  TextEditingController todayNoteController = TextEditingController();
  RxList<String> todayPhotos = <String>[].obs;
  List<String> downloadTodayPhotosUrl = <String>[];
  Rx<DateTime?> startSleepDuration = Rx<DateTime?>(null);
  Rx<DateTime?> endSleepDuration = Rx<DateTime?>(null);
  Rx<DateTime> datePicker = DateTime.now().obs;
  DateTime? dateTime;
  RxBool isStartingSleepRecordSelected = true.obs;

  // -------------------------------------------------------------------------
  /* 
  Posting Data throught Api "Creating Board"
  */

  void createBoard() async {
    log("Try Called Create Board");
    try {
      if (todayNoteController.text.isNotEmpty &&
          // selectedFeelingList.isNotEmpty &&
          stressLevel != null &&
          endSleepDuration.value != null &&
          startSleepDuration.value != null) {
        showLoadingDialog();

        await uploadPhotosTOSorage();

        Sleep sleep = Sleep(
            // dozeOffTime: endSleepDuration.value.toString(),
            dozeOffTime: DateTimeService.instance
                .formatTimeToAMPM(endSleepDuration.value),
            wakeupTime: DateTimeService.instance
                .formatTimeToAMPM(startSleepDuration.value));
        // startSleepDuration.value.toString());

        BoardModel body = BoardModel(
            note: todayNoteController.text.trim(),
            stressLevel: stressLevel,
            // selectedMood.value.stressLevel,
            // emotions: feelingListofText,
            date: datePicker.value,
            createdAt: datePicker.value,
            sleep: sleep,
            photos: downloadTodayPhotosUrl);

        final response = await apiService.post(
            createBoardUrl, body.toJson(), false,
            showResult: true, successCode: 201);

        hideLoadingDialog();

        if (response != null) {
          final status = response['status'];
          final data = response['data'];

          if (status != null && status.isNotEmpty) {
            BoardModel boardModel = BoardModel.fromJson(data);
            log("Data After Board Created: ${boardModel.toString()}");

            Get.find<ClientHomeController>().getAllBoard();
          }
        }
        Get.close(1);
        clearBoardEntries();
      } else {
        displayToast(msg: 'Please fill data');
      }

      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  Future<void> uploadPhotosTOSorage() async {
    log("---> Storage function called <---");
    if (todayPhotos.isNotEmpty) {
      for (int i = 0; todayPhotos.length > i; i++) {
        final url = await FirebaseStorageService.instance.uploadImage(
            imagePath: todayPhotos[i], storageFolderPath: 'client_Images');

        // Download urls of uploaded photos and assign to the list
        if (url != null) {
          downloadTodayPhotosUrl.add(url);
        }
      }

      log(" Today photos download urls from Storage -> ${downloadTodayPhotosUrl.length}");
    }
  }

  // ----- Clear create board data ------

  void clearBoardEntries() {
    todayNoteController.clear();
    startSleepDuration.value == null;
    endSleepDuration.value == null;
    stressIconHandler.value == null;
    stressLevel == null;
    todayPhotos.clear();
    downloadTodayPhotosUrl.clear();
    datePicker.value = DateTime.now();
    isStartingSleepRecordSelected.value = true;
  }

  // ------ Emotion Selector -------

  void emotionSelector(
    index,
  ) {
    stressIconHandler.value = index;
    stressLevel = feelingItems[index].stressLevel;
    log("Stress Level: ${stressLevel}");
  }

  // -------------------------------------------------------------------------
  /*
  The code below for the 'Mode Manager Page' handles posting data through APIs 
  and collects images, sleep records, and other mode indicators from the user.  
   */

  void captureClientPhotos() async {
    await imagePicker.pickMedia(isImage: true, fromGallery: false);
    if (imagePicker.activeMedia.value.isNotEmpty) {
      todayPhotos.add(imagePicker.activeMedia.value);
    }

    imagePicker.activeMedia.value = '';
    update();
    log("photos length: ${todayPhotos.length}");
  }

  void removeCaptureClientPhotos(index) {
    todayPhotos.removeAt(index);
    log("removed photo: ${todayPhotos.length}");
    update();
  }

  // --- The Below Code for "Active, Hidden Block" and for "Mode Manager Page" ---.

  // Toggle visibility for a specific widget
  void toggleVisibility(int index) {
    visibilityDisplayCustomCards[index] =
        !(visibilityDisplayCustomCards[index] ?? false);
    update();
  }

  void loadBlocks() {
    // Load active and hidden blocks from storage
    List<dynamic>? activeData = storage.read('activeBlocks');
    List<dynamic>? hiddenData = storage.read('hiddenBlocks');

    if (activeData != null) {
      activeWidgets.value =
          activeData.map((e) => BlockModel.fromJson(e)).toList();
    }
    if (hiddenData != null) {
      hiddenWidgets.value =
          hiddenData.map((e) => BlockModel.fromJson(e)).toList();
    }

    log("Active Blocks: ${activeWidgets.length}");
    log("Hidden Blocks: ${hiddenWidgets.length}");
  }

  void addBlock(BlockModel block) {
    activeWidgets.add(block);
    update();
  }

  void hideBlock(int index) {
    hiddenWidgets.add(activeWidgets[index]);
    activeWidgets.removeAt(index);
    update();
  }

  void unhideBlock(int index) {
    activeWidgets.add(hiddenWidgets[index]);
    hiddenWidgets.removeAt(index);
    update();
  }

  void deleteBlockFromActive(int index) {
    activeWidgets.removeAt(index);
    update();
  }

  void deleteBlockFromHidden(int index) {
    hiddenWidgets.removeAt(index);

    update();
  }

  void updateBlockTitle(int index, String newTitle) {
    activeWidgets[index].title = newTitle;
    update();
  }

  void addNewEmojiAndTitleToList(
      {required String newEmoji,
      required String newTitle,
      required int mainIndex}) {
    if (newEmoji.isNotEmpty && newTitle.isNotEmpty) {
      EmojiWithText model = EmojiWithText(text: newTitle, emoji: newEmoji);

      // Create a modifiable copy of the data list
      List<EmojiWithText> modifiableList =
          List.from(activeWidgets[mainIndex].data);
      modifiableList.add(model);

      // Assign the updated list back
      activeWidgets[mainIndex].data = modifiableList;
    } else {
      displayToast(msg: 'Required icon & text');
    }

    update();
  }

  void saveBlocks() async {
    await storage.write(
        'activeBlocks', activeWidgets.map((e) => e.toJson()).toList());
    await storage.write(
        'hiddenBlocks', hiddenWidgets.map((e) => e.toJson()).toList());

    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadBlocks();
  }
}
