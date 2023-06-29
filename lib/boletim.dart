import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

double widgetx = .45;
double widgety = -.013;

String dataBoletim = 'CLIQUE PARA ALTERAR A DATA';

DateTime selectedDate = DateTime.now();

Map<String, int> valoresBoletimMap = {
  'confirmados': 0,
  'isolamentoDomiciliar': 0,
  'aguardandoResultado': 0,
  'internados': 0,
  'recuperados': 0,
  'obitos': 0,
};

List<int> valoresBoletim = [
  0,
  0,
  0,
  0,
  0,
  0,
];

class ValoresBoletim extends ChangeNotifier {
  DateTime dataBoletim_ = DateTime.now();
  String dataString_ = 'CLIQUE PADA ALTERAR A DATA';
  int confirmados_ = 0;
  int isolamentoDomiciliar_ = 0;
  int aguardandoResultado_ = 0;
  int internados_ = 0;
  int recuperados_ = 0;
  int obitos_ = 0;

  void setValues(
      {DateTime? data,
      String? dataString,
      int? confirmados,
      int? isolamentoDomiciliar,
      int? aguardandoResultados,
      int? internados,
      int? recuperados,
      int? obitos}) {
    if (confirmados != null) {
      confirmados_ = confirmados;
    }
    if (isolamentoDomiciliar != null) {
      isolamentoDomiciliar_ = isolamentoDomiciliar;
    }
    if (aguardandoResultados != null) {
      aguardandoResultado_ = aguardandoResultados;
    }
    if (internados != null) {
      internados_ = internados;
    }
    if (recuperados != null) {
      recuperados_ = recuperados;
    }
    if (obitos != null) {
      obitos_ = obitos;
    }
    if (dataString != null) {
      dataString_ = dataString;
    }

    notifyListeners();
  }
}

class Boletim extends StatelessWidget {
  const Boletim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget texto(String text, double size) {
      return Text(
        text,
        textAlign: TextAlign.center,
        textScaleFactor: size,
        style: const TextStyle(
          fontFamily: 'Nexa',
          color: Color.fromARGB(255, 20, 20, 20),
          fontWeight: FontWeight.w900,
        ),
      );
    }

