
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_test/Models/Apiir%20data%20models/step.dart';

///
/// This is the bikefit daa model
/// This is used to turn data from firestore to a bikefit object
/// and vice versa
///
class Bikefit {
  final String name;
  final String? normId;
  final List<Step> steps;
  final Timestamp createdAt;
  final String bikeId;
  final String? position;
  final String bid;
  final String uid;
  final String? comment;

  const Bikefit({
    required this.comment,
    required this.name,
    required this.normId,
    required this.steps,
    required this.bid,
    required this.createdAt,
    required this.bikeId,
    required this.position,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "normId": normId,
    'uid': uid,
    "steps": List.generate(
        steps.length,
            (index) => {
          "elbowAngle": steps[index].elbowAngle,
          "handlebarHeight": steps[index].handlebarHeight,
          "handlebarLength": steps[index].handlebarLength,
          "hipAngle": steps[index].hipAngle,
          "image": steps[index].image,
          "kneeAngle": steps[index].kneeAngle,
          "saddleHeight": steps[index].saddleHeight,
          "saddleSetback": steps[index].saddleSetback,
          "shoulderAngle": steps[index].shoulderAngle,
          "videoRef": steps[index].videoRef,
          "changeFrame": steps[index].changeFrame,
          "hipAngleHorizontal": steps[index].hipAngleHorizontal
        }),
    "bid": bid,
    "createdAt": createdAt,
    "bikeId": bikeId,
    "position": position,
    "comment": comment ?? ""
  };

  /// from Json
  factory Bikefit.fromJson(Map<String, dynamic> json) {
    return Bikefit(
        uid: json['cyclistId'] ?? json['uid'] ?? "",
        name: json['name'],
        normId: json['normId'],
        steps: List.generate(
            json["steps"].length,
                (index) => Step(
                elbowAngle: json["steps"][index]["elbowAngle"],
                handlebarHeight: json["steps"][index]["handlebarHeight"],
                handlebarLength: json["steps"][index]["handlebarLength"],
                hipAngle: json["steps"][index]["hipAngle"],
                image: json["steps"][index]["image"] ?? "",
                kneeAngle: json["steps"][index]["kneeAngle"],
                saddleHeight: json["steps"][index]["saddleHeight"],
                saddleSetback: json["steps"][index]["saddleSetback"],
                shoulderAngle: json["steps"][index]["shoulderAngle"],
                videoRef: json["steps"][index]["videoRef"],
                changeFrame: json["steps"][index]["changeFrame"],
                hipAngleHorizontal: json["steps"][index]
                ["hipAngleHorizontal"])),
        bid: json["bid"],
        createdAt: Timestamp(
            json['createdAt']['_seconds'], json['createdAt']['_nanoseconds']),
        bikeId: json["bikeId"],
        position: json["position"],
        comment: json["comment"]);
  }

  /// This is used to turn a firestore snapshot into a user object
  static Bikefit fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    List<dynamic> steps = (snapshot["steps"] as List<dynamic>);

    List<Step> stepsCopy = List.generate(
        snapshot["steps"].length,
            (index) => Step(
            elbowAngle: steps[index]["elbowAngle"],
            handlebarHeight: steps[index]["handlebarHeight"],
            handlebarLength: steps[index]["handlebarLength"],
            hipAngle: steps[index]["hipAngle"],
            image: steps[index]["image"] ?? "",
            kneeAngle: steps[index]["kneeAngle"],
            saddleHeight: steps[index]["saddleHeight"],
            saddleSetback: steps[index]["saddleSetback"],
            shoulderAngle: steps[index]["shoulderAngle"],
            changeFrame: steps[index]["changeFrame"] ?? 0,
            videoRef: steps[index]["videoRef"],
            hipAngleHorizontal: steps[index]["hipAngleHorizontal"] ?? 0));
    return Bikefit(
        normId: snapshot["normId"],
        steps: stepsCopy,
        bid: snapshot["bid"],
        name: snapshot["name"],
        createdAt: snapshot["createdAt"],
        bikeId: snapshot["bikeId"],
        position: snapshot["position"],
        uid: snapshot['uid'],
        comment: snapshot["comment"] ?? "");
  }
}