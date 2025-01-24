String baseUrl = "https://mood-prints.vercel.app/";
String loginUrl = "${baseUrl}user/login";
String signUpUrl = "${baseUrl}user/signup";
String otpVerificationUrl = "${baseUrl}user/verify-otp";
String updateClientUrl = "${baseUrl}user/update/";
String getClientByIDUrl = "${baseUrl}/user?userId=";
String createBoardUrl = "${baseUrl}board";
String getAllBoardUrl = "${baseUrl}board";

// Stats Urls
String modeStatsUrl = "${baseUrl}stats/stress-stats";
// ?week=1&year=2025&reportType=weekly
String buildModeStatsUrl(
    {required int week, required int year, String reportType = 'weekly'}) {
  return "$modeStatsUrl?week=$week&year=$year&reportType=$reportType";
}

// }/stats/sleep-stats?week=1&year=2025&reportType=weekly

String sleepStatsUrl = "${baseUrl}stats/sleep-stats";
String buildSleepStatsUrl(
    {required int week, required int year, String reportType = 'weekly'}) {
  return "$sleepStatsUrl?week=$week&year=$year&reportType=$reportType";
}

// /stats/emotion-stats?week=1&year=2025&reportType=weekly

String moodBarStatsUrl = "${baseUrl}stats/emotion-stats";
String buildMoodBarStatsUrl(
    {required int week, required int year, String reportType = 'weekly'}) {
  return "$moodBarStatsUrl?week=$week&year=$year&reportType=$reportType";
}
