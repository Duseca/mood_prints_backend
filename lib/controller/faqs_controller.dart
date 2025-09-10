import 'dart:developer';

import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/faq_model.dart';

class FaqsController extends GetxController {
  List<FAQModel> faqs = [];
  var loading = false;
  getFAQs() async {
    try {
      loading = true;
      faqs.clear();
      update(["faqs"]);

      final response = await apiService.getList(faqsUrl, false);
      if (response != null && response.isNotEmpty) {
        faqs = response.map((e) => FAQModel.fromJson(e)).toList();
      }
    } on Exception catch (e) {
      log("Error in getFaqs:: $e");
    } finally {
      loading = false;
      update(["faqs"]);
    }
  }

  @override
  void onInit() {
    getFAQs();
    super.onInit();
  }
}
