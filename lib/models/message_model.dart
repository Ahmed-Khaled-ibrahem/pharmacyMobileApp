class MessageModel {
  late String id;
  late String body;
  late MessageType type;
  double? size;
  double? width;
  late bool isMine;
  late bool seen;

  /// Data base
  // 	"id"	TEXT,
  // 	"body"	TEXT,
  // 	"time"	TEXT,
  // 	"sender"	INTEGER,
  // 	"type"	TEXT,
  // 	"size"	NUMERIC,
  // 	"width"	NUMERIC,
  // 	"status"	INTEGER

  MessageModel({
    Map<String, dynamic>? jsonData,
    String? mId,
    String? mBody,
    MessageType? mType,
    double? mSize,
    double? mWidth,
    bool? mSender,
    bool? mStatus,
  }) {
    if (jsonData != null) {
      id = jsonData['id'];
      body = jsonData['body'];
      type = {
        "text": MessageType.text,
        "image": MessageType.text,
        "file": MessageType.text
      }[jsonData['type']]!;
      size = jsonData['size'];
      width = jsonData['width'];
      isMine = jsonData['sender'] == 0;
      seen = jsonData['status'] == 1;
    } else {
      id = mId!;
      body = mBody!;
      type = mType!;
      size = mSize;
      width = mWidth;
      isMine = mSender!;
      seen = mStatus ?? false;
    }
  }
}

enum MessageType {
  text,
  image,
  file,
}
