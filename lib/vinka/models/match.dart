// To parse this JSON data, do
//
//     final matching = matchingFromJson(jsonString);

import 'dart:convert';

List<Matching> matchingFromJson(String str) => List<Matching>.from(json.decode(str).map((x) => Matching.fromJson(x)));

String matchingToJson(List<Matching> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Matching {
    String model;
    int pk;
    Fields fields;

    Matching({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Matching.fromJson(Map<String, dynamic> json) => Matching(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    int matchedMember;
    DateTime matchedAt;
    bool accepted;

    Fields({
        required this.user,
        required this.matchedMember,
        required this.matchedAt,
        required this.accepted,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        matchedMember: json["matched_member"],
        matchedAt: DateTime.parse(json["matched_at"]),
        accepted: json["accepted"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "matched_member": matchedMember,
        "matched_at": matchedAt.toIso8601String(),
        "accepted": accepted,
    };
}
