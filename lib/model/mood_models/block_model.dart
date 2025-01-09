class BlockModel {
  String id; // Unique identifier for the block
  String type; // Widget type (e.g., "mood", "emotions", "note", etc.)
  String title; // Editable title (e.g., "Emotions", "Today's note")
  List<EmojiWithText> data; // Data specific to the widget type

  BlockModel({
    required this.id,
    required this.type,
    required this.title,
    this.data = const [], // Default to an empty list if not provided
  });

  /// Convert BlockModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'data': data.map((item) => item.toJson()).toList(), // Serialize list
    };
  }

  /// Create BlockModel from JSON
  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => EmojiWithText.fromJson(item))
              .toList() ??
          [], // Deserialize list
    );
  }
}

class EmojiWithText {
  String text;
  String emoji;

  EmojiWithText({required this.text, required this.emoji});

  /// Convert EmojiWithText to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'emoji': emoji,
    };
  }

  /// Create EmojiWithText from JSON
  factory EmojiWithText.fromJson(Map<String, dynamic> json) {
    return EmojiWithText(
      text: json['text'],
      emoji: json['emoji'],
    );
  }
}
