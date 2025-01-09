import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/model/mood_widget_model.dart/block_model.dart';

class ModeManagerController extends GetxController {
  GetStorage storage = GetStorage();
  TextEditingController createNewBlockController = TextEditingController();
  RxList<BlockModel> activeWidgets = <BlockModel>[].obs;
  RxList<BlockModel> hiddenWidgets = <BlockModel>[].obs;
  RxString selectedEmoji = RxString('');

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
    // saveBlocks();
  }

  void hideBlock(int index) {
    hiddenWidgets.add(activeWidgets[index]);
    activeWidgets.removeAt(index);
    // saveBlocks();
  }

  void unhideBlock(int index) {
    activeWidgets.add(hiddenWidgets[index]);
    hiddenWidgets.removeAt(index);
    // saveBlocks();
  }

  void deleteBlock(int index, {bool removeFromActiveList = true}) {
    if (removeFromActiveList) {
      activeWidgets.removeAt(index);
    } else {
      hiddenWidgets.removeAt(index);
    }

    update();
  }

  void updateBlockTitle(int index, String newTitle) {
    activeWidgets[index].title = newTitle;
    update(); // Notify GetBuilder to rebuild
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

      // log("---> Icon & text added Current Index list length ${modifiableList.length}");
      // log("Current data: ${activeWidgets[mainIndex].data}");
    } else {
      displayToast(msg: 'Required icon & text');
      // log("---> Required icon & text");
    }

    update();
  }

  void saveBlocks() async {
    await storage.write(
        'activeBlocks', activeWidgets.map((e) => e.toJson()).toList());
    await storage.write(
        'hiddenBlocks', hiddenWidgets.map((e) => e.toJson()).toList());
  }

  // ----------------- Active Block -----------------
  @override
  void onInit() {
    super.onInit();
    loadBlocks();
  }
}
