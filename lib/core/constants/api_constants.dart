class ApiConstants {
  static String baseUrl = 'http://172.16.16.10:1024';
  static String loginApi = '/api/auth/login';
  static String refreshToken = '/api/auth/refresh-token';
  static String profileApi = '/api/users/single';
  static String profileUpdation = '/api/users/profileUpdation';
  //clinic related
  static String getAllClinics = '/api/clinic/all-clinics';
  static String searchClinic = '/api/clinic/search';
  static String createClinic = "/api/clinic/create-clinic";
  static String deleteClinic = '/api/clinic/clinicRemoval';
  static String updateClinic = '/api/clinic/clinicUpdation';

  //expense related
  static String createExpense = '/api/expense/create-expense';
  static String getAllExpense = '/api/expense/all-expenses';
  static String editExpense = '/api/expense/expenseUpdation';
  static String deleteExpense = "/api/expense/delete-expense";
  static String getExpenseHistory = "/api/expense/history";
  static String getExpenseByDate = '/api/expense/by-date-range';
}
