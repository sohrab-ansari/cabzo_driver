class ApiPath {
  static const String baseUri2 = "https://corezap.smarttechbros.com/api/v1"; 
   // asad server

  // static const String baseUri2 = "https://api.nzcu.framekarts.com/api/v1"; 

  // static const String baseUri = "http://api.corezap.framekarts.com:7000/api/v1";
// 
  // static const String baseUri = "https://api.corezap.framekarts.com/api/v1"; //


   static const String baseUri = "https://corezap.smarttechbros.com/api/v1";


  // static const String baseUri = "https://api.nzcu.framekarts.com/api/v1";
// 

  static const String imagebaseUrl = "https://sgp1.digitaloceanspaces.com/satyakabir-bucket/";






  // https://api.corezap.framekarts.com

  static String registerLogin = "$baseUri/driver/registerLogin";

  static String verifyOtp = "$baseUri/driver/verifyOtp";

  static String createVehicle = "$baseUri/createVehicle";

  static String createPersonalDetails = "$baseUri/driver/register";

  static String driver_image_uplaod = "$baseUri/driver/update";

  static String driver_home = "$baseUri/driver/home";

  //profile end points

  static String edit_profile = "$baseUri/driver/update";

  static String wallet_api = "$baseUri/wallet";

  static String transactions_api = "$baseUri/transactions";

  // static String ratings_api = "$baseUri/rating/getDriver";


   static String ratings_api = "$baseUri2/rating/getDriver";

  static String bank_account_add = "$baseUri/bank-accounts/add";

  static String withdrawMoney = "$baseUri/payments/withdraw";

  static String addwalletapi = "$baseUri/payments/wallet";

  // static String addwalletapi = "http://34.14.209.4:8000/api/v1/payments/wallet";

  static String payments_verify_api = "$baseUri/payments/verify";

  // static String payments_verify_api = "http://34.14.209.4:8000/api/v1/payments/verify";

  static String rider_History = "$baseUri/payments/verify";

  static String privacy_terms_api = "$baseUri/company/getCompany";

  static String order_verify_otp = "$baseUri/order/verifyOtp";

  // static String order_declined = "$baseUri/order/verify-otp";
}
