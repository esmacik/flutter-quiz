import 'package:http/http.dart' as http;
import 'dart:convert';

/// Helps log in the user.
class LoginValidator {

  /// Async method that returns `true` if the login was successful and `false` othewise.
  Future<bool> loginUser(String username, String pin) async {
    var params = {
      'user': username,
      'pin': pin
    };

    //var uri = Uri.http('www.cs.utep.edu', '/cheon/cs4381/homework/quiz/login.php', params);
    var uri = Uri.http('cheon.atwebpages.com', '/quiz/login.php', params);
    var resp = await http.get(uri);

    var decoded = json.decode(resp.body);
    var success = decoded['response'];
    return success;
  }
}
