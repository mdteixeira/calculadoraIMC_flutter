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

  var historico = [];
  var imc = 0.0;

  int currentPageIndex = 0;

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
            label: 'Anteriores',
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
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: historico.length,
                  itemBuilder: (context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          trailing: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return AlertDialog(
                                      title: const Text('Você deseja deletar?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancelar')),
                                        TextButton(
                                            onPressed: () {
                                              historico
                                                  .remove(historico[index]);
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Text('Sim, deletar')),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(Icons.delete),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                historico[index].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  }),
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext bc) {
                        return AlertDialog(
                          title: const Text('Você deseja deletar?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar')),
                            TextButton(
                                onPressed: () {
                                  historico.clear();
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: const Text('Sim, deletar')),
                          ],
                        );
                      });
                },
                child: const Text('Deletar todos os registros'))
          ],
        ),
      ][currentPageIndex],
      floatingActionButton: (currentPageIndex == 1)
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () {
                imc = double.parse((calcularIMC(
                        pesoController.text == ''
                            ? 0
                            : double.parse(pesoController.text),
                        alturaController.text == ''
                            ? 0
                            : double.parse(alturaController.text)))
                    .toStringAsFixed(2));

                if (!imc.isNaN) {
                  historico.add(imc);
                }
                setState(() {});
              },
              tooltip: 'Calcular IMC',
              child: const Icon(Icons.calculate),
            ),
    );
  }
}
