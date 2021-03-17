
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gitusers/ModelUserDetails.dart';
import 'package:gitusers/UserDetailsApi.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {

  TabController _controller;
  UserDetailsApi _user_details_api = UserDetailsApi();
  List tabLabels = ['Users', 'Bookmarked Users'];

  StreamController<bool> _bookmarkController = StreamController.broadcast();
  StreamController<responseData> _bookmarkDataController = StreamController.broadcast();

  @override
  void initState() {

    _user_details_api.getUsers();
    _listenTabController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Dashboard', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Column(
          children: [
            TabBar(
              controller: _controller,
              isScrollable: false,
              labelStyle: TextStyle(
                  fontSize: 14),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.blueGrey,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
              tabs: List.generate(
                tabLabels.length,
                    (index) => Tab(text: tabLabels[index]),
              ),
            ),
            Expanded(child: TabBarView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(
                tabLabels.length, (int index){
                  return _makeDesign(index);
              }
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _listenTabController() {
    _controller = TabController(length: tabLabels.length, vsync: this);
    _controller.addListener(_tabSelection);
  }


  void _tabSelection() {
    _fillData(_controller.index);
  }

  void _fillData(int index) {
    switch(index){
      case 0:
        _user_details_api.getUsers();
        break;
      case 1:
        if(bookmarkedList == null || bookmarkedList.length == 0){
          _bookmarkDataController.add(responseData.Error);
          return;
        }
        _bookmarkDataController.add(responseData.Success);
        break;
    }
  }

  Widget _makeDesign(int index) {
    switch(index){
      case 0:
        return _allUsers();
        break;
      case 1:
        return _bookmarkUser();
        break;
    }
  }

  Widget _allUsers() {
    return StreamBuilder<responseData>(
      stream: _user_details_api.userDataController.stream,
      initialData: responseData.Loading,
      builder: (context, snapshot) {
        if(snapshot.data == responseData.Loading){
          return Center(child: Text('Loading'),);
        }

        if(snapshot.data == responseData.Error){
          return Center(child: Text('No Data At This Moment!'),);
        }

        return ListView.builder(
            itemCount: _user_details_api.userList.keys.length,
            itemBuilder: (context, index){
              var key = _user_details_api.userList.keys.elementAt(index);
              ModelUserDetails obj = _user_details_api.userList[key];

              return Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color.fromRGBO(230, 230, 230, 1),width: 0.3)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          obj.avatarUrl)
                                  )
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(obj.login),
                          )
                        ],
                      ),
                    ),
                    StreamBuilder<bool>(
                        stream: _bookmarkController.stream,
                        builder: (context, snapshot) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            child: obj.isBookmarked ? Icon(Icons.bookmark_outlined, size: 20, color: Colors.amber,) :
                            InkWell(
                                onTap: (){
                                  obj.isBookmarked = true;
                                  _user_details_api.userList[obj.id].isBookmarked = true;
                                  if(!bookmarkedList.containsKey(obj.id)){
                                    bookmarkedList[obj.id.toString()] = obj;
                                  }
                                  _setBookmarkedList();
                                  _bookmarkController.add(true);
                                },
                                child: Icon(Icons.bookmark_border_outlined, size: 20,)),
                          );
                        }
                    )
                  ],
                ),
              );
            });

      }
    );
  }

  Widget _bookmarkUser() {

    return StreamBuilder<responseData>(
      stream: _bookmarkDataController.stream,
      builder: (context, snapshot) {
        if(snapshot.data == responseData.Error){
          return Center(child: Text('No Data At This Moment!'),);
        }

        return ListView.builder(
            itemCount: bookmarkedList.keys.length,
            itemBuilder: (context, index){
              String key = bookmarkedList.keys.elementAt(index);
              ModelUserDetails obj = bookmarkedList[key];
              return Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color.fromRGBO(230, 230, 230, 1),width: 0.3)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          obj.avatarUrl)
                                  )
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(obj.login),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: InkWell(
                          onTap: () async {
                            _user_details_api.userList[obj.id].isBookmarked = false;
                            bookmarkedList.remove(obj.id);
                            _setBookmarkedList();
                            if(bookmarkedList.length == 0){
                              _bookmarkDataController.add(responseData.Error);
                              return;
                            }
                            _bookmarkDataController.add(responseData.Success);
                          },
                          child: Icon(Icons.bookmark_outlined, size: 20, color: Colors.amber,)),
                    )
                  ],
                ),
              );
            });
      }
    );
  }

  void _setBookmarkedList() async {
    try{
      /*SharedPreferences preference = await getPreference();
      preference.setString('bookmarkedList', jsonEncode(bookmarkedList).toString());*/
    }catch(e){
      print(e);
    }
  }
}