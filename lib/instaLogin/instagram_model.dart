import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lookbook/Preferences/LoginData.dart';
import 'insta_test.dart';
import 'instagram_constant.dart';

class InstagramModel {
  List<String> userFields = ['id', 'username'];

  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;

  void getAuthorizationCode(String url) {
    authorizationCode = url
        .replaceAll('${InstagramConstant.redirectUri}?code=', '')
        .replaceAll('#_', '');
  }

  Future<void> exchangeForLongLivedToken() async {
    print("I was called");
    var url = Uri.parse('https://graph.instagram.com/access_token'
        '?grant_type=ig_exchange_token'
        '&client_secret=${InstagramConstant.appSecret}'
        '&access_token=${LoginData().getUserAccessToken()}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      var responseData = json.decode(response.body);
      accessToken = responseData['access_token'];
      LoginData().writeUserAccessToken(accessToken!);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  Future<bool> getTokenAndUserID() async {
    var url = Uri.parse('https://api.instagram.com/oauth/access_token');
    final response = await http.post(url, body: {
      'client_id': InstagramConstant.clientID,
      'redirect_uri': InstagramConstant.redirectUri,
      'client_secret': InstagramConstant.appSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code'
    });
    accessToken = json.decode(response.body)['access_token'];
    print(accessToken);
    // var prefs= await SharedPreferences.getInstance();
    LoginData().writeUserAccessToken(accessToken.toString());
    // prefs.setString('accessToken', accessToken.toString());

    userID = json.decode(response.body)['user_id'].toString();
    // prefs.setString('userIdInsta', userID.toString());
    LoginData().writeInstaUserId(userID.toString());

    return (accessToken != null && userID != null) ? true : false;
  }

  Future<bool> getUserProfile() async {
    final fields = userFields.join(',');
    final responseNode = await http.get(Uri.parse(
        'https://graph.instagram.com/$userID?fields=$fields&access_token=$accessToken'));
    var instaProfile = {
      'id': json.decode(responseNode.body)['id'].toString(),
      'username': json.decode(responseNode.body)['username'],
    };
    username = json.decode(responseNode.body)['username'];
    print('username: $username');
    return instaProfile != null ? true : false;
  }

  Future<List<String>> getUserMedia() async {

    // final prefs = await SharedPreferences.getInstance();
    // final accessTokenFromStorage = prefs.getString('accessToken');
    // final userIdFromStorage = prefs.getString('userIdInsta');

    final accessTokenFromStorage = LoginData().getUserAccessToken();
    final userIdFromStorage = LoginData().getUserInstaId();

    print("The access token is : ${accessTokenFromStorage}");
    print("The user id is : ${userIdFromStorage}");
    if (accessTokenFromStorage == null || userIdFromStorage == null) {
      // Handle the error: accessToken or userID is null
      return [];
    }

    final url = Uri.parse(
        'https://graph.instagram.com/$userIdFromStorage/media?fields=id,caption&access_token=$accessTokenFromStorage');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> mediaItems = data['data'];
      return mediaItems.map((item) => item['id'].toString()).toList();
    } else {
      print("getUserMedia ${response.statusCode}");
      print(response.body);
      // Handle the error or throw an exception
      return [];
    }
  }



  Future<Map<String, dynamic>> getMediaDetails(String mediaId) async {
    // final prefs = await SharedPreferences.getInstance();
    // final accessTokenFromStorage = prefs.getString('accessToken');
    final accessTokenFromStorage = LoginData().getUserAccessToken();
    if (accessTokenFromStorage == null) {
      // Handle the error: accessToken is null
      return {};
    }

    final url = Uri.parse(
        'https://graph.instagram.com/$mediaId?fields=id,media_type,media_url,username,timestamp&access_token=$accessTokenFromStorage');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("Hello");
      return json.decode(response.body);
    }
    else {
      print(response.statusCode);
      // Handle the error or throw an exception
      return {};
    }
  }

 static Future<List<InstagramMedia>> fetchMedia() async {
    final InstagramModel instagramModel = InstagramModel(); // Your InstagramModel instance
    List<String> mediaIds = await instagramModel.getUserMedia();
    print("The list is : ");
    print(mediaIds);
    List<InstagramMedia> tempList = [];
    for (String id in mediaIds) {
      var mediaData = await instagramModel.getMediaDetails(id);
      tempList.add(InstagramMedia.fromJson(mediaData));
    }
    return tempList;
  }


}