    popupItens(String texto, String valor) {
      TextEditingController cont = TextEditingController();
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AlertDialog(
          backgroundColor: const Color.fromARGB(150, 255, 255, 255),
          title: Center(child: Text(texto)),
          content: TextFormField(
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(100, 255, 255, 255),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            autofocus: true,
            controller: cont,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              print(v);
            },
            onFieldSubmitted: (value) {
              if (cont.text != '') {
                valoresBoletimMap[valor] = int.parse(cont.text);
              }
              Navigator.pop(context);
            },
          ),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (cont.text != '') {
                      valoresBoletimMap[valor] = int.parse(cont.text);
                      switch (valor) {
                        case 'confirmados':
                          Provider.of<ValoresBoletim>(context, listen: false)
                              .setValues(
                            confirmados: int.parse(cont.text),
                          );
                          break;
                        case 'isolamentoDomiciliar':
                          Provider.of<ValoresBoletim>(context, listen: false)
                              .setValues(
                            isolamentoDomiciliar: int.parse(cont.text),
                          );
                          break;

                        case 'aguardandoResultado':
                          Provider.of<ValoresBoletim>(context, listen: false)
                              .setValues(
                            aguardandoResultados: int.parse(cont.text),
                          );
                          break;

                        case 'internados':
                          Provider.of<ValoresBoletim>(context, listen: false)
                              .setValues(
                            internados: int.parse(cont.text),
                          );
                          break;

                        case 'recuperados':
                          Provider.of<ValoresBoletim>(context, listen: false)
                              .setValues(
                            recuperados: int.parse(cont.text),
                          );
                          break;

                        case 'obitos':
                          Provider.of<ValoresBoletim>(context, listen: false)
                              .setValues(
                            obitos: int.parse(cont.text),
                          );
                          break;
                      }
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            )
          ],
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      return AspectRatio(
        aspectRatio: 1 / 1,
        child: Stack(
          alignment: const Alignment(0, 0),
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset(
                    'assets/images/fundo-boletim.jpg',
                    fit: BoxFit.contain,
                  ),
                  Center(
                    child: Align(
                        alignment: const Alignment(0, .72),
                        child: InkWell(onTap: () async {
                          _selectDate(context);
                        }, child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.dataString_,
                              textAlign: TextAlign.center,
                              textScaleFactor: constraints.maxWidth / 500,
                              style: const TextStyle(
                                fontFamily: 'Nexa',
                                color: Color.fromARGB(255, 20, 20, 20),
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ))),
                  ),
                  // Casos Confirmados
                  Align(
                    alignment: const Alignment(0, -.5),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popupItens(
                                'Casos Confirmados', 'confirmados');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 2.8,
                        height: constraints.maxHeight / 13,
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return texto(value.confirmados_.toString(),
                                constraints.maxHeight / 200);
                          },
                        ),
                      ),
                    ),
                  ),
                  //
                  Align(
                    alignment: Alignment(widgetx, widgety - .244),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popupItens(
                                'Isolamento', 'isolamentoDomiciliar');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 5.5,
                        height: constraints.maxHeight / 15,
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.isolamentoDomiciliar_.toString(),
                              textAlign: TextAlign.center,
                              textScaleFactor: constraints.maxHeight / 350,
                              style: const TextStyle(
                                height: 1.8,
                                fontFamily: 'Nexa',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  //
                  Align(
                    alignment: Alignment(widgetx, widgety - .046),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popupItens(
                                'Aguardando Resultados', 'aguardandoResultado');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 5.5,
                        height: constraints.maxHeight / 15,
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.aguardandoResultado_.toString(),
                              textAlign: TextAlign.center,
                              textScaleFactor: constraints.maxHeight / 350,
                              style: const TextStyle(
                                height: 1.8,
                                fontFamily: 'Nexa',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  //
                  Align(
                    alignment: Alignment(widgetx, widgety + .155),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popupItens('Internados', 'internados');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 5.5,
                        height: constraints.maxHeight / 15,
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.internados_.toString(),
                              textAlign: TextAlign.center,
                              textScaleFactor: constraints.maxHeight / 350,
                              style: const TextStyle(
                                height: 1.8,
                                fontFamily: 'Nexa',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  //
                  Align(
                    alignment: Alignment(widgetx, widgety + 0.354),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popupItens('Recuperados / Fim de Isolamento',
                                'recuperados');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 5.5,
                        height: constraints.maxHeight / 15,
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.recuperados_.toString(),
                              textAlign: TextAlign.center,
                              textScaleFactor: constraints.maxHeight / 350,
                              style: const TextStyle(
                                height: 1.8,
                                fontFamily: 'Nexa',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  //
                  Align(
                    alignment: Alignment(widgetx, widgety + 0.554),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popupItens('Obitos', 'obitos');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 5.5,
                        height: constraints.maxHeight / 15,
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.obitos_.toString(),
                              textAlign: TextAlign.center,
                              textScaleFactor: constraints.maxHeight / 350,
                              style: const TextStyle(
                                height: 1.8,
                                fontFamily: 'Nexa',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

_selectDate(BuildContext context) {
  showDatePicker(
          //locale: const Locale('pt', 'BR'),
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2012, 8),
          lastDate: DateTime(2101))
      .then((picked) {
    if (picked != null) {
      dataBoletim =
          '${picked.day.toString().padLeft(2, '0')} DE ${DateFormat('MMMM', 'pt-BR').format(picked)} de ${picked.year}'
              .toUpperCase();

      print(dataBoletim);

      Provider.of<ValoresBoletim>(context, listen: false)
          .setValues(dataString: dataBoletim);
    }
  });
}
