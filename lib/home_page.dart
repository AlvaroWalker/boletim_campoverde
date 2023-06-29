import 'package:boletim_campoverde/to_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'boletim.dart';

double widgetx = .45;
double widgety = -.013;

double widgetHeight = 50;
double widgetWidth = 50;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

String valorItemBoletim(dynamic result, Rect bounds) {
  Rect pdfTextBounds = bounds;

  String pdfText = '';

  for (int i = 0; i < result.length; i++) {
    List<TextWord> wordCollection = result[i].wordCollection;
    for (int j = 0; j < wordCollection.length; j++) {
      if (pdfTextBounds.overlaps(wordCollection[j].bounds)) {
        pdfText = wordCollection[j].text;

        return pdfText;
      }
    }
    if (pdfText != '') {
      break;
    }
  }

  return pdfText;
}

final boletimKey = GlobalKey();

Size size = const Size(0, 0);
Offset position = const Offset(0, 0);
DateTime selectedDate = DateTime.now();

Future<List<int>> _readDocumentData(var name) async {
  //final ByteData data = await rootBundle.load(name);

  //return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  return name;
}

class _HomePageState extends State<HomePage> {
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

  Future _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);

    if (result != null) {
      //File file = File(result.files.single.path!);

      return result.files.single.bytes;
    } else {
      // User canceled the picker
    }
  }

  String textoOcr = '';
  Uint8List? imgBoletim;
  List<int> valoresBoletim = [
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  String localidade = '';

  int txt1 = 0, txt2 = 0, txt3 = 0, txt4 = 0, txt5 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Boletim COVID19'),
        ),
      ),
      body: telaTeste(),
    );
  }

  Future<void> lerPDF() async {
    var local = await _pickFile();
    //Load an existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData(local));

//Create a new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

//Extract all the text from a particular page.
    List<TextLine> result = extractor.extractTextLines(startPageIndex: 0);

//Predefined bound.

    String pdfConf =
        valorItemBoletim(result, const Rect.fromLTWH(56, 278, 129, 30));

    //

    String pdfAguardando =
        valorItemBoletim(result, const Rect.fromLTWH(376, 276, 112, 30));

    //

    String pdfIsolados =
        valorItemBoletim(result, const Rect.fromLTWH(166, 360, 77, 30));

    //

    String pdfRecuperados =
        valorItemBoletim(result, const Rect.fromLTWH(243, 240, 114, 30));

    //

    String pdfInternados =
        valorItemBoletim(result, const Rect.fromLTWH(280, 360, 77, 30));

    //

    String pdfObitos =
        valorItemBoletim(result, const Rect.fromLTWH(395, 360, 75, 30));

//Display the text.
    _showResult(
      'Confirmados: $pdfConf\nAguardando Resultado: $pdfAguardando\nEm Isolamento: $pdfIsolados\nRecuperados: $pdfRecuperados\nInternados: $pdfInternados\nObitos: $pdfObitos',
    );

    valoresBoletim[0] = int.tryParse(pdfConf)!;
    valoresBoletim[1] = int.tryParse(pdfIsolados)!;
    valoresBoletim[2] = int.tryParse(pdfAguardando)!;
    valoresBoletim[3] = int.tryParse(pdfInternados)!;
    valoresBoletim[4] = int.tryParse(pdfRecuperados)!;
    valoresBoletim[5] = int.tryParse(pdfObitos)!;
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

  Widget telaTeste() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(
                flex: 1,
              ),
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
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: const Color(0xFFDDDDDD),
                      ),
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
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () {
                        double w =
                            1080 / boletimKey.currentContext!.size!.width;
                        double pixelratio =
                            MediaQuery.of(context).devicePixelRatio;
                        double pixelRatioFinal = w * pixelratio;
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
          ),
        ),
      ],
    );
  }
}
