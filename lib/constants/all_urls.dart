String baseUrl = "https://mood-prints.vercel.app/";
String loginUrl = "${baseUrl}user/login";
String signUpUrl = "${baseUrl}user/signup";
String otpVerificationUrl = "${baseUrl}user/verify-otp";
String updateClientUrl = "${baseUrl}user/update/";
String getClientByIDUrl = "${baseUrl}/user?userId=";
String createBoardUrl = "${baseUrl}board";
String getAllBoardUrl = "${baseUrl}board";
String updateBoardUrl = "${baseUrl}board/";
String getAllTherapistUrl = "${baseUrl}/user/getAllUsers?userType=therapist";
String getChangePasswordUrl = "${baseUrl}user/change-password";

// ------------ Stats Urls ----------------

String modeFlow = "${baseUrl}stats/mood-flow";
String buildMoodFlowStatsUrl(
    {required int week,
    required int year,
    int month = 1,
    String reportType = 'weekly'}) {
  return "$modeFlow?week=$week&year=$year&reportType=weekly&month=$month";
}

String modeBar = "${baseUrl}stats/emotion-stats";
String buildMoodBarStatsUrl(
    {required int week,
    required int year,
    int month = 1,
    String reportType = 'weekly'}) {
  return "$modeBar?week=$week&year=$year&reportType=weekly&month=$month";
}

String sleepAnalysis = "${baseUrl}stats/sleep-stats";
String buildSleepAnalysisStatsUrl(
    {required int week,
    required int year,
    int month = 1,
    String reportType = 'weekly'}) {
  return "$sleepAnalysis?week=$week&year=$year&reportType=weekly&month=$month";
}

String moodBySleep = "${baseUrl}stats/mood-sleep-stats";
String buildMoodBySleepStatsUrl(
    {required int week,
    required int year,
    int month = 1,
    String reportType = 'weekly'}) {
  return "$moodBySleep?week=$week&year=$year&reportType=weekly&month=$month";
}
