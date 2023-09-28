import 'package:calc_imc/data/repository.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  var _dados = [];

  @override
  void initState() {
    super.initState();
    obterDados();
  }

  late Repository repository;

  void obterDados() async {
    repository = await Repository.carregar();
    _dados = repository.obterDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
            itemCount: _dados.length,
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
                                        repository.remover(index);
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
                    title: Text(
                      _dados[index].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
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
                    title: const Text('Você deseja deletar tudo?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: () async {
                            await repository.limpar();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Sim, deletar')),
                    ],
                  );
                });
          },
          child: const Text('Deletar todos os registros'))
    ]);
  }
}
