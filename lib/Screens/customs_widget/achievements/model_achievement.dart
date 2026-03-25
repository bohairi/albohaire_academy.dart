import 'package:flutter/material.dart';

class ModelAchievement {
  String? id;
  String urlImage;
  String title;
  String subtitle;
  String describe;
  ModelAchievement({ this.id,required this.urlImage, required this.title, required this.subtitle, required this.describe});

  ModelAchievement copyWith({
    String? id,
    String? urlImage,
    String? title,
    String? subtitle,
    String? describe
  }){
    return ModelAchievement(id: id?? this.id , urlImage: urlImage?? this.urlImage, title: title ?? this.title, subtitle: subtitle ?? this.subtitle, describe: describe ?? this.describe);

  }

  //toMap
  Map<String,dynamic> toMap(){
    return {
      "id" : id,
      "urlImage" : urlImage,
      "title" : title,
      "subtitle" : subtitle,
      "describe" : describe
    };
  }

  //fromMap
  factory ModelAchievement.fromMap(Map<String,dynamic> map, String id){
    return ModelAchievement(id: id,urlImage: map["urlImage"], title: map["title"], subtitle: map["subtitle"], describe: map["describe"]);
  }
   
}

// List <ModelAchievement> cards = [
//     ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150159.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150417.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150449.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150505.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150527.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150159.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150417.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150449.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150505.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),

// ModelAchievement(urlImage: "assets/images/Screenshot 2025-12-30 150527.png", title: "chambion batata magdos", subtitle: "18 medals gold", describe: """Praise be to God, Lord of the Worlds ❤️
// Lin Abu Ein won the gold medal in the national junior team qualifiers 🇯🇴🥇
// We also congratulate player Joy Gharaibeh on winning the bronze medal after losing the semi-final in the final moments, with a commendable fighting performance 🥉💪

// We are proud of all the players on the participating team, especially since most of them are at the beginning of their journey in the 15-17 age group.

// The future is ahead of you… and the best is yet to come, God willing 🔥"""),
//   ];