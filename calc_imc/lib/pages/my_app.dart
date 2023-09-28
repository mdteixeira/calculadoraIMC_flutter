import 'package:calc_imc/data/repository.dart';
import 'package:calc_imc/pages/historico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Calculadora de IMC'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

double calcularIMC(peso, altura) {
  return peso / (altura * altura);
}

class _HomePageState extends State<HomePage> {
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();

  var imc = 0.0;

  int currentPageIndex = 0;

  late Repository repository;

  @override
  void initState() {
    obterDados();
    super.initState();
  }

  void obterDados() async {
    repository = await Repository.carregar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.calculate),
            icon: Icon(Icons.calculate_outlined),
            label: 'Calcular',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Histórico',
          ),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text('Insira seu peso:',
                          style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: pesoController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[Ee]([+-]?\d+))?'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text('Insira sua altura:',
                          style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: alturaController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[Ee]([+-]?\d+))?'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'IMC',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(imc.isNaN ? '' : (imc).toString(),
                            style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const HistoricoPage()
      ][currentPageIndex],
      floatingActionButton: currentPageIndex == 1
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                imc = double.parse((calcularIMC(
                        pesoController.text == ''
                            ? 0
                            : double.tryParse(pesoController.text) ?? 0,
                        alturaController.text == ''
                            ? 0
                            : double.tryParse(alturaController.text) ?? 0))
                    .toStringAsFixed(2));

                if (!imc.isNaN) {
                  repository.salvar(imc);
                }
                setState(() {});
              },
              tooltip: 'Calcular IMC',
              child: const Icon(Icons.calculate),
            ),
    );
  }
}
