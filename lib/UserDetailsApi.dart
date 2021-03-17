import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:gitusers/ModelUserDetails.dart';
import 'package:http/http.dart' as http;

class UserDetailsApi {

  StreamController<responseData> userDataController = StreamController.broadcast();

  LinkedHashMap<int, ModelUserDetails> userList = LinkedHashMap();

  getUsers({String page = '0'}) async {

    if(userList != null && userList.length != 0 && page == '0'){
      addStreamEvent(userDataController, responseData.Success);
      return;
    }

    if(page == '0'){
      userList = LinkedHashMap();
    }

    addStreamEvent(userDataController, responseData.Loading);

    var url = 'https://api.github.com/users?since=$page&per_page=50';
    var response = await http.get(Uri.parse(url));

    if(response == null){
      addStreamEvent(userDataController, responseData.Error);
      return;
    }

    if(response.statusCode != 200){
      addStreamEvent(userDataController, responseData.Error);
      return;
    }

    var data = jsonDecode(response.body);

    if(data == null){
      addStreamEvent(userDataController, responseData.Error);
      return;
    }

    List list = (data).map((i) => ModelUserDetails.fromJson(i)).toList();

    for(int i = 0; i < list.length; i++){
      ModelUserDetails obj = list[i];
      int mainId = obj.id;

      if(bookmarkedList != null && bookmarkedList.length != 0){
        for(int j = 0; j < bookmarkedList.keys.length; j++){
          int bmId = int.parse(bookmarkedList.keys.elementAt(j));
          if(mainId == bmId){
            obj.isBookmarked = true;
            break;
          }
        }
      }

      if(!userList.containsKey(mainId)){
        userList[mainId] = obj;
      }

    }

    addStreamEvent(userDataController, responseData.Success);

  }

  addStreamEvent(var controller, var event){
    if(!controller.isClosed){
      controller.add(event);
    }
  }
}

LinkedHashMap<String, ModelUserDetails> bookmarkedList = LinkedHashMap();

getPreference(){
  /*Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  return _prefs;*/
}
enum responseData {Error, Success, Loading}