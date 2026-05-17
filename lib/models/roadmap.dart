enum RoadmapStatus { pending, inProgress, done }

class RoadmapTask {
  final String id;
  final String title;
  final String description;
  final String category;
  final int priority;
  RoadmapStatus status;

  RoadmapTask({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    this.priority = 1,
    this.status = RoadmapStatus.pending,
  });
}

class Roadmap {
  final String id;
  final String companyName;
  final String summary;
  final List<RoadmapTask> tasks;
  final DateTime createdAt;

  Roadmap({
    required this.id,
    required this.companyName,
    required this.summary,
    required this.tasks,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
