class MessageModel {
  late String id;
  late String body;
  late MessageType type;
  double? size;
  double? width;
  late bool isMine;
  late bool seen;
  late String time;

  MessageModel({
    Map<String, dynamic>? jsonData,
    String? mId,
    String? mBody,
    MessageType? mType,
    double? mSize,
    double? mWidth,
    bool? mSender,
    bool? mStatus,
    String? mTime,
  }) {
    if (jsonData != null) {
      id = jsonData['id'];
      body = jsonData['body'];
      time = jsonData['time'];
      type = {
        "text": MessageType.text,
        "image": MessageType.image,
        "file": MessageType.file
      }[jsonData['type']]!;
      size = jsonData['size'];
      width = jsonData['width'];
      isMine = jsonData['sender'] == 0;
      seen = jsonData['status'] == 1;
    } else {
      id = mSender! ? "" : mId!;
      body = mBody!;
      type = mType!;
      size = mSize;
      width = mWidth;
      isMine = mSender;
      seen = mStatus ?? false;
      time = mTime!;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'type': {
        MessageType.text: "text",
        MessageType.image: "image",
        "file": MessageType.text
      }[MessageType],
      'size': size,
      'width': width,
      'time': time,
      'sender': isMine ? 0 : 1,
      'status': seen ? 1 : 0
    };
  }
}

enum MessageType {
  text,
  image,
  file,
}
