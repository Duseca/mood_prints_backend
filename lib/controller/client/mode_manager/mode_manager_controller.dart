import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/board_model/board_model.dart';
import 'package:mood_prints/model/mood_models/block_model.dart';
import 'package:mood_prints/model/mood_models/feeling_model.dart';
import 'package:mood_prints/model/mood_models/mood_indicator_model.dart';

class ModeManagerController extends GetxController {
  GetStorage storage = GetStorage();
  TextEditingController commonTextController = TextEditingController();
  RxList<BlockModel> activeWidgets = <BlockModel>[].obs;
  RxList<BlockModel> hiddenWidgets = <BlockModel>[].obs;
  RxString selectedEmoji = ''.obs;
  Map<int, bool> visibilityDisplayCustomCards = {};
  // Values selector
  Rx<MoodModel> selectedMood = modeIndicatorItems.first.obs;
  // Feeling
  // Rx<FeelingModel> selectedFeelingModel = feelingItems.first.obs;
  RxList<FeelingModel> selectedFeelingList = <FeelingModel>[].obs;
  List<String> feelingListofText = [];

  final selectedEmojiTextModel = Rxn<EmojiWithText>();
  TextEditingController todayNoteController = TextEditingController();
  RxList<String> todayPhotos = <String>[].obs;
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
    // log("Email ${email}");
    // log("Password ${password}");
    try {
      if (todayNoteController.text.isNotEmpty &&
          selectedFeelingList.isNotEmpty &&
          endSleepDuration.value != null &&
          startSleepDuration.value != null) {
        showLoadingDialog();

        Sleep sleep = Sleep(
            dozeOffTime: endSleepDuration.value.toString(),
            wakeupTime: startSleepDuration.value.toString());

        BoardModel body = BoardModel(
          note: todayNoteController.text.trim(),
          stressLevel: selectedMood.value.stressLevel,
          emotions: feelingListofText,
          date: datePicker.value,
          createdAt: datePicker.value,
          sleep: sleep,
        );

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
          }
        }
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

  // ----- Clear create board data ------
  void clearBoardEntries() {
    todayNoteController.clear();
    startSleepDuration.value == null;
    endSleepDuration.value == null;
    selectedFeelingList.clear();
    feelingListofText.clear();
  }

  // ------ Select multiple values -------

  void selectMultiplesValuesOfFeeling(
    index,
  ) {
    if (selectedFeelingList.contains(feelingItems[index])) {
      selectedFeelingList.remove(feelingItems[index]);
      log("Removed: ${feelingItems[index].text}");
    } else {
      selectedFeelingList.add(feelingItems[index]);
      feelingListofText.add(feelingItems[index].text);
      log("Added: ${feelingItems[index].text}");
      log("feeling list of String: ${feelingListofText}");
    }

    update();
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
