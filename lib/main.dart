import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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
      debugShowCheckedModeBanner: false,
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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 140, 219, 225), 
          brightness: Brightness.light,
        ),
        fontFamily: 'Ubuntu',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 140, 219, 225), 
          brightness: Brightness.dark,
        ),
        fontFamily: 'Ubuntu',
      ),
      themeMode: ThemeMode.system,
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
    'El comando de incrementar, por cada pulsación, aumenta la velocidad del motor.',
    'El comando de reducir, por cada pulsación, disminuye la velocidad del motor.',
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

  BluetoothConnection? _conexion;
  bool _estaConectado = false;
  bool _cargandoBluetooth = false;
  String _address = '';
  

  void _cambiarComando(int nuevoCom) {
    setState(() {
      _comandoActual = nuevoCom;
      _descripcion = listDescripciones[nuevoCom];
    });
  }

  Future<void> _connectToDevice() async {
    setState(() {
      _cargandoBluetooth = true;
    });

    final List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    final BluetoothDevice testDevice = devices.firstWhere((d) => d.name == "HC-05", orElse: () {return const BluetoothDevice(address: '');});
    
    if (testDevice.address != '') {
      final BluetoothConnection connection = await BluetoothConnection.toAddress(testDevice.address);
      setState(() {
        _conexion = connection;
        _address = '${testDevice.name} ${testDevice.address}';
        _estaConectado = true;
      });
    }

    setState(() {
      _cargandoBluetooth = false;
    });
  }

  Future<void> _disconnectFromDevice() async {
    setState(() {
      _cargandoBluetooth = true;
    });

    await _conexion!.finish();

    setState(() {
      _conexion = null;
      _address = '';
      _estaConectado = false;
      _cargandoBluetooth = false;
    });
  }

  Future<List> _sendData(int value) async {
    String mensaje = 'Error.';
    Color color = const Color.fromARGB(255, 150, 0, 0);

    if (_cargandoBluetooth == false) {
      if (_conexion != null) {
        Uint8List bytes = Uint8List.fromList(utf8.encode(value.toString()));
        _conexion!.output.add(bytes);
        await _conexion!.output.allSent;
        mensaje = '¡Comando enviado!';
        color = const Color.fromARGB(255, 63, 129, 129);
      }
      else {
        mensaje = 'No se ha enlazado ninguna conexión con el Arduino.';
      }
    }
    else {
      mensaje = 'La conexión está ocupada en otro proceso, por favor espere un momento.';
    }
    return [mensaje, color];
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

      // ### BARRA SUPERIOR DE LA APLICACIÓN ###

      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        leading: 
          IconButton(
            onPressed: (){
              if (_cargandoBluetooth == false) {
                _estaConectado ? _disconnectFromDevice() : _connectToDevice();
              }
            },
            tooltip: _estaConectado ? 'Desconectar' : 'Conectar',
            icon: const Icon(Icons.power_settings_new_rounded), 
          ),
        actions: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    child: _cargandoBluetooth ? 
                      CircularProgressIndicator(
                        value: null,
                        semanticsLabel: 'Indicador de progreso circular',
                        color: _estaConectado ? const Color.fromARGB(255, 63, 129, 129):const Color.fromARGB(255, 150, 0, 0),
                      )
                      :
                      Icon(
                        _estaConectado ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
                        color: _estaConectado ? const Color.fromARGB(255, 63, 129, 129):const Color.fromARGB(255, 150, 0, 0),
                      )
                  ),

                  Text(
                    _estaConectado ? 'ENLAZADO':'NO ENLAZADO',
                    style: TextStyle(
                      fontSize: _estaConectado ? 24 : 28, fontWeight: FontWeight.bold,
                      color: _estaConectado ? const Color.fromARGB(255, 63, 129, 129):const Color.fromARGB(255, 150, 0, 0),
                    ),
                  ),

                ],
              ),
              
              Text(
                _estaConectado ? _address : '',
                style: TextStyle(
                  fontSize: _estaConectado ? 15 : 1),
              ),

            ],
          ),

        ],
      ),



      // ### BODY DE LA APLICACIÓN ###

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
                    onPressed: () async {
                      List lista = await _sendData(_comandoActual);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(lista[0]),duration: const Duration(milliseconds: 5000),
                            width: 300.0, padding: const EdgeInsets.all( 10.0), behavior: SnackBarBehavior.floating,
                            backgroundColor: lista[1],
                          ),
                        );
                      }
                    },
                    child: 
                    Padding(
                      padding:const EdgeInsets.all(10),
                      child: 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(listBotones[itemIndex], textAlign: TextAlign.center,
                            style: const TextStyle(color: Color.fromARGB(255, 63, 129, 129),
                              fontSize: 30, fontWeight: FontWeight.bold, height: 0.9,
                            ),
                          ),
                          Icon(
                            listIconos[itemIndex], size: 50.0,
                            color: const Color.fromARGB(255, 63, 129, 129),
                          ),
                        ],
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
                onPageChanged: (index, reason){_cambiarComando(index);},
              ),
            ),

            Padding(
              padding:const EdgeInsets.all(50),
              child: 
              Text(
                _descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
            ),

          ],
        ),
      ),



      // ### BARRA INFERIOR DE LA APLICACIÓN ###

      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Theme.of(context).colorScheme.background,
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
