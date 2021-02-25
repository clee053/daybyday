

class Post {

  final String title;
  final String content;
  final DateTime posttime;
  final DateTime actualdate;

  Post({ this.title, this.content, this.posttime, this.actualdate});

  Post.fromData(Map<String, dynamic> data):
        title = data['title'], content = data['content'], posttime = data['posttime'], actualdate = data['actualdate'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'posttime': posttime,
      'actualdate': actualdate,

    };
  }
}