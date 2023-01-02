import 'dart:ui';

enum PokemonType {
  normal(nameJp: "ノーマル", color: 0xffaea886),
  fire(nameJp: "ほのお", color: 0xfff45c19),
  water(nameJp: "みず", color: 0xff4a96d6),
  grass(nameJp: "くさ", color: 0xff28b25c),
  electric(nameJp: "でんき", color: 0xffeaa317),
  ice(nameJp: "こおり", color: 0xff45a9c0),
  fighting(nameJp: "かくとう", color: 0xff9a3d3e),
  poison(nameJp: "どく", color: 0xff8f5b98),
  ground(nameJp: "じめん", color: 0xff916d3c),
  flying(nameJp: "ひこう", color: 0xff7e9ecf),
  psychic(nameJp: "エスパー", color: 0xffd56d8b),
  bug(nameJp: "むし", color: 0xff989001),
  rock(nameJp: "いわ", color: 0xff878052),
  ghost(nameJp: "ゴースト", color: 0xff555fa4),
  dragon(nameJp: "ドラゴン", color: 0xff454ba6),
  dark(nameJp: "あく", color: 0xff7a0049),
  steel(nameJp: "はがね", color: 0xff9b9b9b),
  fairy(nameJp: "フェアリー", color: 0xffffbbff),
  ;

  const PokemonType({required this.nameJp, required this.color});

  final String nameJp;
  final int color;

  static PokemonType? getOrNull(String name) {
    const List<PokemonType?> types = PokemonType.values;
    for (var element in types) {
      if (element?.name == name) return element;
    }
    return null;
  }
}
