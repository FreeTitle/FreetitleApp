class Mission {
  Mission({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;

  static List<Mission> categoryMissionList = <Mission>[
    Mission(
      imagePath: 'assets/mission/interFace1.png',
      title: 'Film Project',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Mission(
      imagePath: 'assets/mission/interFace2.png',
      title: 'Film Project',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Mission(
      imagePath: 'assets/mission/interFace1.png',
      title: 'Film Project',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Mission(
      imagePath: 'assets/mission/interFace2.png',
      title: 'Film Project',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
  ];

  static List<Mission> popularMissionList = <Mission>[
    Mission(
      imagePath: 'assets/mission/interFace3.png',
      title: 'A Project',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Mission(
      imagePath: 'assets/mission/interFace4.png',
      title: 'B Project',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Mission(
      imagePath: 'assets/mission/interFace3.png',
      title: 'C Project',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Mission(
      imagePath: 'assets/mission/interFace4.png',
      title: 'D Project',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}
