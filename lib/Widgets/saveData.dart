import 'package:path_provider/path_provider.dart';
import "dart:io";

class SaveData{
  Future<void> salvarDadosEmArquivo(String dados) async {
    // Obtém o diretório de documentos do aplicativo
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    // Cria um arquivo dentro do diretório
    final file = File('${appDocumentsDir.path}/listJson.txt');

    // Escreve os dados no arquivo
    await file.writeAsString(dados);

    print("salvo nos arquivos.");
  }


  Future<String> lerDadosDoArquivo() async {
    try {
      // Obtém o diretório de documentos do aplicativo
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

      // Abre o arquivo
      final file = File('${appDocumentsDir.path}/listJson.txt');

      // Lê os dados do arquivo
      String dados = await file.readAsString();

      return dados;
    } catch (e) {
      // Lidar com erros, como arquivo não encontrado
      return '';
    }
  }

  Future<bool> arquivoExiste() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocumentsDir.path}/listJson.txt');
    print("chegou aqui pel");
    print(await file.exists());
    return await file.exists();
  }


}