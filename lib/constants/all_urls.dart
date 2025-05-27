String baseUrl = "https://mood-prints.vercel.app/";
String loginUrl = "${baseUrl}user/login";
String signUpUrl = "${baseUrl}user/signup";
String otpVerificationUrl = "${baseUrl}user/verify-otp";
String updateUserUrl = "${baseUrl}user/update/";
String getClientByIDUrl = "${baseUrl}/user?userId=";
String createBoardUrl = "${baseUrl}board";
String getAllBoardUrl = "${baseUrl}board";
String updateBoardUrl = "${baseUrl}board/";
String getAllTherapistUrl = "${baseUrl}/user/getAllUsers?userType=therapist";
String getChangePasswordUrl = "${baseUrl}user/change-password";
String checkEmailUrl = "${baseUrl}user/email";

// ------------ Forget Password Urls ----------------
String forgetPasswordUrl = "${baseUrl}user/forget-password";
String resetPasswordUrl = "${baseUrl}user/reset-password";

// ------------ Stats Urls ----------------

String modeFlow = "${baseUrl}stats/mood-flow";
String buildMoodFlowStatsWeeklyUrl(
    {required int week,
    required int year,
    required int month,
    String reportType = 'weekly',
    String? userId}) {
  return "$modeFlow?week=$week&year=$year&reportType=weekly&month=$month&userId=$userId";
}

String buildMoodFlowStatsMontlyUrl(
    {required int year, required int month, String? userId}) {
  return "$modeFlow?month=$month&year=$year&reportType=monthly&userId=$userId";
}

String moodBar = "${baseUrl}stats/emotion-stats";
String buildMoodBarStatsUrl(
    {required int week,
    required int year,
    required int month,
    String? userId,
    String reportType = 'weekly'}) {
  return "$moodBar?week=$week&year=$year&reportType=weekly&month=$month&userId=$userId";
}

String buildMoodBarStatsMontlyUrl(
    {required int year, required int month, String? userId}) {
  return "$moodBar?month=$month&year=$year&reportType=monthly&userId=$userId";
}

String sleepAnalysis = "${baseUrl}stats/sleep-stats";
String buildSleepAnalysisStatsUrl(
    {required int week,
    required int year,
    required int month,
    String reportType = 'weekly',
    String? userId}) {
  return "$sleepAnalysis?week=$week&year=$year&reportType=weekly&month=$month&userId=$userId";
}

String buildSleepAnalysisStatsMonthlyUrl(
    {required int year, required int month, String? userId}) {
  return "$sleepAnalysis?month=$month&year=$year&reportType=monthly&userId=$userId";
}

String moodBySleep = "${baseUrl}stats/mood-sleep-stats";
String buildMoodBySleepStatsUrl(
    {required int week,
    required int year,
    required int month,
    String reportType = 'weekly',
    String? userId}) {
  return "$moodBySleep?week=$week&year=$year&reportType=weekly&month=$month&userId=$userId";
}

String buildMoodBySleepStatsMonthlyUrl(
    {required int year, required int month, String? userId}) {
  return "$moodBySleep?year=$year&reportType=monthly&month=$month&userId=$userId";
}

// ------------ Notification Urls ----------------

String requestNotificationUrl = "${baseUrl}request";
String notificationUrl = "${baseUrl}notification";
