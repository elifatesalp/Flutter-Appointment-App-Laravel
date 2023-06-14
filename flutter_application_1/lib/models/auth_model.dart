import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; //update user details when login
  Map<String, dynamic> appointment =
      {}; //update upcoming appointment when login
  List<Map<String, dynamic>> favBc = []; //get latest favorite beautycenter
  List<dynamic> _fav = []; //get all fav beautycenter id in list

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

  //this is to update latest favorite list and notify all widgets
  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

  //and this is to return latest favorite beauty center list
  List<Map<String, dynamic>> get getFavBc {
    favBc.clear(); //clear all previous record before get latest list
    //list out doctor list according to favorite list
    for (var num in _fav) {
      for (var bc in user['beautycenter']) {
        if (num == bc['bc_id']) {
          favBc.add(bc);
        }
      }
    }
    return favBc;
  }

  //when login success, update the status
  void loginSuccess(
      Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;

    user = userData;
    appointment = appointmentInfo;
    if (user['details'] != null && user['details']['fav'] != null) {
      _fav = json.decode(user['details']['fav']);
    }
    notifyListeners();
  }
}
