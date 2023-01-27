import 'dart:ui';

import 'package:download/download.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'boletim.dart';

double valorTela = 1;

double widgetx = .45;
double widgety = -.013;

double widgetHeight = 50;
double widgetWidth = 50;

DateTime dataDoBoletim = DateTime.now();

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
              )
            ],
          );
        });
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
  void initState() {
    calculateSizeAndPosition();
    super.initState();
  }

  void updateState() {
    calculateSizeAndPosition();
  }

  void calculateSizeAndPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        size = boletimKey.currentContext!.size!;
        //position = box.localToGlobal(Offset.zero);
        //size = box.size;
      });
    });
  }

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
        valorItemBoletim(result, const Rect.fromLTWH(56, 278, 138, 30));

    //

    String pdfAguardando =
        valorItemBoletim(result, const Rect.fromLTWH(383, 278, 127, 30));

    //

    String pdfIsolados =
        valorItemBoletim(result, const Rect.fromLTWH(170, 363, 80, 30));

    //

    String pdfRecuperados =
        valorItemBoletim(result, const Rect.fromLTWH(248, 242, 116, 30));

    //

    String pdfInternados =
        valorItemBoletim(result, const Rect.fromLTWH(285, 363, 79, 30));

    //

    String pdfObitos =
        valorItemBoletim(result, const Rect.fromLTWH(382, 346, 75, 28));

//Display the text.
    _showResult(
        'Confirmados: $pdfConf\nAguardando Resultado: $pdfAguardando\nEm Isolamento: $pdfIsolados\nRecuperados: $pdfRecuperados\nInternados: $pdfInternados\nObitos: $pdfObitos');

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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.max,
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
                        )
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
                          //controller: screenshotController,
                          child: const Boletim()),
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Spacer(flex: 7),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                              onPressed: () {
                                lerPDF();
                              },
                              child: const SizedBox(
                                  height: 70,
                                  width: 170,
                                  child: Center(
                                      child: Text(
                                    'CARREGAR PDF\nCOM DADOS',
                                    textAlign: TextAlign.center,
                                  )))),
                          const Spacer(),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                              onPressed: () async {
                                double w = 1080 /
                                    boletimKey.currentContext!.size!.width;

                                double pixelratio =
                                    MediaQuery.of(context).devicePixelRatio;

                                double pixelRatioFinal = w * pixelratio;

                                paraimagem(boletimKey, pixelRatioFinal);

                                //await salvarBoletim(pixelRatioFinal);
                              },
                              child: const SizedBox(
                                  height: 70,
                                  width: 170,
                                  child: Center(
                                      child: Text(
                                    'BAIXAR\nBOLETIM',
                                    textAlign: TextAlign.center,
                                  )))),
                          const Spacer(flex: 7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> paraimagem(dynamic key, double pixelRatioFinal) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: pixelRatioFinal);
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData?.buffer.asUint8List();

    if (imageBytes != null) {
      final stream = Stream.fromIterable(imageBytes.toList());

      download(stream, 'boletim $dataBoletim.jpg');
    }
  }
}
