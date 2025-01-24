import 'dart:developer';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/board_model/all_%20board.dart';
import 'package:mood_prints/model/mode_stats_model.dart';
import 'package:mood_prints/model/stats/emotion_stats_model.dart';
import 'package:mood_prints/model/stats/sleep_model.dart';

class ClientHomeController extends GetxController {
  var allBoardsData = <BoardEntry>[].obs;
  var allboardDates = <DateTime>[].obs;
  List<DateWiseStressStats>? moodFlowStats = <DateWiseStressStats>[];
  List<DateWiseSleepStats>? sleepStats = <DateWiseSleepStats>[];
  List<StressLevelPercentage>? emotionPercentageStats =
      <StressLevelPercentage>[];

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

  Future<void> getModeWeeklyStats() async {
    moodFlowStats?.clear();
    // showLoadingDialog();

    final response = await apiService.get(
        buildModeStatsUrl(week: 1, year: 2025), false,
        showResult: false, successCode: 200);

    if (response != null) {
      final report = response['report'];

      if (report != null && report.isNotEmpty) {
        ModeStatsModel model = ModeStatsModel.fromJson(report);

        if (model.dateWiseStressStats != null) {
          moodFlowStats?.addAll(model.dateWiseStressStats!.toList());

          log("Report length:-> ${moodFlowStats?.length}");
        }
        log("Mode - Stats - Model :-> ${report['dateWiseStressStats']}");
      }
    }
    // hideLoadingDialog();
  }

  Future<void> getSleepWeeklyStats() async {
    sleepStats?.clear();
    // showLoadingDialog();

    final response = await apiService.get(
        buildSleepStatsUrl(week: 1, year: 2025), false,
        showResult: false, successCode: 200);

    if (response != null) {
      final report = response['report'];

      if (report != null && report.isNotEmpty) {
        SleepModel model = SleepModel.fromJson(report);

        if (model.dateWiseSleepStats.isNotEmpty ||
            model.dateWiseSleepStats != null) {
          sleepStats?.addAll(model.dateWiseSleepStats.toList());
          log("Sleep Report length:-> ${model.dateWiseSleepStats.length}");
        }
        // log("Sleep - Stats - Model :-> ${model.dateWiseSleepStats}");
      }
    }
    // hideLoadingDialog();
  }

  //---------- Emotion Stats -----------

  Future<void> getEmotionStats() async {
    emotionPercentageStats?.clear();
    // showLoadingDialog();

    final response = await apiService.get(
        buildMoodBarStatsUrl(week: 1, year: 2025), false,
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
        // log("emotion Percentage  :-> ${report['stressLevelPercentages']}");
      }
    }
    // hideLoadingDialog();
  }

  Future<void> calledStats() async {
    log('Common Stats Called');
    await getModeWeeklyStats();
    await getSleepWeeklyStats();
    await getEmotionStats();
    hideLoadingDialog();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllBoard();
    calledStats();
  }
}
