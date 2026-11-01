import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() => runApp(MaterialApp(home: FloripaTV(), debugShowCheckedModeBanner: false, theme: ThemeData.dark()));

class FloripaTV extends StatefulWidget {
  @override _FloripaTVState createState() => _FloripaTVState();
}

class _FloripaTVState extends State<FloripaTV> {
  final canais = [
    {"nome": "Big Buck Bunny - Filmes", "logo": "🎬", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"nome": "Floripa Natureza 4K", "logo": "🏝️", "url": "https://test-streams.mux.dev/bbb-test/card.m3u8"},
    {"nome": "Teste Ao Vivo", "logo": "📺", "url": "https://test-streams.mux.dev/test_001/stream.m3u8"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E1A),
      appBar: AppBar(title: Text("FLORIPA TV", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.black, centerTitle: true),
      body: ListView.builder(
        itemCount: canais.length,
        itemBuilder: (c,i) => Card(
          color: Color(0xFF1A2340),
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Text(canais[i]['logo']!, style: TextStyle(fontSize: 30)),
            title: Text(canais[i]['nome']!, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("AO VIVO - Clique para ver", style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
            trailing: Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 40),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Player(url: canais[i]['url']!, nome: canais[i]['nome']!))),
          ),
        ),
      ),
    );
  }
}

class Player extends StatefulWidget {
  final String url, nome;
  Player({required this.url, required this.nome});
  @override _PlayerState createState() => _PlayerState();
}
class _PlayerState extends State<Player> {
  late VideoPlayerController v;
  ChewieController? c;
  @override void initState() {
    super.initState();
    v = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          c = ChewieController(videoPlayerController: v, autoPlay: true, isLive: true);
        });
      });
  }
  @override void dispose() { v.dispose(); c?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.nome)), body: Center(child: c != null ? Chewie(controller: c!) : CircularProgressIndicator()));
  }
}
