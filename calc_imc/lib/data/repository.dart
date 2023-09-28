import 'package:hive/hive.dart';

class Repository {
  static late Box _box;

  Repository._criar();

  static Future<Repository> carregar() async {
    if (Hive.isBoxOpen('dados')) {
    } else {
      _box = await Hive.openBox('dados');
    }
    return Repository._criar();
  }

  salvar(double imc) {
    _box.add(imc);
  }

  List obterDados() {
    return _box.values.toList();
  }

  remover(int index) {
    _box.delete(index);
  }

  limpar() {
    _box.clear();
  }
}
