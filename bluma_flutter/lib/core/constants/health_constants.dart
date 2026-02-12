import 'package:flutter/material.dart';

enum HealthItemType { symptom, mood, flow, discharge }

class HealthItem {
  final String id;
  final String icon;

  const HealthItem({required this.id, required this.icon});
}

const List<HealthItem> symptoms = [
  HealthItem(id: 'im-okay', icon: 'im-okay'),
  HealthItem(id: 'cramps', icon: 'cramps'),
  HealthItem(id: 'tender-breasts', icon: 'tender-breasts'),
  HealthItem(id: 'headache', icon: 'headache'),
  HealthItem(id: 'nausea', icon: 'nausea'),
  HealthItem(id: 'acne', icon: 'acne'),
  HealthItem(id: 'backache', icon: 'backacke'),
  HealthItem(id: 'fatigue', icon: 'fatigue'),
  HealthItem(id: 'hot-flashes', icon: 'hot flashes'),
  HealthItem(id: 'night-sweats', icon: 'night-sweats'),
  HealthItem(id: 'brain-fog', icon: 'brain-fog'),
  HealthItem(id: 'joint-pain', icon: 'joint-pain'),
  HealthItem(id: 'dizziness', icon: 'dizziness'),
  HealthItem(id: 'cravings', icon: 'cravings'),
  HealthItem(id: 'bloating', icon: 'bloating'),
  HealthItem(id: 'constipation', icon: 'constipation'),
  HealthItem(id: 'diarrhea', icon: 'diarrhea'),
  HealthItem(id: 'frequent-urination', icon: 'frequent-urination'),
  HealthItem(id: 'vaginal-dryness', icon: 'vaginal dryness'),
  HealthItem(id: 'insomnia', icon: 'insomnia'),
];

const List<HealthItem> moods = [
  HealthItem(id: 'calm', icon: 'calm'),
  HealthItem(id: 'happy', icon: 'happy'),
  HealthItem(id: 'energetic', icon: 'energetic'),
  HealthItem(id: 'sad', icon: 'sad'),
  HealthItem(id: 'anxious', icon: 'anxious'),
  HealthItem(id: 'confused', icon: 'confused'),
  HealthItem(id: 'irritated', icon: 'irritated'),
  HealthItem(id: 'angry', icon: 'angry'),
  HealthItem(id: 'mood-swings', icon: 'mood-swings'),
  HealthItem(id: 'frisky', icon: 'frisky'),
  HealthItem(id: 'apathetic', icon: 'apathetic'),
  HealthItem(id: 'bored', icon: 'bored'),
];

const List<HealthItem> flows = [
  HealthItem(id: 'light', icon: 'light'),
  HealthItem(id: 'medium', icon: 'medium'),
  HealthItem(id: 'heavy', icon: 'heavy'),
  HealthItem(id: 'blood-clots', icon: 'blood-clots'),
];

const List<HealthItem> discharges = [
  HealthItem(id: 'no-discharge', icon: 'no-discharge'),
  HealthItem(id: 'watery', icon: 'watery'),
  HealthItem(id: 'creamy', icon: 'creamy'),
  HealthItem(id: 'egg-white', icon: 'egg-white'),
  HealthItem(id: 'sticky', icon: 'sticky'),
  HealthItem(id: 'spotting', icon: 'spotting'),
  HealthItem(id: 'unusual', icon: 'unusual'),
  HealthItem(id: 'grey-discharge', icon: 'grey-discharge'),
];

class SelectionColors {
  static const symptom = Color(0xFF6580E2);
  static const mood = Color(0xFFF2C100);
  static const flow = Color(0xFFFF6B9D);
  static const discharge = Color(0xFF9B6BE2);
}
