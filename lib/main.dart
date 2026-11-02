import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: FloripaTV(),
  theme: ThemeData(scaffoldBackgroundColor: Color(0xFF0A0E21)),
));

class FloripaTV extends StatefulWidget {
  @override
  _FloripaTVState createState() => _FloripaTVState();
}

class _FloripaTVState extends State<FloripaTV> {
  final canais = [
    {
      "nome": "CazeTV - Ao Vivo (Oficial)",
      "logo": "Cazé",
      "url": "https://www.youtube.com/@CazeTV/live",
      "tipo": "youtube"
    },
    {
      "nome": "GE TV - Ao Vivo (Oficial)",
      "logo": "GE",
      "url": "https://www.youtube.com/@geglobo/live",
      "tipo": "youtube"
    },
    {
      "nome": "Big Buck Bunny - TESTE",
      "logo": "Teste",
      "url": "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "tipo": "mp4"
    },
    {
      "nome": "Floripa Natureza",
      "logo": "Natureza",
      "url": "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "tipo": "mp4"
    },
    {
      "nome": "Teste Ao Vivo - HLS",
      "logo": "Ao Vivo",
      "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      "tipo": "m3u8"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text("FLORIPA TV - IPTV"),
        backgroundColor: Color(0xFF1D1E33),
      ),
      body: ListView.builder(
        itemCount: canais.length,
        itemBuilder: (c, i) => Card(
          margin: EdgeInsets.all(8),
          color: Color(0xFF1A2340),
          child: ListTile(
            leading: Text(canais[i]["logo"]!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            title: Text(canais[i]["nome"]!, style: TextStyle(color: Colors.white)),
            subtitle: Text(canais[i]["tipo"] == "youtube" ? "OFICIAL YOUTUBE" : "AO VIVO", style: TextStyle(color: Colors.greenAccent)),
            trailing: Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
            onTap: () async {
              final canal = canais[i];
              if (canal["tipo"] == "youtube") {
                final uri = Uri.parse(canal["url"]!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Player(url: canal["url"]!, nome: canal["nome"]!)),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Player extends StatefulWidget {
  final String url, nome;
  Player({required this.url, required this.nome});
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late VideoPlayerController v;
  ChewieController? chewie;

  @override
  void initState() {
    super.initState();
    v = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          chewie = ChewieController(videoPlayerController: v, autoPlay: true);
        });
      });
  }

  @override
  void dispose() {
    v.dispose();
    chewie?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.nome)),
      body: Center(
        child: chewie != null ? Chewie(controller: chewie!) : CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
