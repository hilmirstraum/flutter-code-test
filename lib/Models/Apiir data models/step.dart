
///
/// This is the Norm daa model
/// This is used to turn data from firestore to a bikefit object
/// and vice versa
///
class Step {
  final num kneeAngle;
  final num hipAngle;
  final num hipAngleHorizontal;
  final num shoulderAngle;
  final num elbowAngle;
  final num handlebarHeight;
  final num handlebarLength;
  final num saddleHeight;
  final num saddleSetback;
  final num changeFrame;
  String videoRef;
  final String image;

  Step(
      {required this.kneeAngle,
        required this.hipAngle,
        required this.hipAngleHorizontal,
        required this.shoulderAngle,
        required this.elbowAngle,
        required this.handlebarHeight,
        required this.handlebarLength,
        required this.saddleHeight,
        required this.saddleSetback,
        required this.changeFrame,
        required this.videoRef,
        required this.image});

  Map<String, dynamic> toJson() => {
    "elbowAngle": elbowAngle,
    "handlebarHeight": handlebarHeight,
    "handlebarLength": handlebarLength,
    "hipAngle": hipAngle,
    "hipAngleHorizontal": hipAngleHorizontal,
    "image": image,
    "kneeAngle": kneeAngle,
    "saddleHeight": saddleHeight,
    "saddleSetback": saddleSetback,
    "shoulderAngle": shoulderAngle,
    "changeFrame" : changeFrame,
    "videoRef": videoRef
  };
}