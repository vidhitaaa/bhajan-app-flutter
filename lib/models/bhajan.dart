import 'dart:convert';

List<Bhajan> bhajanFromJson(String str) =>
    List<Bhajan>.from(json.decode(str).map((x) => Bhajan.fromJson(x)));

String bhajanToJson(List<Bhajan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bhajan {
  String titleHindi;
  String titleEnglish;
  String slug;
  String coverPhoto;

  Bhajan({
    required this.titleHindi,
    required this.titleEnglish,
    required this.slug,
    required this.coverPhoto,
  });

  factory Bhajan.fromJson(Map<String, dynamic> json) => Bhajan(
        titleHindi: json["title_hindi"],
        titleEnglish: json["title_english"],
        slug: json["slug"],
        coverPhoto: json["cover_photo"],
      );

  Map<String, dynamic> toJson() => {
        "title_hindi": titleHindi,
        "title_english": titleEnglish,
        "slug": slug,
        "cover_photo": coverPhoto,
      };
}
// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

// import 'dart:convert';

// List<Post> postFromJson(String str) =>
//     List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

// String postToJson(List<Post> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Post {
//   int userId;
//   int id;
//   String title;
//   String body;

//   Post({
//     required this.userId,
//     required this.id,
//     required this.title,
//     required this.body,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) => Post(
//         userId: json["userId"],
//         id: json["id"],
//         title: json["title"],
//         body: json["body"],
//       );

//   Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "id": id,
//         "title": title,
//         "body": body,
//       };
// }
