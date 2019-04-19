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

  createUserCredentialsPreferences(uuid,jwt,email) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('uuid', uuid);
    prefs.setString('jwt', jwt);
    prefs.setString('email', email);
  }

  createDefaultTeamCredentialPreferences(teamUuid) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('teamUuid', teamUuid);
    Map res ;

    res= {
      'updated': true
    };

    return res;
  }

  getJwt() async {
    return await fileHelper.readJwt();
  }

  getPreferences() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Map<String,String> credentials;

    if(prefs.getString('uuid')!=null && prefs.getString('jwt')!=null){

      credentials = {
        'uuid': prefs.getString('uuid'),
        'jwt': prefs.getString('jwt'),
        'email': prefs.get('email'),
      };

      if(prefs.getString('teamUuid')!=null){
        String teamUuid = prefs.getString('teamUuid');
        credentials['teamUuid'] = teamUuid ;
      }
    }


    return credentials;
  }

  destroyCredentials() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
