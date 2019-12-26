/// 好友
class Friend {
  Friend({
    this.id,
    this.nickName,
    this.avatarUrl,
  });

  /// 主键
  String id;
  /// 昵称
  String nickName;
  /// 头像
  String avatarUrl;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if (other is Friend) {
      return id == other.id;
    }
    return false;
  }
}

/// 会话
class Session {
  Session({
    this.id,
    this.friend,
    String lastMessage,
  }) : lastMessage = lastMessage ?? '';

  /// 主键
  String id;
  /// 好友
  Friend friend;
  /// 最后一条消息
  String lastMessage;

  /// 标题
  String get title => friend.nickName;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if (other is Session) {
      return id == other.id;
    }
    return false;
  }
}

/// 消息
class Message {
  Message({
    this.id,
    this.content,
    this.friend,
    this.session,
    this.type
  });

  /// 主键
  String id;
  /// 内容
  String content;
  /// 好友（发送的消息值为 [null]）
  Friend friend;
  /// 会话
  Session session;

  /// 消息类型
  MessageType type;

  /// 是否为接收到的消息
  bool get isReceived => friend == null;
  /// 是否发送出去的消息
  bool get isDelivered => !isReceived;

  /// 是否为文本消息
  bool get isText => type == MessageType.text;
  /// 是否为图片消息
  bool get isImage => type == MessageType.image;
  /// 是否为语音消息
  bool get isAudio => type == MessageType.audio;
  /// 是否为视频消息
  bool get isVideo => type == MessageType.video;
  /// 是否为位置消息
  bool get isLocation => type == MessageType.location;
  /// 是否为提示消息
  bool get isTips => type == MessageType.tips;
  /// 是否为命令消息
  bool get isCommand => type == MessageType.command;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if (other is Message) {
      return id == other.id;
    }
    return false;
  }
}

/// 消息类型
enum MessageType {
  /// 文本消息
  text,
  /// 图片消息
  image,
  /// 语音消息
  audio,
  /// 视频消息
  video,
  /// 位置消息
  location,
  /// 提示消息
  tips,
  /// 命令消息
  command,
}