class Participant {
  const Participant({
    required this.uid,
    required this.name,
    required this.role,
    required this.community,
    this.joinedAt,
    this.lastSeenAt,
  });

  final String uid;
  final String name;
  final String role;
  final String community;
  final DateTime? joinedAt;
  final DateTime? lastSeenAt;

  @override
  bool operator ==(Object other) {
    return other is Participant &&
        other.uid == uid &&
        other.name == name &&
        other.role == role &&
        other.community == community &&
        other.joinedAt == joinedAt &&
        other.lastSeenAt == lastSeenAt;
  }

  @override
  int get hashCode =>
      Object.hash(uid, name, role, community, joinedAt, lastSeenAt);
}
