import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, EventList;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 1)); // 1초 동안 스플래시 화면 표시
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelloPage(),
      routes: {
        '/hello': (context) => HelloPage(),
        '/mainApp': (context) => HomePage(),
        '/jangsanbum': (context) => JangsanbumPerformancePage(), // JangsanbumPerformancePage 경로 추가
      },
    );
  }
}


class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScaffold({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 120, 156),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}

// JangsanbumPerformancePage의 구현
class JangsanbumPerformancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '공연 정보',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 포스터 이미지
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://i.ibb.co/q76rvpy/Kakao-Talk-20240814-104221626.jpg', // 공연 포스터 URL 입력
                    height: 580,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/replace.png', // 로컬에 있는 플레이스홀더 이미지
                            height: 540,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 공연 제목, 시설명, 제작사, 출연진
              Text(
                '장산범',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '부산 해운대 문화회관',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '부산 장산의 도시괴담 장산범의 이야기를 판소리와 음악극으로 생생하게 풀어내는 스릴러 드라마 1인 창극',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '이향송(소리), 동다운(작곡)',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              // 아이콘 및 정보들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoIconText(
                    icon: Icons.attach_money,
                    text: 'R석(1층) 30000원',
                  ),
                  InfoIconText(
                    icon: Icons.access_time,
                    text: '1시간30분',
                  ),
                  InfoIconText(
                    icon: Icons.theater_comedy,
                    text: '국악',
                  ),
                  InfoIconText(
                    icon: Icons.confirmation_number,
                    text: '티켓 예매',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 코스 확정 버튼
            ],
          ),
        ),
      ),
    );
  }
}

