class Band {
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj.containsKey('id') ? obj['id'] : 'no_id',
        name: obj.containsKey('name') ? obj['name'] : 'no_name',
        votes: obj.containsKey('votes') ? obj['votes'].toInt() : 0,
      );
}
