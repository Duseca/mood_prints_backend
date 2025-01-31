import 'dart:developer';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/board_model/all_%20board.dart';
import 'package:mood_prints/model/stats/mode_flow_stats_model.dart';
import 'package:mood_prints/model/stats/emotion_stats_model.dart';
import 'package:mood_prints/model/stats/mood_by_sleep.dart';
import 'package:mood_prints/model/stats/sleep_analysis_model.dart';

class ClientHomeController extends GetxController {
  var allBoardsData = <BoardEntry>[].obs;
  var allboardDates = <DateTime>[].obs;
  List<MoodFlowModel>? moodFlowStats = <MoodFlowModel>[];
  Rx<SleepAnalysisModel?> sleepAnalysisModel = Rx<SleepAnalysisModel?>(null);

  // List<SleepAnalysisModel>? sleepStats = <SleepAnalysisModel>[];
  RxList<SleepData> sleepStats = <SleepData>[].obs;
  RxList<MoodSleepStats> moodBySleepStats = <MoodSleepStats>[].obs;

  List<StressLevelPercentage>? emotionPercentageStats =
      <StressLevelPercentage>[];
  RxInt weekIndex = 1.obs;
  RxInt weekFrontUpdate = 0.obs;

  // ------- Get All Boards ------------

  Future<void> getAllBoard() async {
    allBoardsData.clear();
    allboardDates.clear();

    final response = await apiService.get(getAllBoardUrl, false,
        showResult: false, successCode: 200);

    hideLoadingDialog();

    if (response != null) {
      final status = response['status'];
      final List data = response['data'];

      if (status != null && status.isNotEmpty) {
        if (data == null || data.isEmpty) {
          log("No data found in the response.");
        } else {
          for (Map<String, dynamic> d in data) {
            allBoardsData.add(BoardEntry.fromJson(d));
          }

          allboardDates.value =
              allBoardsData.map((entry) => entry.date).toList();

          log("Get All Data ->  ${allBoardsData.length}");
          log("All Dates length ->  ${allboardDates.length}");
        }
      }
    }
  }

  // ------- Delete Board ---------

  void deleteBoard(String boardId) async {
    showLoadingDialog();

    final deleteBoardUrl = "$getAllBoardUrl/" + boardId;

    final response = await apiService.delete(deleteBoardUrl, false,
        showResult: false, successCode: 200);

    if (response != null) {
      final status = response['status'];

      if (status != null && status.isNotEmpty) {
        if (status == 'success') {
          log('Status ------- ${status}');
          getAllBoard();
        }

        log("-----------------------------------------------");
      }
    }

    hideLoadingDialog();
  }

  // ------- Update Current Board ---------

  void updateCurrentBoard(String boardId) async {
    showLoadingDialog();

    final deleteBoardUrl = "$getAllBoardUrl/" + boardId;

    final response = await apiService.delete(deleteBoardUrl, false,
        showResult: false, successCode: 200);

    if (response != null) {
      final status = response['status'];

      if (status != null && status.isNotEmpty) {
        if (status == 'success') {
          log('Status ------- ${status}');
          getAllBoard();
        }

        log("-----------------------------------------------");
      }
    }

    hideLoadingDialog();
  }

  // ------- Stats Functions --------

  Future<void> getModeFlowWeeklyStats() async {
    moodFlowStats?.clear();
    // showLoadingDialog();

    log("Mode Flow Stats Hit ------------------------");

    final response = await apiService.get(
        buildMoodFlowStatsUrl(week: weekIndex.value, year: 2025), false,
        showResult: false, successCode: 200);

    if (response != null) {
      final List<dynamic>? data = response['data'];

      if (data != null && data.isNotEmpty) {
        List<MoodFlowModel> moodList =
            data.map((item) => MoodFlowModel.fromJson(item)).toList();
        moodFlowStats?.addAll(moodList);

        log("Report length:-> ${moodFlowStats?.length}");
        log("Mode - Stats - Model :-> ${moodList.map((e) => e.toJson()).toList()}");
      }
    }
    // hideLoadingDialog();
  }

////////////////////////////////
////////////////////////////////
////////////////////////////////
////////////////////////////////
////////////////////////////////
////////////////////////////////
////////////////////////////////
  ///
  Future<void> getSleepWeeklyStats() async {
    sleepStats.clear();

    final response = await apiService.get(
      buildSleepAnalysisStatsUrl(week: weekIndex.value, year: 2025),
      false,
      showResult: false,
      successCode: 200,
    );

    if (response != null) {
      final report = response['report'];
      if (report != null) {
        SleepAnalysisModel model = SleepAnalysisModel.fromJson(report);
        sleepAnalysisModel.value = model;
        if (model.dateWiseSleepStats != null &&
            model.dateWiseSleepStats!.isNotEmpty) {
          sleepStats.addAll(model.dateWiseSleepStats!);
          log("Sleep Report length:-> ${sleepStats.length}");
        }
      }
    }
  }

  //---------- Emotion Stats -----------

  Future<void> getEmotionStats() async {
    emotionPercentageStats?.clear();

    final response = await apiService.get(
        buildMoodBarStatsUrl(week: weekIndex.value, year: 2025), false,
        showResult: false, successCode: 200);

    if (response != null) {
      final report = response['report'];

      if (report != null && report.isNotEmpty) {
        EmotionStatsModel model = EmotionStatsModel.fromJson(report);
        if (model.stressLevelPercentages != null) {
          emotionPercentageStats
              ?.addAll(model.stressLevelPercentages!.toList());
        }
        log("emotion Percentage Stats length :-> ${emotionPercentageStats?.length}");
      }
    }
  }

  // ---------- Get Mode By Sleep --------------

  Future<void> getMoodBySleepStats() async {
    moodBySleepStats.clear();

    final response = await apiService.get(
      buildMoodBySleepStatsUrl(week: weekIndex.value, year: 2025),
      false,
      showResult: false,
      successCode: 200,
    );

    if (response != null) {
      final report = response['report'];
      if (report != null) {
        MoodBySleepModel model = MoodBySleepModel.fromJson(report);

        if (model.dateWiseMoodStats.isNotEmpty) {
          moodBySleepStats.addAll(model.dateWiseMoodStats);
          log("Mood By Sleep stats:-> ${moodBySleepStats.length}");
        }
      }
    }
  }

  Future<void> calledStats() async {
    log('Common Stats Called');
    await getModeFlowWeeklyStats();
    await getSleepWeeklyStats();
    await getEmotionStats();
    await getMoodBySleepStats();
    hideLoadingDialog();
  }

  @override
  void onInit() {
    // TODO: Put Function When User Login Called
    super.onInit();
    getAllBoard();
    calledStats();
  }
}
