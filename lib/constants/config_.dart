import 'package:zts_counter_desktop/main.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

class Config {
  //Live Config
    String API_ROOT = sharedPrefs.getbaseUrl + 'api/v1/';
   String ICON_ROOT = 'https://zts.afroaves.com/icons/';

  //devlopment Config
  // String API_ROOT = 'http://192.168.43.194:8000/api/v1/';


}
