import 'package:flutter/material.dart';

class BottomSheetData {
  var bottomSheetTiles = [
    {
      'title': 'Link Jazia to an Equity account',
      'hasSub': true,
      'sub': 'Get funded to complete your purchases',
      'image': 'assets/id.png',
      'color': Colors.greenAccent
    },
    {
      'title': 'Create a personal Equity account',
      'hasSub': true,
      'sub': 'Take 1 minute setup an Equity account and link to Jazia',
      'image': 'assets/bully.png',
      'color': Colors.pink
    },
    {
      'title': 'Sell an item',
      'hasSub': false,
      'sub': '',
      'image': 'assets/lostnfound.png',
      'color': Colors.blue
    },
    {
      'title': 'Settings',
      'hasSub': false,
      'sub': '',
      'image': 'assets/contact.png',
      'color': Colors.green
    },
  ];
}
