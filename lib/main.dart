import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ardu',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 140, 219, 225)),
        useMaterial3: true,
        fontFamily: 'Ubuntu', // no funciona lol
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> listBotones = [
    'ACTIVAR PARADA', 'ACTIVAR ARRANQUE',
    'INCREMENTAR VELOCIDAD', 'REDUCIR VELOCIDAD',
    'COMENZAR CICLO'
  ];
  static const List<String> listDescripciones = [
    'El comando de parada detiene el giro del motor independientemente de su nivel de velocidad.',
    'El comando de arranque reanuda el giro del motor en el nivel de velocidad que tenía.',
    'El comando de incremento, por cada pulsada, incrementa la velocidad del motor.',
    'El comando de reducción, por cada pulsada, disminuye la velocidad del motor.',
    'El comando de ciclo inicia el ciclo de control cuando es presionado durante una parada.'
  ];
  static const List<IconData> listIconos = [
    Icons.pause_rounded, Icons.play_arrow_rounded,
    Icons.fast_forward_rounded, Icons.fast_rewind_rounded,
    Icons.all_inclusive_rounded
  ];

  CarouselController buttonCarouselController = CarouselController();

  int _comandoActual = 0;
  String _descripcion = '¡Bienvenido a Ardu!';
  IconData _logoComando = Icons.celebration;
  bool _conectado = true;
  String _address = 'HC-05 98:D3:51:FD::';

  void ejecutarComando(int comando) {

  }

  void ejecutarComand(int comando) {
    
  }
  
  void _cambiarComando(int nuevoCom) {
    setState(() {
      _comandoActual = nuevoCom;
      _descripcion = listDescripciones[nuevoCom];
      _logoComando = listIconos[nuevoCom];
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        actions: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Icon(
                    _conectado ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
                    color: _conectado ? const Color.fromARGB(255, 63, 129, 129):Colors.red,
                  ),

                  Text(
                    _conectado ? 'CONECTADO':'DESCONECTADO',
                    style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, 
                      color: _conectado ? const Color.fromARGB(255, 63, 129, 129):Colors.red,
                    ),
                  ),

                ],
              ),
              
              Text(
                _conectado ? _address : '',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 34, 67, 67),
                ),
              ),

            ],
          ),

        ],
      ),



      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: 
        Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

          const Divider(
            height: 50,
            color: Color.fromARGB(0, 0, 0, 0),
          ),

            CarouselSlider.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: 
                  FilledButton.tonal(
                    onPressed: () {ejecutarComando(_comandoActual);},
                    child: 
                    Padding(
                      padding:const EdgeInsets.all(10),
                      child: 
                      Text(listBotones[itemIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color.fromARGB(255, 63, 129, 129),
                          fontSize: 30, fontWeight: FontWeight.bold, height: 0.9),
                      ),
                    ),
                  ),
                );
              },
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                autoPlayInterval: const Duration(seconds: 10),
                initialPage: 0, autoPlay: true, height: 200,
                enlargeCenterPage: true, enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            ),

            Padding(
              padding:const EdgeInsets.all(50),
              child: 
              Text(
                _descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24, 
                  color: Color.fromARGB(255, 34, 67, 67),
                ),
              ),
            ),

            Icon(
              _logoComando,
              size: 50.0,
              color: const Color.fromARGB(255, 34, 67, 67),
            ),

          ],
        ),
      ),



      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
        child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            IconButton(
              onPressed: (){buttonCarouselController.previousPage();},
              icon: const Icon(Icons.navigate_before_rounded),
            ),

            IconButton(
              onPressed: (){buttonCarouselController.nextPage();},
              icon: const Icon(Icons.navigate_next_rounded),
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
