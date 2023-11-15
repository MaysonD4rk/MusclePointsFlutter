import 'package:path_provider/path_provider.dart';
import "dart:io";

class SaveData{
  Future<void> salvarDadosEmArquivo(String fileName, String data) async {
    // Obtém o diretório de documentos do aplicativo
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    // Cria um arquivo dentro do diretório
    final file = File('${appDocumentsDir.path}/$fileName.txt');

    // Escreve os dados no arquivo
    await file.writeAsString(data);

    print("salvo nos arquivos.");
  }


  Future<String> lerDadosDoArquivo(String fileName) async {
    try {
      // Obtém o diretório de documentos do aplicativo
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

      // Abre o arquivo
      final file = File('${appDocumentsDir.path}/$fileName.txt');

      // Lê os dados do arquivo
      String data = await file.readAsString();

      return data;
    } catch (e) {
      // Lidar com erros, como arquivo não encontrado
      return '';
    }
  }

  Future<bool> arquivoExiste(String fileName) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocumentsDir.path}/$fileName.txt');
    print("chegou aqui pel");
    print(await file.exists());
    return await file.exists();
  }

  Future<void> deleteFile(String fileName) async {
    try {
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
      String filePath = '${appDocumentsDirectory.path}/$fileName.txt';
      File file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        print('Arquivo listJson excluído com sucesso.');
      } else {
        print('O arquivo listJson não existe.');
      }
    } catch (e) {
      print('Erro ao excluir o arquivo listJson: $e');
    }
  }


}