import 'package:boletim_campoverde/to_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'boletim.dart';

double widgetX = .45;
double widgetY = -.013;
double widgetHeight = 50;
double widgetWidth = 50;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final boletimKey = GlobalKey();
  String textoOcr = '';
  Uint8List? imgBoletim;
  List<int> valoresBoletim = List.filled(6, 0);
  String localidade = '';
  int txt1 = 0, txt2 = 0, txt3 = 0, txt4 = 0, txt5 = 0;
  DateTime selectedDate = DateTime.now();

  Future<List<int>> _readDocumentData(var name) async {
    //final ByteData data = await rootBundle.load(name);
    //return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return name;
  }

  Future<Uint8List?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      return result.files.single.bytes;
    }
    return null;
  }

  void _showResult(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BOLETIM'),
          content: Scrollbar(
            child: SingleChildScrollView(
              child: Text(text),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Fechar'),
              onPressed: () {
                setBoletimValues();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> lerPDF() async {
    var local = await _pickFile();
    if (local == null) return;

    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData(local));
    PdfTextExtractor extractor = PdfTextExtractor(document);
    List<TextLine> result = extractor.extractTextLines(startPageIndex: 0);

    String pdfConf =
        valorItemBoletim(result, const Rect.fromLTWH(56, 278, 129, 30));
    String pdfAguardando =
        valorItemBoletim(result, const Rect.fromLTWH(376, 276, 112, 30));
    String pdfIsolados =
        valorItemBoletim(result, const Rect.fromLTWH(166, 360, 77, 30));
    String pdfRecuperados =
        valorItemBoletim(result, const Rect.fromLTWH(243, 240, 114, 30));
    String pdfInternados =
        valorItemBoletim(result, const Rect.fromLTWH(280, 360, 77, 30));
    String pdfObitos =
        valorItemBoletim(result, const Rect.fromLTWH(395, 360, 75, 30));

    _showResult(
      'Confirmados: $pdfConf\nAguardando Resultado: $pdfAguardando\nEm Isolamento: $pdfIsolados\nRecuperados: $pdfRecuperados\nInternados: $pdfInternados\nObitos: $pdfObitos',
    );

    setState(() {
      valoresBoletim = [
        int.tryParse(pdfConf) ?? 0,
        int.tryParse(pdfIsolados) ?? 0,
        int.tryParse(pdfAguardando) ?? 0,
        int.tryParse(pdfInternados) ?? 0,
        int.tryParse(pdfRecuperados) ?? 0,
        int.tryParse(pdfObitos) ?? 0,
      ];
    });
  }

  void setBoletimValues() {
    Provider.of<ValoresBoletim>(context, listen: false).setValues(
      confirmados: valoresBoletim[0],
      isolamentoDomiciliar: valoresBoletim[1],
      aguardandoResultados: valoresBoletim[2],
      internados: valoresBoletim[3],
      recuperados: valoresBoletim[4],
      obitos: valoresBoletim[5],
    );
  }

  String valorItemBoletim(List<TextLine> result, Rect bounds) {
    for (TextLine line in result) {
      for (TextWord word in line.wordCollection) {
        if (bounds.overlaps(word.bounds)) {
          return word.text;
        }
      }
    }
    return '';
  }

  Widget telaTeste() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(flex: 1),
              Flexible(
                flex: 8,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color.fromARGB(51, 0, 0, 0),
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: RepaintBoundary(
                        key: boletimKey,
                        child: const Boletim(),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: lerPDF,
                child: const SizedBox(
                  height: 70,
                  width: 170,
                  child: Center(
                    child: Text(
                      'CARREGAR PDF\nCOM DADOS',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  double w = 1080 / boletimKey.currentContext!.size!.width;
                  double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                  double pixelRatioFinal = w * pixelRatio;
                  captureAndSaveImage(boletimKey, pixelRatioFinal);
                },
                child: const SizedBox(
                  height: 70,
                  width: 170,
                  child: Center(
                    child: Text(
                      'BAIXAR\nBOLETIM',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Boletim COVID19')),
      ),
      body: telaTeste(),
    );
  }
}
