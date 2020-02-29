class Mission {
  Mission({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0,
    this.description = 'A interesting mission',
    this.photoURLs
  });

  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;
  String description;
  List<String> photoURLs;

  static List<Mission> popularMissionList = <Mission>[
    Mission(
      imagePath: 'assets/mission/interFace1.png',
      title: 'Film Project',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
    Mission(
      imagePath: 'assets/mission/interFace2.png',
      title: 'Film Project',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
    Mission(
      imagePath: 'assets/mission/interFace1.png',
      title: 'Film Project',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
    Mission(
      imagePath: 'assets/mission/interFace2.png',
      title: 'Film Project',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
  ];

  static List<Mission> latestMissionList = <Mission>[
    Mission(
      imagePath: 'assets/mission/interFace3.png',
      title: 'A Project',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
    Mission(
      imagePath: 'assets/mission/interFace4.png',
      title: 'B Project',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
    Mission(
      imagePath: 'assets/mission/interFace3.png',
      title: 'C Project',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
    Mission(
      imagePath: 'assets/mission/interFace4.png',
      title: 'D Project',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
      photoURLs: ['assets/mission/interFace1.png', 'assets/mission/interFace2.png', 'assets/mission/interFace3.png'],
    ),
  ];
}
