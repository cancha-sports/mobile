class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';

  static const String login = '$baseUrl/auth/login-user';
  static const String register = '$baseUrl/auth/register';
  static const String courts = '$baseUrl/courts';
  static const String establishments = '$baseUrl/establishments';
  static const String bookings = '$baseUrl/court-bookings';
  static const String checkAvailability = '$bookings/check-availability';
  static const String upcomingBookings = '$bookings/upcoming';
  static const String historyBookings = '$bookings/history';
  static const String userBookings = '$bookings/user';
  static const String courtSchedules = '$baseUrl/court-schedules';
}
