import 'package:flutter/material.dart';

class BottomSheetData {
  var bottomSheetTiles = [
    {
      'title': 'Link Jazia to an Equity account',
      'hasSub': true,
      'sub': 'Get funded to complete your purchases',
      'image': 'assets/id.png',
      'color': Colors.greenAccent,
      'page': '/registerform',
    },
    {
      'title': 'Create a personal Equity account',
      'hasSub': true,
      'sub': 'Take 1 minute setup an Equity account and link to Jazia',
      'image': 'assets/bully.png',
      'color': Colors.pink,
      'page': '/registernewform',
    },
    {
      'title': 'Sell an item',
      'hasSub': true,
      'sub': 'Post ads and sell your items, See buyer requests in your category',
      'image': 'assets/lostnfound.png',
      'color': Colors.blue,
      'page':'/verifyseller',
    },
    {
      'title': 'Settings',
      'hasSub': false,
      'sub': '',
      'image': 'assets/contact.png',
      'color': Colors.green,
      'page': '/indevelopment',
    },
  ];
}
