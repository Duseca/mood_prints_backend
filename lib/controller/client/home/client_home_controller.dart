import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/client_model/board_model/all_%20board.dart';
import 'package:mood_prints/model/stats/mode_flow_stats_model.dart';
import 'package:mood_prints/model/stats/emotion_stats_model.dart';
import 'package:mood_prints/model/stats/mood_by_sleep.dart';
import 'package:mood_prints/model/stats/sleep_analysis_model.dart';
import 'package:mood_prints/view/screens/client/client_stats/client_stats.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ClientHomeController extends GetxController {
  GlobalKey globalKey = GlobalKey();
  // For Calender
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rxn<DateTime> selectedDay = Rxn<DateTime>(null);

  // For Stats get current month and current year
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  Rxn<MonthModel> selectedMonthModel = Rxn<MonthModel>(null);
  // Board data
  var allBoardsData = <BoardEntry>[].obs;
  var allboardDates = <DateTime>[].obs;
  var filterBoardData = <BoardEntry>[].obs;
  // --- Stats varibles weekly & monthly ---
  // Mood-flow
  RxList<MoodFlowModel>? moodFlowStats = <MoodFlowModel>[].obs;
  RxList<MoodFlowModel>? moodFlowStatsMonthly = <MoodFlowModel>[].obs;
  // Sleep Analysis
  Rx<SleepAnalysisModel?> sleepAnalysisModel = Rx<SleepAnalysisModel?>(null);
  Rx<SleepAnalysisModel?> sleepAnalysisMonthModel =
      Rx<SleepAnalysisModel?>(null);
  RxList<SleepData> sleepStats = <SleepData>[].obs;
  RxList<SleepData> sleepStatsMontly = <SleepData>[].obs; // New

  // Mood bar OR emotion percentage
  List<StressLevelPercentage>? emotionPercentageStats =
      <StressLevelPercentage>[];
  List<StressLevelPercentage>? emotionPercentageStatsMonthly =
      <StressLevelPercentage>[];

  // Mood by sleep
  RxList<MoodSleepStats> moodBySleepStats = <MoodSleepStats>[].obs;
  RxList<MoodSleepStats> moodBySleepStatsMonthly = <MoodSleepStats>[].obs;

  RxInt weekIndex = 1.obs;
  RxInt weekFrontUpdate = 0.obs;
  List<MonthModel> months = [
    MonthModel(name: "January", number: 1),
    MonthModel(name: "February", number: 2),
    MonthModel(name: "March", number: 3),
    MonthModel(name: "April", number: 4),
    MonthModel(name: "May", number: 5),
    MonthModel(name: "June", number: 6),
    MonthModel(name: "July", number: 7),
    MonthModel(name: "August", number: 8),
    MonthModel(name: "September", number: 9),
    MonthModel(name: "October", number: 10),
    MonthModel(name: "November", number: 11),
    MonthModel(name: "December", number: 12),
  ];
  clearAllData() {
    allBoardsData.clear();
    allboardDates.clear();
    emotionPercentageStats?.clear();
    emotionPercentageStatsMonthly?.clear();
    sleepStats.clear();
    sleepStatsMontly.clear();
    moodBySleepStats.clear();
    moodBySleepStatsMonthly.clear();
    weekIndex.value = 1;
    weekFrontUpdate.value = 0;
    sleepAnalysisModel.value = null;
    sleepAnalysisMonthModel.value = null;
    moodFlowStats?.clear();
    moodFlowStatsMonthly?.clear();
    filterBoardData.clear();
    // For Calender
    focusedDay = DateTime.now().obs;
    selectedDay = Rxn<DateTime>(null);

    // For Stats get current month and current year
    currentMonth = DateTime.now().month;
    currentYear = DateTime.now().year;
    selectedMonthModel = Rxn<MonthModel>(null);
  }
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

  // ------- Current Date -----------

  void filterDataByDateTime() {
    filterBoardData.clear();
    for (var filter in allBoardsData) {
      if (selectedDay.value == filter.createdAt) {
        filterBoardData.add(filter);
      }
    }
    log("Filter Board Length : ${filterBoardData.length}");
  }

  // --------------------------------
  // ------- Stats Functions --------
  // --------------------------------

  // --- Mood-flow weekly & montly ---

  Future<void> getModeFlow({String? userID}) async {
    moodFlowStats?.clear();

    final response = await apiService.get(
        buildMoodFlowStatsWeeklyUrl(
            week: weekIndex.value,
            year: currentYear,
            month: currentMonth,
            userId: userID),
        true,
        showResult: false,
        successCode: 200);
    log(" --- Mode Flow Stats Weekly ---");

    if (response != null) {
      final List<dynamic>? data = response['data'];

      if (data != null && data.isNotEmpty) {
        // Weekly data

        List<MoodFlowModel> moodList =
            data.map((item) => MoodFlowModel.fromJson(item)).toList();
        moodFlowStats?.addAll(moodList);
      }
    }
  }

  Future<void> getModeFlowMonthly({String? userID}) async {
    moodFlowStatsMonthly?.clear();

    final response = await apiService.get(
        buildMoodFlowStatsMontlyUrl(
            year: currentYear,
            month: selectedMonthModel.value!.number,
            userId: userID),
        true,
        showResult: false,
        successCode: 200);

    log(" --- Mode Flow Stats Montly ---");

    if (response != null) {
      final List<dynamic>? data = response['data'];

      if (data != null && data.isNotEmpty) {
        List<MoodFlowModel> moodList =
            data.map((item) => MoodFlowModel.fromJson(item)).toList();
        moodFlowStatsMonthly?.addAll(moodList);

        log("Montly Flow Stats Length: ${moodFlowStatsMonthly?.length}");
      }
    }
  }

  // ---- Sleep-stats weekly & montly ----

  Future<void> getSleepStats({String? userID}) async {
    sleepStats.clear();

    final response = await apiService.get(
      buildSleepAnalysisStatsUrl(
          week: weekIndex.value,
          year: currentYear,
          month: currentMonth,
          userId: userID),
      false,
      showResult: false,
      successCode: 200,
    );
    log(" --- Sleep weekly stats montly ---");

    if (response != null) {
      final report = response['report'];
      if (report != null) {
        SleepAnalysisModel model = SleepAnalysisModel.fromJson(report);

        if (model.dateWiseSleepStats != null &&
            model.dateWiseSleepStats!.isNotEmpty) {
          sleepAnalysisModel.value = model;
          sleepStats.addAll(model.dateWiseSleepStats!);
          log("Sleep report weekly length:-> ${sleepStats.length}");
        }
      }
    }
  }

  Future<void> getSleepStatsMontly({String? userID}) async {
    sleepStatsMontly.clear();

    final response = await apiService.get(
      buildSleepAnalysisStatsMonthlyUrl(
          year: currentYear,
          month: selectedMonthModel.value!.number,
          userId: userID),
      false,
      showResult: false,
      successCode: 200,
    );
    log(" --- Sleep analysis stats montly ---");

    if (response != null) {
      final report = response['report'];
      if (report != null) {
        SleepAnalysisModel model = SleepAnalysisModel.fromJson(report);

        if (model.dateWiseSleepStats != null &&
            model.dateWiseSleepStats!.isNotEmpty) {
          sleepAnalysisMonthModel.value = model;
          sleepStatsMontly.addAll(model.dateWiseSleepStats!);
          log("Sleep report monthly length:-> ${sleepStatsMontly.length}");
        }
      }
    }
  }

  //---------- Emotion stats weekly & monthly-----------

  Future<void> getEmotionStats({String? userID}) async {
    emotionPercentageStats?.clear();

    Map<String, dynamic>? response = await apiService.get(
        buildMoodBarStatsUrl(
            week: weekIndex.value,
            year: currentYear,
            month: currentMonth,
            userId: userID),
        false,
        showResult: false,
        successCode: 200);
    log("Mood-Bar weekly called");

    if (response != null) {
      final report = response['report'];

      if (report != null && report.isNotEmpty) {
        EmotionStatsModel model = EmotionStatsModel.fromJson(report);
        if (model.stressLevelPercentages != null) {
          emotionPercentageStats
              ?.addAll(model.stressLevelPercentages!.toList());
          log("Mood-Bar weekly list length:-> ${emotionPercentageStats?.length}");
        }
      }
    }
  }

  Future<void> getEmotionStatsMontly({String? userID}) async {
    emotionPercentageStatsMonthly?.clear();

    Map<String, dynamic>? response = await apiService.get(
        buildMoodBarStatsMontlyUrl(
            year: currentYear,
            month: selectedMonthModel.value!.number,
            userId: userID),
        false,
        showResult: false,
        successCode: 200);

    log("Mood-Bar montly called");

    if (response != null) {
      final report = response['report'];

      if (report != null && report.isNotEmpty) {
        EmotionStatsModel model = EmotionStatsModel.fromJson(report);
        if (model.stressLevelPercentages != null) {
          emotionPercentageStatsMonthly
              ?.addAll(model.stressLevelPercentages!.toList());

          log("Mood-Bar montly list length:-> ${emotionPercentageStatsMonthly?.length}");
        }
      }
    }
  }

  //---------- Get Mood by sleep stats weekly & monthly-----------

  Future<void> getMoodBySleepStats({String? userID}) async {
    moodBySleepStats.clear();

    final response = await apiService.get(
      buildMoodBySleepStatsUrl(
          week: weekIndex.value,
          year: currentYear,
          month: currentMonth,
          userId: userID),
      false,
      showResult: false,
      successCode: 200,
    );
    log("Mood-by-sleep weekly called");

    if (response != null) {
      final report = response['report'];
      if (report != null) {
        MoodBySleepModel model = MoodBySleepModel.fromJson(report);

        if (model.dateWiseMoodStats.isNotEmpty) {
          moodBySleepStats.addAll(model.dateWiseMoodStats);
          log("Mood By Sleep weekly stats:-> ${moodBySleepStats.length}");
        }
      }
    }
  }

  Future<void> getMoodBySleepStatsMonthly({String? userID}) async {
    moodBySleepStatsMonthly.clear();

    final response = await apiService.get(
      buildMoodBySleepStatsMonthlyUrl(
          year: currentYear,
          month: selectedMonthModel.value!.number,
          userId: userID),
      false,
      showResult: false,
      successCode: 200,
    );
    log("Mood-by-sleep montly called");

    if (response != null) {
      final report = response['report'];
      if (report != null) {
        MoodBySleepModel model = MoodBySleepModel.fromJson(report);

        if (model.dateWiseMoodStats.isNotEmpty) {
          moodBySleepStatsMonthly.addAll(model.dateWiseMoodStats);
          log("Mood By Sleep monthly stats:-> ${moodBySleepStatsMonthly.length}");
        }
      }
    }
  }

  Future<void> allStats({
    String? userID,
  }) async {
    log('Common Stats Called');

    await getModeFlow(userID: userID);
    await getSleepStats(userID: userID);
    await getEmotionStats(userID: userID);
    await getMoodBySleepStats(userID: userID);
    hideLoadingDialog();
  }

  Future<void> allmonthlyStats({
    String? userID,
  }) async {
    showLoadingDialog();
    log('Montly Stats Called');

    selectedMonthModel.value =
        months.firstWhere((month) => month.number == DateTime.now().month);

    await getModeFlowMonthly(userID: userID);
    await getEmotionStatsMontly(userID: userID);
    await getSleepStatsMontly(userID: userID);
    await getMoodBySleepStatsMonthly(userID: userID);
    hideLoadingDialog();
  }

  /*
  ----------------------------
  Export Stats 
  ----------------------------
   */

  final GlobalKey graph1Key = GlobalKey();
  final GlobalKey graph2Key = GlobalKey();
  final GlobalKey graph3Key = GlobalKey();

  RxBool graph1Selected = true.obs;
  RxBool graph2Selected = false.obs;
  RxBool graph3Selected = false.obs;

  Future<Uint8List?> captureGraph(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> exportSelectedGraphsToPDF() async {
    final pdf = pw.Document();
    final List<Uint8List> images = [];

    // ✅ Wait until the widgets are fully built and rendered
    await WidgetsBinding.instance.endOfFrame;

    if (graph1Selected.value) {
      final img = await captureGraph(graph1Key);
      if (img != null) images.add(img);
    }
    if (graph2Selected.value) {
      final img = await captureGraph(graph2Key);
      if (img != null) images.add(img);
    }
    if (graph3Selected.value) {
      final img = await captureGraph(graph3Key);
      if (img != null) images.add(img);
    }

    for (var img in images) {
      final pwImage = pw.MemoryImage(img);
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Center(child: pw.Image(pwImage)),
        ),
      );
    }

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'selected_graphs_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   allmonthlyStats(userID: UserService.instance.userModel.value.id);
  // }

  @override
  void dispose() {
    clearAllData();
    super.dispose();
  }
}
