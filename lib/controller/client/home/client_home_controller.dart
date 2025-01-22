import 'dart:developer';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/board_model/all_%20board.dart';
import 'package:mood_prints/model/mode_stats_model.dart';

class ClientHomeController extends GetxController {
  var allBoardsData = <BoardEntry>[].obs;
  var allboardDates = <DateTime>[].obs;

  // Get All Boards

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

          // Parse data as a List and create BoardEntriesResponse
          // final model =
          // BoardEntriesResponse.fromJson(List<dynamic>.from(data));
          log("Get All Data ->  ${allBoardsData.length}");
          log("All Dates length ->  ${allboardDates.length}");

          for (int i = 0; i < allBoardsData.length; i++) {
            log("-------> Mode $i :: ${allBoardsData[i].emotions.toString()} -----");
          }
        }
      }
    }
  }

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

  void mood(String boardId) async {
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

  // ------- Stats --------

  Future<void> getModeWeeklyStats() async {
    showLoadingDialog();

    final response = await apiService.get(
        buildModeStatsUrl(week: 1, year: 2025), false,
        showResult: false, successCode: 200);

    if (response != null) {
      final report = response['report'];

      if (report != null && report.isNotEmpty) {
        ModeStatsModel model = ModeStatsModel.fromJson(report);
        log("Report:-> ${model.toString()}");
      }
    }
    hideLoadingDialog();
  }
}
