class DetectedLabel {
  final String label;
  final double confidence;

  DetectedLabel({required this.label, required this.confidence});

  @override
  String toString() => 'Label: $label, Confidence: $confidence';
}