import 'package:flutter/foundation.dart';

/// One question and answer. Phase 1 answers are illustrative samples.
@immutable
class FaqItem {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}