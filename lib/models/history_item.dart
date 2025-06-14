class HistoryItem {
  final int id;
  final double a;
  final double b;
  final double c;
  final String result;
  final DateTime createdAt;

  HistoryItem({
    required this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.result,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'a': a,
      'b': b,
      'c': c,
      'result': result,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'],
      a: map['a'],
      b: map['b'],
      c: map['c'],
      result: map['result'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}