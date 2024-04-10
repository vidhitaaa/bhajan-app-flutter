// To parse this JSON data, do
//
//     final bhajandetails = bhajandetailsFromJson(jsonString);

import 'dart:convert';

Bhajandetails bhajandetailsFromJson(String str) =>
    Bhajandetails.fromJson(json.decode(str));

String bhajandetailsToJson(Bhajandetails data) => json.encode(data.toJson());

class Bhajandetails {
  String uniqueId;
  DateTime createdAt;
  int sequenceNo;
  String slug;
  String altTitle;
  String composer;
  String titleHindi;
  String titleEnglish;
  String coverPhoto;
  String lyricsHindi;
  String lyricsEnglish;
  String audioUrl;

  Bhajandetails({
    required this.uniqueId,
    required this.createdAt,
    required this.sequenceNo,
    required this.slug,
    required this.altTitle,
    required this.composer,
    required this.titleHindi,
    required this.titleEnglish,
    required this.coverPhoto,
    required this.lyricsHindi,
    required this.lyricsEnglish,
    required this.audioUrl,
  });

  factory Bhajandetails.fromJson(Map<String, dynamic> json) => Bhajandetails(
        uniqueId: json["unique_id"],
        createdAt: DateTime.parse(json["created_at"]),
        sequenceNo: json["sequence_no"],
        slug: json["slug"],
        altTitle: json["alt_title"],
        composer: json["composer"],
        titleHindi: json["title_hindi"],
        titleEnglish: json["title_english"],
        coverPhoto: json["cover_photo"],
        lyricsHindi: json["lyrics_hindi"],
        lyricsEnglish: json["lyrics_english"],
        audioUrl: json["audio_url"],
      );

  Map<String, dynamic> toJson() => {
        "unique_id": uniqueId,
        "created_at": createdAt.toIso8601String(),
        "sequence_no": sequenceNo,
        "slug": slug,
        "alt_title": altTitle,
        "composer": composer,
        "title_hindi": titleHindi,
        "title_english": titleEnglish,
        "cover_photo": coverPhoto,
        "lyrics_hindi": lyricsHindi,
        "lyrics_english": lyricsEnglish,
        "audio_url": audioUrl,
      };
}
