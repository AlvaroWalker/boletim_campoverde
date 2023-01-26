import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class BoletimWidget extends StatefulWidget {
  const BoletimWidget({
    Key? key,
    required this.dataBoletim,
    required this.confirmados,
    required this.isolamentoDomiciliar,
    required this.aguardandoResultado,
    required this.internados,
    required this.recuperados,
    required this.obitos,
  }) : super(key: key);

  final String dataBoletim;
  final int confirmados;
  final int isolamentoDomiciliar;

  final int aguardandoResultado;
  final int internados;
  final int recuperados;
  final int obitos;
  @override
  State<BoletimWidget> createState() => _BoletimWidgetState();
}

Future<String> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      //locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2012, 8),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) {
    return dataBoletim =
        '${picked.day.toString().padLeft(2, '0')} DE ${DateFormat('MMMM', 'pt-BR').format(picked)} de ${picked.year}'
            .toUpperCase();
  } else {
    return '';
  }
}

class _BoletimWidgetState extends State<BoletimWidget> {
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
                  }
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text('OK')),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    valoresBoletimMap = {
      'confirmados': widget.confirmados,
      'isolamentoDomiciliar': widget.isolamentoDomiciliar,
      'aguardandoResultado': widget.aguardandoResultado,
      'internados': widget.internados,
      'recuperados': widget.recuperados,
      'obitos': widget.obitos,
    };
  }

  @override
  Widget build(BuildContext context) {
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
                        child: InkWell(
                          onTap: () async {
                            dataBoletim = await _selectDate(context);
                            setState(() {});
                          },
                          child: Text(
                            dataBoletim,
                            textAlign: TextAlign.center,
                            textScaleFactor: constraints.maxWidth / 500,
                            style: const TextStyle(
                              fontFamily: 'Nexa',
                              color: Color.fromARGB(255, 20, 20, 20),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )),
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
                        child: Text(
                          widget.confirmados.toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: constraints.maxHeight / 200,
                          style: const TextStyle(
                            height: 1.35,
                            fontFamily: 'Nexa',
                            color: Color.fromARGB(255, 50, 50, 50),
                            fontWeight: FontWeight.w800,
                          ),
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
                            return popupItens('Isolamento', 'isolamento');
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: constraints.maxHeight / 5.5,
                        height: constraints.maxHeight / 15,
                        child: Text(
                          widget.isolamentoDomiciliar.toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: constraints.maxHeight / 350,
                          style: const TextStyle(
                            height: 1.8,
                            fontFamily: 'Nexa',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
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
                        child: Text(
                          widget.aguardandoResultado.toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: constraints.maxHeight / 350,
                          style: const TextStyle(
                            height: 1.8,
                            fontFamily: 'Nexa',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
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
                        child: Text(
                          widget.internados.toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: constraints.maxHeight / 350,
                          style: const TextStyle(
                            height: 1.8,
                            fontFamily: 'Nexa',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
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
                        child: Text(
                          widget.recuperados.toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: constraints.maxHeight / 350,
                          style: const TextStyle(
                            height: 1.8,
                            fontFamily: 'Nexa',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
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
                        child: Text(
                          widget.obitos.toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: constraints.maxHeight / 350,
                          style: const TextStyle(
                            height: 1.8,
                            fontFamily: 'Nexa',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
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
