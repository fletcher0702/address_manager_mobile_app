import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/file_helper.dart';


class UserService {
  static const COLLECTION = 'user';
  static const DATABASE_NAME='session-jwt.db';
  SharedPreferences preferences;
  FileHelper fileHelper = FileHelper();

  createUserCredentialsCache(jwt) async {
    fileHelper.writeJwt(jwt);
  }

  createUserCredentialsPreferences(uuid,jwt) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('uuid', uuid);
    prefs.setString('jwt', jwt);
  }

  getJwt() async {
    return await fileHelper.readJwt();
  }

  getPreferences() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Map credentials;

    if(prefs.getString('uuid')!=null && prefs.getString('jwt')!=null){

      credentials = {
        'uuid': prefs.getString('uuid'),
        'jwt': prefs.getString('jwt')
      };
    }


    return credentials;
  }

  destroyCredentials() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
