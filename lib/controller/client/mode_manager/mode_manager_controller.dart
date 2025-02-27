import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/common_maps.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/client_model/board_model/board_model.dart';
import 'package:mood_prints/model/client_model/mood_models/block_model.dart';
import 'package:mood_prints/model/client_model/mood_models/mood_indicator_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/firebase_storage/firebase_storage_service.dart';
import 'package:mood_prints/services/notification/notification_services.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeManagerController extends GetxController {
  GetStorage storage = GetStorage();
  TextEditingController commonTextController = TextEditingController();
  RxList<BlockModel> activeWidgets = <BlockModel>[].obs;
  RxList<BlockModel> hiddenWidgets = <BlockModel>[].obs;
  RxString selectedEmoji = ''.obs;
  Map<int, bool> visibilityDisplayCustomCards = {};
  // Variables for selecting values related to feeling, stress, and irritability.
  Rx<MoodModel> selectedMood = modeIndicatorItems.first.obs;
  Rx<int?> stressIconHandler = Rx<int?>(null);
  int? stressLevel;
  Rx<int?> irritateIconHandler = Rx<int?>(null);
  int? irritateLevel;

  final selectedEmojiTextModel = Rxn<EmojiWithText>();
  TextEditingController todayNoteController = TextEditingController();
  RxList<String> todayPhotos = <String>[].obs;
  List<String> downloadTodayPhotosUrl = <String>[];
  Rx<DateTime?> startSleepDuration = Rx<DateTime?>(null);
  Rx<DateTime?> endSleepDuration = Rx<DateTime?>(null);
  Rx<DateTime> datePicker = DateTime.now().obs;
  DateTime? dateTime;
  RxBool isStartingSleepRecordSelected = true.obs;

  // Visually timer show how much time is left, for next board creation.
  RxInt remainingTime = 0.obs;
  RxBool isButtonEnabled = false.obs;
  Timer? timer;

  // -------------------------------------------------------------------------
  /* 
  Posting Data throught Api "Creating Board"
  */

  void createBoard() async {
    log("Try Called Create Board");
    try {
      if (todayNoteController.text.isNotEmpty &&
          stressLevel != null &&
          irritateLevel != null &&
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
            mood: selectedMood.value.stressLevel,
            stressLevel: stressLevel,
            irritateLevel: irritateLevel,
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
        await setScheduleNotification();
        await checkTimeLeft();
        await displayCountdownForNextDataEntry();
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

  // ----- Update Board -----------------

  void updateBoard({
    required String boardID,
  }) async {
    log("Try Called Update Board");
    try {
      if (todayNoteController.text.isNotEmpty &&
          stressLevel != null &&
          irritateLevel != null &&
          endSleepDuration.value != null &&
          startSleepDuration.value != null) {
        showLoadingDialog();

        await uploadPhotosTOSorage();

        Sleep sleep = Sleep(
            dozeOffTime: DateTimeService.instance
                .formatTimeToAMPM(endSleepDuration.value),
            wakeupTime: DateTimeService.instance
                .formatTimeToAMPM(startSleepDuration.value));

        BoardModel body = BoardModel(
            id: boardID,
            userId: UserService.instance.userModel.value.id,
            note: todayNoteController.text.trim(),
            mood: selectedMood.value.stressLevel,
            stressLevel: stressLevel,
            irritateLevel: irritateLevel,
            date: datePicker.value,
            createdAt: datePicker.value,
            sleep: sleep,
            photos: downloadTodayPhotosUrl);

        String url = updateBoardUrl + boardID;
        log("Board ID: $boardID");
        log("User ID: ${UserService.instance.userModel.value.id}");

        final response = await apiService.putWithBody(url, body.toJson(), false,
            showResult: true, successCode: 200);

        hideLoadingDialog();

        if (response != null) {
          final status = response['status'];
          // final data = response['data'];

          if (status != null && status.isNotEmpty) {
            if (status == 'success') {
              log("Data Updated Status Code is  -------> : $status");
              await Get.find<ClientHomeController>().getAllBoard();
            }
            // BoardModel boardModel = BoardModel.fromJson(data);
            // log("Data After Board Created: ${boardModel.toString()}");

            log("Status -------> : $status");
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

  void stressedSelector(
    index,
  ) {
    stressIconHandler.value = index;
    stressLevel = stressItems[index].level;
    log("Stress Level: ${stressLevel}");
  }

  void irritableSelector(
    index,
  ) {
    irritateIconHandler.value = index;
    irritateLevel = irritateItems[index].level;
    log("Irritate Level: ${irritateLevel}");
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

  /*
  
   ***************** Algo for enter data after next 8 hours ********************

  */

  Future<void> setScheduleNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;

    // Save timestamp
    await prefs.setInt('last_entry_time', now);
    await prefs.setBool('canEnterData', false);

    // Schedule Notification for 8 hours later
    await NotificationServices().scheduleNotification();
  }

  Future<void> checkTimeLeft() async {
    final prefs = await SharedPreferences.getInstance();
    final lastEntryTime = prefs.getInt('last_entry_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    final timePassed = now - lastEntryTime;
    final totalDuration = Duration(hours: 8, minutes: 0).inMilliseconds;

    if (timePassed >= totalDuration) {
      // Time is up, enable button
      await prefs.setBool('canEnterData', true);
    } else {
      // Still waiting, calculate remaining time
      final remainingTime = totalDuration - timePassed;
      log('⏰ Time left: ${Duration(milliseconds: remainingTime)}');
    }
  }

  // void displayCountdownForNextDataEntry() async {
  //   if (timer != null) {
  //     timer!.cancel(); // 🔹 Prevent multiple timers
  //   }

  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (remainingTime.value > 0) {
  //       remainingTime.value -= 1000; // 🔹 Updates UI automatically
  //     } else {
  //       timer.cancel();
  //       remainingTime.value = 0;
  //     }
  //   });
  // }

  Future<void> displayCountdownForNextDataEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final lastEntryTime = prefs.getInt('last_entry_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final totalDuration = Duration(hours: 8, minutes: 0).inMilliseconds;

    final timePassed = now - lastEntryTime;
    remainingTime.value = totalDuration - timePassed;

    if (remainingTime.value < 0) {
      remainingTime.value = 0;
      await prefs.setBool('canEnterData', true);
    }

    // Start the countdown
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value -= 1000;
      } else {
        timer.cancel();
      }
    });

    update();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void onInit() {
    super.onInit();
    loadBlocks();
    checkTimeLeft();
    displayCountdownForNextDataEntry();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
