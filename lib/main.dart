import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  late final UnityWidgetController controller;
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Unity"),
        ),
        body: UnityWidget(
          borderRadius: BorderRadius.zero,
          onUnityCreated: onUnityCreated,
        ),
      ),
    );
  }

  void onUnityCreated(UnityWidgetController controller) => this.controller = controller;
  void setRotationSpeed(String speed) => controller.postMessage("Cube", "SetRotationSpeed", speed);
}

class TMTest extends StatelessWidget {
  final List<Widget> levels = [
    const Level(
      title: "Slave to the Rhythm",
      artist: "Michael Jackson",
      album: "Xscape",
      time: "3:57",
      stars: 2,
      cover: "http://media.oscarmini.com/wp-content/uploads/2014/08/05044727/michaeljackson_coverart.jpg",
    ),
    const Level(
      title: "Dive",
      artist: "Ed Sheeran",
      album: "Divide",
      time: "3:59",
      stars: 3,
      cover: "https://media.s-bol.com/mADWWJA14ZO/550x550.jpg",
    ),
    const Level(
      title: "Numb",
      artist: "Dotan",
      album: "Numb",
      time: "3:45",
      stars: 1,
      cover: "https://m.media-amazon.com/images/M/MV5BNzMzZGI3ZTAtNjBlNy00NWE0LWEwY2MtZTBhODQ5MjQ1OTEwXkEyXkFqcGdeQXVyNjU1OTg4OTM@._V1_.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Select level',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Center(
                  child: SizedBox(
                    height: 600,
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 0.8,
                      ),
                      itemCount: levels.length,
                      itemBuilder: (BuildContext context, int index) {
                        return levels[index];
                      },
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Center(
                  child: SizedBox.square(
                    dimension: 100,
                    child: IconButton(
                      onPressed: null,
                      color: Colors.green,
                      iconSize: 80,
                      icon: Icon(Icons.play_arrow),
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

class Level extends StatelessWidget {
  final String title;
  final String artist;
  final String album;
  final String time;
  final int stars;
  final String cover;

  const Level({
    Key? key,
    required this.title,
    required this.artist,
    required this.album,
    required this.time,
    required this.stars,
    required this.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 4))],
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(cover),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      stars > 0 ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    Icon(
                      stars > 1 ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    Icon(
                      stars > 2 ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                  ],
                ),
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/179/179251.png",
                  height: 30,
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 8,
            child: SizedBox(),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      album,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
