import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
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
                label: '승용차',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegionSelectionPage()),
                  );
                },
              ),
              TransportButton(
                icon: Icons.directions_bus,
                label: '대중교통',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegionSelectionPage()),
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
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text('1. 이용할 교통 선택하기'),
                Text('2. 가고싶은 지역 선택하기'),
                Text('3. 데이트 날짜 선택하기'),
                Text('4. 평소 취향 선택하기'),
                SizedBox(height: 16),
                Text(
                  'AI가 당신만을 위한 데이트를 준비해요',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.pinkAccent,
        type: BottomNavigationBarType.fixed,
      ),
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
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// 지역구 선택 창

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
        height: 50, // 버튼 높이를 줄임
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class RegionSelectionPage extends StatelessWidget {
  const RegionSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: const Text(
          '지역 선택',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3, // 한 줄에 3개의 버튼
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 3, // 가로와 세로 비율 조정
          children: [
            RegionButton(
              label: '서울',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeoulDistrictPage(),
                  ),
                );
              },
            ),
            RegionButton(label: '경기', onTap: () {}),
            RegionButton(label: '부산', onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BusanDistrictPage(),
                  ),
                );
            }),
            RegionButton(label: '인천', onTap: () {}),
            RegionButton(label: '대구', onTap: () {}),
            RegionButton(label: '광주', onTap: () {}),
            RegionButton(label: '대전', onTap: () {}),
            RegionButton(label: '울산', onTap: () {}),
            RegionButton(label: '경남', onTap: () {}),
            RegionButton(label: '경북', onTap: () {}),
            RegionButton(label: '전남', onTap: () {}),
            RegionButton(label: '전북', onTap: () {}),
            RegionButton(label: '충남', onTap: () {}),
            RegionButton(label: '충북', onTap: () {}),
            RegionButton(label: '강원', onTap: () {}),
            RegionButton(label: '세종', onTap: () {}),
            RegionButton(label: '제주', onTap: () {}),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.pinkAccent,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// 서울 지역구 선택 창
class SeoulDistrictPage extends StatelessWidget {
  const SeoulDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: const Text(
          '서울',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3, // 한 줄에 3개의 버튼
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 3, // 가로와 세로 비율 조정
          children: [
            RegionButton(label: '종로', onTap: () {}),
            RegionButton(label: '중구', onTap: () {}),
            RegionButton(label: '용산', onTap: () {}),
            RegionButton(label: '성동', onTap: () {}),
            RegionButton(label: '광진', onTap: () {}),
            RegionButton(label: '동대문', onTap: () {}),
            RegionButton(label: '중랑', onTap: () {}),
            RegionButton(label: '성북', onTap: () {}),
            RegionButton(label: '강북', onTap: () {}),
            RegionButton(label: '도봉', onTap: () {}),
            RegionButton(label: '노원', onTap: () {}),
            RegionButton(label: '은평', onTap: () {}),
            RegionButton(label: '서대문', onTap: () {}),
            RegionButton(label: '마포', onTap: () {}),
            RegionButton(label: '양천', onTap: () {}),
            RegionButton(label: '강서', onTap: () {}),
            RegionButton(label: '구로', onTap: () {}),
            RegionButton(label: '금천', onTap: () {}),
            RegionButton(label: '영등포', onTap: () {}),
            RegionButton(label: '동작', onTap: () {}),
            RegionButton(label: '관악', onTap: () {}),
            RegionButton(label: '서초', onTap: () {}),
            RegionButton(label: '강남', onTap: () {}),
            RegionButton(label: '송파', onTap: () {}),
            RegionButton(label: '강동', onTap: () {}),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.pinkAccent,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

//부산 지역구 선택 창
class BusanDistrictPage extends StatelessWidget {
  const BusanDistrictPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: const Text(
          '부산',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3, // 한 줄에 3개의 버튼
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 3, // 가로와 세로 비율 조정
          children: [
            RegionButton(label: '중구', onTap: () {}),
            RegionButton(label: '서구', onTap: () {}),
            RegionButton(label: '동구', onTap: () {}),
            RegionButton(label: '영도구', onTap: () {}),
            RegionButton(label: '부산진구', onTap: () {}),
            RegionButton(label: '동래구', onTap: () {}),
            RegionButton(label: '남구', onTap: () {}),
            RegionButton(label: '북구', onTap: () {}),
            RegionButton(label: '해운대구', onTap: () {}),
            RegionButton(label: '사하구', onTap: () {}),
            RegionButton(label: '금정구', onTap: () {}),
            RegionButton(label: '강서구', onTap: () {}),
            RegionButton(label: '연제구', onTap: () {}),
            RegionButton(label: '수영구', onTap: () {}),
            RegionButton(label: '사상구', onTap: () {}),
            RegionButton(label: '기장군', onTap: () {}),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.pinkAccent,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}