// InfoIconText 클래스는 그대로 사용합니다.
class InfoIconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoIconText({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 242, 242, 242),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Color.fromARGB(255, 255, 120, 156),
            size: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
// 1페이지 ********************************

class HelloPage extends StatefulWidget {
  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  final List<String> imgList = [
    'https://www.kopis.or.kr/upload/pfmPoster/PF_PF246650_240809_093100.jpg',
    'https://i.ibb.co/N3Hw0jz/PF-PF246758-240812-1102461.jpg',
    'https://i.ibb.co/q76rvpy/Kakao-Talk-20240814-104221626.jpg', // 클릭 시 이동
    'https://www.kopis.or.kr/upload/pfmPoster/PF_PF246892_240813_100236.gif',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 검색 기능
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '공연 검색',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 242, 242, 242),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // "추천공연" 텍스트
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '2024 추천 공연',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 이미지 슬라이더
              CarouselSlider(
                options: CarouselOptions(
                  height: 580.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: imgList.map((item) {
                  return GestureDetector(
                    onTap: () {
                      // 특정 이미지를 클릭했을 때 JangsanbumPerformancePage로 이동
                      if (item == 'https://i.ibb.co/q76rvpy/Kakao-Talk-20240814-104221626.jpg') {
                        Navigator.pushNamed(context, '/jangsanbum');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          image: NetworkImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Color.fromRGBO(255, 255, 255, 0.9)
                          : Color.fromRGBO(255, 255, 255, 0.4),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // "축제 ZONE" 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // 왼쪽 정렬
                  children: [
                    Text(
                      '축제 ZONE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('금주 핫한 축제들을 모아왔어요!'),
                  ],
                ),
              ),
              // 가로로 긴 이미지들
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(6, (index) {
                    // 사용할 이미지 URL 리스트
                    final List<String> festivalImages = [
                      'https://www.kopis.or.kr/upload/pfmIntroImage/PF_PF247909_240828_0503500.jpg',
                      'https://www.kopis.or.kr/upload/pfmIntroImage/PF_PF247875_240828_0201100.jpg',
                      'https://www.kopis.or.kr/upload/pfmIntroImage/PF_PF247436_240821_0214010.jpg',
                      'https://www.kopis.or.kr/upload/pfmIntroImage/PF_PF247748_240827_0942490.jpg',
                      'https://www.kopis.or.kr/upload/pfmIntroImage/PF_PF247412_240821_0120060.jpg',
                    ];

                    // 이미지가 리스트의 개수보다 많은 경우를 대비하여 인덱스를 순환하도록 설정
                    String imageUrl = festivalImages[index % festivalImages.length];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 350, // 이미지 가로 길이를 늘림
                        height: 600, // 이미지 세로 길이를 늘림
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              // "추천 코스" 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text(
                      '추천 코스',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.5, // 직사각형 비율 조정
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        // 사용할 이미지 URL 리스트
                        final List<String> courseImages = [
                          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D',
                          'https://lh3.googleusercontent.com/proxy/NjppcGQTBcuGCbJ5ut5loH69vl7c0U4dsKWxnwpf_7NUPTetI12_rmwW_6lBg88tgOm1K-wbPM7nS0cOFUZ9bmKRam59AfHgQuWV-M8aO3nw',
                          'https://cdn.maily.so/n4aeljm08sya64gwracza6d7a3c1',
                          'https://img.freepik.com/free-photo/beautiful-architecture-building-cityscape-in-seoul-city_74190-3218.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1724803200&semt=ais_hybrid',
                        ];

                        // 텍스트 리스트
                        final List<String> courseTitles = [
                          '부산 코스',
                          '여수 코스',
                          '제주 코스',
                          '서울 코스',
                        ];

                        // index를 이용해 이미지와 텍스트 리스트에서 적절한 항목 가져오기
                        String imageUrl = courseImages[index % courseImages.length];
                        String courseTitle = courseTitles[index % courseTitles.length];

                        return Stack(
                          children: [
                            // 배경 이미지
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // 이미지 위에 텍스트 덮기
                            Positioned(
                              bottom: 16.0, // 텍스트 위치 (하단에서 16pt 위로)
                              left: 16.0, // 텍스트 위치 (왼쪽에서 16pt 오른쪽으로)
                              child: Text(
                                courseTitle,
                                style: TextStyle(
                                  color: Colors.white, // 텍스트 색상
                                  fontSize: 20, // 텍스트 크기
                                  fontWeight: FontWeight.bold, // 텍스트 굵기
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0, // 그림자 반경
                                      color: Colors.black, // 그림자 색상
                                      offset: Offset(2.0, 2.0), // 그림자 위치
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 장르별 그리드
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Column(
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}

//2페이지 ********************************

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 페이지 배경을 흰색으로 설정
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 120, 156),
        elevation: 0,
        title: const Text(
          '데이트 코스 AI',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TransportButton(
                icon: Icons.directions_car,
                label: '자가용',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegionSelectionPage(
                        transport: '자가용',
                      ),
                    ),
                  );
                },
              ),
              TransportButton(
                icon: Icons.directions_bus,
                label: '대중교통',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegionSelectionPage(
                        transport: '대중교통',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '데이트 코스를 계획하기 어려운 당신',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '1. 이용할 교통 선택하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '2. 가고싶은 지역 선택하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '3. 데이트 날짜 선택하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '4. 장르 선택하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'AI가 당신만을 위한 데이트를 준비해요',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 255, 120, 156),
                    fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
            ),     
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
        );
  }
}

class TransportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const TransportButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 120, 156),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 255, 255, 255),
              size: 50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({required this.currentIndex, Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // 동일한 아이콘을 다시 클릭하면 새로고침 또는 뒤로 가기 동작을 수행할 수 있음
      if (index == 0 || index == 1) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // 페이지 이동 기능 추가
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/hello');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/mainApp');
        break;
      case 2:
        // 여기에 해당하는 페이지로 이동하도록 추가
        break;
      case 3:
        // 여기에 해당하는 페이지로 이동하도록 추가
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 120, 156),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 0
                      ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.apps, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 1
                      ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.favorite, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 2
                      ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.message, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(3),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 3
                      ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.settings, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 지역 선택 창 **********************
class RegionSelectionPage extends StatelessWidget {
  final String transport;
  const RegionSelectionPage({required this.transport, super.key});

  final regions = const [
    {"name": "서울", "page": SeoulDistrictPage()},
    {"name": "경기", "page": GyeonkiDistrictPage()},
    {"name": "부산", "page": BusanDistrictPage()},
    {"name": "인천", "page": IncheonDistrictPage()},
    {"name": "대구", "page": DaeguDistrictPage()},
    {"name": "광주", "page": GuanjuDistrictPage()},
    {"name": "대전", "page": DaejeonDistrictPage()},
    {"name": "울산", "page": UlsanDistrictPage()},
    {"name": "경남", "page": GyeonnamDistrictPage()},
    {"name": "경북", "page": GyeonbukDistrictPage()},
    {"name": "전남", "page": JeonnamDistrictPage()},
    {"name": "전북", "page": JeonbukDistrictPage()},
    {"name": "충남", "page": ChungnamDistrictPage()},
    {"name": "충북", "page": ChungbukDistrictPage()},
    {"name": "강원", "page": KangwonDistrictPage()},
    {"name": "세종", "page": SejongDistrictPage()},
    {"name": "제주", "page": JejuDistrictPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '지역 선택',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.7,
          ),
          itemCount: regions.length,
          itemBuilder: (context, index) {
            final region = regions[index];
            return RegionButton(
              label: region["name"] as String,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => region["page"] as Widget,
                    settings: RouteSettings(
                      arguments: transport,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RegionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const RegionButton({
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 120, 156),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
    );
  }
}

// 지역구 페이지 클래스 (BaseScaffold를 사용)
class DistrictPage extends StatelessWidget {
  final String title;
  final List<String> districts;

  const DistrictPage({
    required this.title,
    required this.districts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final transport = ModalRoute.of(context)!.settings.arguments as String?;
    return BaseScaffold(
      title: title,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.7,
          ),
          itemCount: districts.length,
          itemBuilder: (context, index) {
            return RegionButton(
              label: districts[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateSelectionPage(
                      title: '${title}/${districts[index]}',
                      transport: transport,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// 날짜 선택 창 **********************
class DateSelectionPage extends StatefulWidget {
  final String title;
  final String? transport;

  const DateSelectionPage({
    required this.title,
    this.transport,
    super.key,
  });

  @override
  _DateSelectionPageState createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: widget.title,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CalendarCarousel<Event>(
            onDayPressed: (date, events) {
              setState(() {
                _selectedDate = date;
              });
            },
            weekendTextStyle: const TextStyle(color: Colors.red),
            selectedDateTime: _selectedDate,
            todayButtonColor: const Color.fromARGB(255, 255, 153, 187),
            selectedDayButtonColor: Color.fromARGB(255, 255, 120, 156),
            headerTextStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 120, 156), // 년/월 텍스트 색상을 pinkAccent로 변경
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            weekdayTextStyle: const TextStyle(
              color: Colors.black, // 평일의 텍스트 색상
              fontWeight: FontWeight.bold,
            ),
            height: 500.0,
            selectedDayTextStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 120, 156),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                final selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreSelectionPage(
                      transport: widget.transport,
                      region: widget.title.split('/')[0],
                      district: widget.title.split('/')[1],
                      date: selectedDateString,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '선택한 날짜: 확인',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 장르 선택 창 **********************
class GenreSelectionPage extends StatefulWidget {
  final String? transport;
  final String region;
  final String district;
  final String date;

  const GenreSelectionPage({
    required this.transport,
    required this.region,
    required this.district,
    required this.date,
    super.key,
  });

  @override
  _GenreSelectionPageState createState() => _GenreSelectionPageState();
}

class _GenreSelectionPageState extends State<GenreSelectionPage> {
  final List<Map<String, dynamic>> genres = [
    {"label": "연극", "icon": Icons.theater_comedy},
    {"label": "뮤지컬", "icon": Icons.music_note},
    {"label": "클래식", "icon": Icons.library_music},
    {"label": "국악", "icon": Icons.filter_vintage},
    {"label": "대중음악", "icon": Icons.music_video},
    {"label": "한국무용", "icon": Icons.directions_run},
    {"label": "대중무용", "icon": Icons.directions_walk},
    {"label": "마술", "icon": Icons.auto_awesome},
    {"label": "오페라", "icon": Icons.album},
    {"label": "힙합/랩", "icon": Icons.mic},
    {"label": "밴드", "icon": Icons.queue_music},
    {"label": "서커스", "icon": Icons.ac_unit},
  ];

  final Set<int> _selectedGenres = {};

  Future<Map<String, dynamic>> sendDataToServer(List<String> selectedGenresList) async {
    // AWS 퍼블릭 IP 주소로 URL 수정
    final url = Uri.parse('http://13.125.76.145/submit');  // 포트 80은 생략 가능

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'transport': widget.transport,
        'region': widget.region,
        'district': widget.district,
        'date': widget.date,
        'genres': selectedGenresList,
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));  // utf8 디코딩 적용
      print("Data sent successfully: $decodedResponse");
      return decodedResponse;
    } else {
      print("Failed to send data: ${response.statusCode}");
      return {};
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '장르 선택',
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '• 중복선택 가능',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 42),
            Flexible(
              child: GridView.builder(
                itemCount: genres.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 50.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final isSelected = _selectedGenres.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedGenres.remove(index);
                        } else {
                          _selectedGenres.add(index);
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color.fromARGB(255, 255, 120, 156)
                                : const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Icon(
                            genres[index]["icon"],
                            size: 32,
                            color: isSelected
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          genres[index]["label"],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 120, 156),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                List<String> selectedGenresList = _selectedGenres
                    .map((index) => genres[index]["label"] as String)
                    .toList();

                // 로딩 화면을 보여줍니다.
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 120, 156),
                      ),
                    );
                  },
                );

                // 서버로 데이터 전송 및 응답 받기
                Map<String, dynamic> responseData = await sendDataToServer(selectedGenresList);

                // 로딩 화면을 닫습니다.
                Navigator.of(context).pop();

                // 코스 요약 페이지로 이동합니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseSummaryPage(
                      transport: widget.transport,
                      region: widget.region,
                      district: widget.district,
                      date: widget.date,
                      genres: selectedGenresList,
                      recommend1: responseData['recommend_fix'], // 서버에서 받은 추천 공연 정보 전달
                      nearbyRestaurants: responseData['nearby_restaurants'] != null
                      ? List<Map<String, dynamic>>.from(responseData['nearby_restaurants'])
                      : [], // null일 경우 빈 리스트로 대체
                      nearbyCafes: responseData['nearby_cafes'] != null
                      ? List<Map<String, dynamic>>.from(responseData['nearby_cafes'])
                      : [], // null일 경우 빈 리스트로 대체
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Text(
                  '코스 생성',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseSummaryPage extends StatelessWidget {
  final String? transport;
  final String region;
  final String district;
  final String date;
  final List<String> genres;
  final Map<String, dynamic>? recommend1;
  final List<Map<String, dynamic>>? nearbyRestaurants;
  final List<Map<String, dynamic>>? nearbyCafes;

  const CourseSummaryPage({
    this.transport,
    required this.region,
    required this.district,
    required this.date,
    required this.genres,
    this.recommend1,
    this.nearbyRestaurants,
    this.nearbyCafes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 데이터가 없는 경우 예외 페이지 표시
    if (recommend1 == null ||
        recommend1!.isEmpty ||
        nearbyRestaurants == null ||
        nearbyRestaurants!.isEmpty ||
        nearbyCafes == null ||
        nearbyCafes!.isEmpty) {
      return BaseScaffold(
        title: '공연 정보',
        body: Center(
          child: Text(
            '공연 정보가 없습니다.\n지역, 날짜, 장르를 변경하여 주세요.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return BaseScaffold(
      title: '공연 정보',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 포스터 이미지
              if (recommend1 != null && recommend1!["포스터이미지경로"] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      recommend1!["포스터이미지경로"],
                      height: 540,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              'assets/replace.png', // 로컬에 있는 플레이스홀더 이미지
                              height: 540,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // 공연 제목, 시설명, 제작사, 출연진
              Text(
                recommend1?["공연명"] ?? "추천 공연 정보 없음",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recommend1?["공연시설명"] ?? "공연 시설 정보 없음",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recommend1?["기획제작사"] ?? "제작사 정보 없음",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recommend1?["공연출연진"] ?? "출연진 정보 없음",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              // 아이콘 및 정보들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoIconText(
                    icon: Icons.attach_money,
                    text: recommend1?["티켓가격"]?.toString().replaceAll(', ', ',\n') ??
                        "가격 정보 없음",
                  ),
                  InfoIconText(
                    icon: Icons.access_time,
                    text: recommend1?["공연런타임"]?.toString() ?? "런타임 정보 없음",
                  ),
                  InfoIconText(
                    icon: Icons.theater_comedy,
                    text: recommend1?["장르"] ?? "장르 정보 없음",
                  ),
                  InfoIconText(
                    icon: Icons.confirmation_number,
                    text: "티켓 예매",
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 코스 확정 버튼
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 120, 156),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
                  ),
                  onPressed: () {
                    // 새로운 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsPage(
                          // 데이터를 CourseDetailsPage에 전달
                          transport: transport,
                          region: region,
                          district: district,
                          date: date,
                          genres: genres,
                          recommend1: recommend1,
                          nearbyRestaurants: nearbyRestaurants,
                          nearbyCafes: nearbyCafes,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    '공연 확정',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailsPage extends StatelessWidget {
  final String? transport;
  final String region;
  final String district;
  final String date;
  final List<String> genres;
  final Map<String, dynamic>? recommend1;
  final List<Map<String, dynamic>>? nearbyRestaurants;
  final List<Map<String, dynamic>>? nearbyCafes;

  const CourseDetailsPage({
    this.transport,
    required this.region,
    required this.district,
    required this.date,
    required this.genres,
    this.recommend1,
    this.nearbyRestaurants,
    this.nearbyCafes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 공연 시작 시간과 런타임 데이터를 가져옵니다.
    String? startTime = recommend1?["공연시작시간"];
    String? runtime = recommend1?["공연런타임"];

    // 공연 정보가 없는 경우 처리
    if (recommend1 == null) {
      return BaseScaffold(
        title: '코스 안내',
        body: Center(
          child: Text(
            '공연 정보가 없습니다.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // 공연 시간 계산
    String calculatedShowTime = calculateTimeRange(startTime, runtime);

    // 식당과 카페 시간 계산 (공연 시작 시간 기준으로 역산)
    String cafeTime = calculatePreviousTime(startTime, -90);  // 카페: 공연 시작 1시간 30분 전
    String restaurantTime = calculatePreviousTime(startTime, -180);  // 식당: 카페 시작 1시간 30분 전

    return BaseScaffold(
      title: '코스 안내',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 식당 정보 표시
            if (nearbyRestaurants != null && nearbyRestaurants!.isNotEmpty)
              Column(
                children: [
                  CourseStepItem(
                    time: restaurantTime,
                    icon: Icons.restaurant,
                    title: nearbyRestaurants?[0]["title"] ?? "식당 정보 없음",
                    category: nearbyRestaurants?[0]["category"] ?? "카테고리 정보 없음",
                    rating: "4.56", // 예시 평점, 필요시 백엔드 데이터로 대체
                    address: nearbyRestaurants?[0]["roadAddress"],
                    link: nearbyRestaurants?[0]["link"],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onPressed: () {
                        // 이동 경로 확인 코드 또는 함수 호출
                        print('이동 경로 확인');
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )
            else
              const Text("식당 정보가 없습니다."),
            
            // 카페 정보 표시
            if (nearbyCafes != null && nearbyCafes!.isNotEmpty)
              Column(
                children: [
                  CourseStepItem(
                    time: cafeTime,
                    icon: Icons.local_cafe,
                    title: nearbyCafes?[0]["title"] ?? "카페 정보 없음",
                    category: nearbyCafes?[0]["category"] ?? "카테고리 정보 없음",
                    rating: "4.48", // 예시 평점, 필요시 백엔드 데이터로 대체
                    address: nearbyCafes?[0]["roadAddress"],
                    link: nearbyCafes?[0]["link"],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onPressed: () {
                        // 이동 경로 확인 코드 또는 함수 호출
                        print('이동 경로 확인');
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )
            else
              const Text("카페 정보가 없습니다."),

            // 공연 정보 표시
            CourseStepItem(
              time: calculatedShowTime,
              icon: Icons.theater_comedy,
              title: recommend1?["공연명"] ?? "공연 정보 없음",
              category: recommend1?["장르"] ?? "장르 정보 없음",
              rating: "4.50", // 예시 평점, 필요시 백엔드 데이터로 대체
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 공연 시간 계산 (시작 시간 + 런타임)
  String calculateTimeRange(String? startTime, String? runtime) {
    if (startTime == null || runtime == null) {
      return "시간 정보 없음";
    }

    // 공연 시작 시간을 DateTime으로 변환
    DateTime startDateTime = DateFormat("HH:mm").parse(startTime);

    // 런타임을 분으로 변환
    List<String> runtimeParts = runtime.split(' '); // ["1시간", "30분"]
    int hours = 0;
    int minutes = 0;

    for (var part in runtimeParts) {
      if (part.contains("시간")) {
        hours = int.parse(part.replaceAll(RegExp(r'\D'), ''));
      } else if (part.contains("분")) {
        minutes = int.parse(part.replaceAll(RegExp(r'\D'), ''));
      }
    }

    // 종료 시간 계산
    DateTime endDateTime = startDateTime.add(Duration(hours: hours, minutes: minutes));

    // 시작 시간과 종료 시간을 HH:mm 포맷으로 변환
    String formattedStartTime = DateFormat("HH:mm").format(startDateTime);
    String formattedEndTime = DateFormat("HH:mm").format(endDateTime);

    return "$formattedStartTime - $formattedEndTime";
  }

  // 카페와 식당 시간 계산 (공연 시작 시간 기준으로 역산)
  String calculatePreviousTime(String? startTime, int offsetMinutes) {
    if (startTime == null) {
      return "시간 정보 없음";
    }

    // 공연 시작 시간을 DateTime으로 변환
    DateTime startDateTime = DateFormat("HH:mm").parse(startTime);

    // offsetMinutes을 적용해 새로운 시간을 계산
    DateTime newDateTime = startDateTime.add(Duration(minutes: offsetMinutes));

    // 새로운 시간을 HH:mm 포맷으로 변환
    String formattedNewTime = DateFormat("HH:mm").format(newDateTime);

    // 1시간의 시간을 보여주기 위해 종료 시간 계산
    DateTime endDateTime = newDateTime.add(Duration(hours: 1));

    // 종료 시간을 HH:mm 포맷으로 변환
    String formattedEndTime = DateFormat("HH:mm").format(endDateTime);

    return "$formattedNewTime - $formattedEndTime";
  }
}

class CourseStepItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String title;
  final String category;
  final String rating;
  final String? address;
  final String? link;

  const CourseStepItem({
    required this.time,
    required this.icon,
    required this.title,
    required this.category,
    required this.rating,
    this.address,
    this.link,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Icon(icon, size: 40.0, color: Colors.black),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '평점: $rating',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  if (address != null)
                    Text(
                      '주소: $address',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  if (link != null)
                    InkWell(
                      onTap: () {
                        // 링크를 열기 위한 코드 (필요시 url_launcher 패키지 사용)
                        print("Link: $link");
                      },
                      child: const Text(
                        '링크 보기',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 지역구 리스트 및 각 페이지에 대한 클래스
//((****************************************************************************))

const seoulDistricts = [
  '종로', '중구', '용산', '성동', '광진', '동대문', '중랑', '성북', '강북',
  '도봉', '노원', '은평', '서대문', '마포', '양천', '강서', '구로', '금천',
  '영등포', '동작', '관악', '서초', '강남', '송파', '강동',
];

const busanDistricts = [
  '중구', '서구', '동구', '영도구', '부산진', '동래구', '남구', '북구',
  '해운대', '사하구', '금정구', '강서구', '연제구', '수영구', '사상구', '기장군',
];

const daeguDistricts = [
  '중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군',
];

const incheonDistricts = [
  '중구', '동구', '남구', '연수구', '남동구', '부평구', '계양구', '서구',
  '강화군', '옹진군',
];

const guanjuDistricts = [
  '동구', '서구', '남구', '북구', '광산구',
];

const daejeonDistricts = [
  '동구', '중구', '서구', '유성구', '대덕구',
];

const ulsanDistricts = [
  '중구', '남구', '동구', '북구', '울주군',
];

const gyeonkiDistricts = [
  '수원시', '성남시', '의정부', '안양시', '부천시', '광명시', '평택시', '동두천',
  '안산시', '고양시', '과천시', '구리시', '남양주', '오산시', '시흥시', '군포시',
  '의왕시', '하남시', '용인시', '파주시', '이천시', '안성시', '김포시', '화성시',
  '광주시', '양주시', '포천시', '여주군', '연천군', '가평군', '양평군',
];

const kangwonDistricts = [
  '춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시',
  '홍천군', '횡성군', '영월군', '평창군', '정선군', '철원군', '화천군',
  '양구군', '인제군', '고성군', '양양군',
];

const chungbukDistricts = [
  '청주시', '충주시', '제천시', '청원군', '보은군', '옥천군', '영동군',
  '진천군', '괴산군', '음성군', '단양군',
];

const chungnamDistricts = [
  '천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시',
  '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군',
  '태안군',
];

const jeonbukDistricts = [
  '전주시', '군산시', '익산시', '정읍시', '남원시', '김제시', '완주군',
  '진안군', '무주군', '장수군', '임실군', '순창군', '고창군', '부안군',
];

const jeonnamDistricts = [
  '목포시', '여수시', '순천시', '나주시', '광양시', '담양군', '곡성군',
  '구례군', '고흥군', '보성군', '화순군', '장흥군', '강진군', '해남군',
  '영암군', '무안군', '함평군', '영광군', '장성군', '완도군', '진도군',
  '신안군',
];

const gyeonbukDistricts = [
  '포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시',
  '상주시', '문경시', '경산시', '군위군', '의성군', '청송군', '영양군',
  '영덕군', '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군',
  '울진군', '울릉군',
];

const gyeonnamDistricts = [
  '창원시', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시',
  '양산시', '의령군', '함안군', '창녕군', '고성군', '남해군', '하동군',
  '산청군', '함양군', '거창군', '합천군',
];

const jejuDistricts = [
  '제주시', '서귀포시',
];

const SejongDistricts = [
  '세종특별시',
];

class SeoulDistrictPage extends StatelessWidget {
  const SeoulDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '서울', districts: seoulDistricts);
  }
}

class BusanDistrictPage extends StatelessWidget {
  const BusanDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '부산', districts: busanDistricts);
  }
}

class DaeguDistrictPage extends StatelessWidget {
  const DaeguDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '대구', districts: daeguDistricts);
  }
}

class IncheonDistrictPage extends StatelessWidget {
  const IncheonDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '인천', districts: incheonDistricts);
  }
}

class GuanjuDistrictPage extends StatelessWidget {
  const GuanjuDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '광주', districts: guanjuDistricts);
  }
}

class DaejeonDistrictPage extends StatelessWidget {
  const DaejeonDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '대전', districts: daejeonDistricts);
  }
}

class UlsanDistrictPage extends StatelessWidget {
  const UlsanDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '울산', districts: ulsanDistricts);
  }
}

class GyeonkiDistrictPage extends StatelessWidget {
  const GyeonkiDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '경기', districts: gyeonkiDistricts);
  }
}

class KangwonDistrictPage extends StatelessWidget {
  const KangwonDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '강원', districts: kangwonDistricts);
  }
}

class ChungbukDistrictPage extends StatelessWidget {
  const ChungbukDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '충북', districts: chungbukDistricts);
  }
}

class ChungnamDistrictPage extends StatelessWidget {
  const ChungnamDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '충남', districts: chungnamDistricts);
  }
}

class JeonbukDistrictPage extends StatelessWidget {
  const JeonbukDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '전북', districts: jeonbukDistricts);
  }
}

class JeonnamDistrictPage extends StatelessWidget {
  const JeonnamDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '전남', districts: jeonnamDistricts);
  }
}

class GyeonbukDistrictPage extends StatelessWidget {
  const GyeonbukDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '경북', districts: gyeonbukDistricts);
  }
}

class GyeonnamDistrictPage extends StatelessWidget {
  const GyeonnamDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '경남', districts: gyeonnamDistricts);
  }
}

class JejuDistrictPage extends StatelessWidget {
  const JejuDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '제주', districts: jejuDistricts);
  }
}

class SejongDistrictPage extends StatelessWidget {
  const SejongDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DistrictPage(title: '세종', districts: SejongDistricts);
  }
}
