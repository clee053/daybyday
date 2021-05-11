

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

  final String title;
  final String content;
  final DateTime posttime;
  final DateTime actualdate;
  final String postimage;
  final String searchdate;
  final String day;
  final String month;
  final String year;


  Post({ this.title, this.content, this.posttime, this.actualdate, this.postimage, this.searchdate, this.day, this.month, this.year});

  Post.fromData(Map<String, dynamic> data):
        title = data['title'], content = data['content'], posttime = data['posttime'], actualdate = data['actualdate'],
        postimage = data['postimage'], searchdate = data['searchdate'], day = data['day'], month = data['month'], year = data['year'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'posttime': posttime,
      'actualdate': actualdate,
      'postimage': postimage,
      'searchdate': searchdate,
      'day': day,
      'month': month,
      'year': year,

    };
  }

  Post.fromSnapshot(DocumentSnapshot snapshot) :
      title = snapshot['title'],
        content = snapshot['content'],
        posttime = snapshot['posttime'].toDate(),
        actualdate = snapshot['actualdate'].toDate(),
        postimage = snapshot['postimage'],
        searchdate = snapshot['searchdate'],
        day = snapshot['day'],
        month = snapshot['month'],
      year = snapshot['year'];





}