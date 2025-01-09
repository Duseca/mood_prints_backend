import 'package:flutter/material.dart';

class MoodModel {
  final String text;
  final Color color;
  final String mode;

  // Constructor
  MoodModel({
    required this.text,
    required this.color,
    required this.mode,
  });

  // Factory method to create a Mood instance from a map (for data deserialization)
  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      text: map['text'] as String,
      color: map['color']
          as Color, // You'll need to handle the Color conversion if needed
      mode: map['mode'] as String,
    );
  }

  // Method to convert a Mood instance to a map (for data serialization)
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'color': color, // Ensure proper conversion when serializing
      'mode': mode,
    };
  }
}
