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

class ValoresBoletim extends ChangeNotifier {
  DateTime dataBoletim_ = DateTime.now();
  String dataString_ = 'CLIQUE PARA ALTERAR A DATA';
  int confirmados_ = 0;
  int isolamentoDomiciliar_ = 0;
  int aguardandoResultado_ = 0;
  int internados_ = 0;
  int recuperados_ = 0;
  int obitos_ = 0;

  void setValues({
    DateTime? data,
    String? dataString,
    int? confirmados,
    int? isolamentoDomiciliar,
    int? aguardandoResultados,
    int? internados,
    int? recuperados,
    int? obitos,
  }) {
    if (data != null) dataBoletim_ = data;
    if (dataString != null) dataString_ = dataString;
    if (confirmados != null) confirmados_ = confirmados;
    if (isolamentoDomiciliar != null) {
      isolamentoDomiciliar_ = isolamentoDomiciliar;
    }
    if (aguardandoResultados != null) {
      aguardandoResultado_ = aguardandoResultados;
    }
    if (internados != null) internados_ = internados;
    if (recuperados != null) recuperados_ = recuperados;
    if (obitos != null) obitos_ = obitos;
    notifyListeners();
  }
}

class Boletim extends StatelessWidget {
  const Boletim({super.key});

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
                        onTap: () => _selectDate(context),
                        child: Consumer<ValoresBoletim>(
                          builder: (context, value, child) {
                            return Text(
                              value.dataString_,
                              textAlign: TextAlign.center,
                              textScaler:
                                  TextScaler.linear(constraints.maxWidth / 500),
                              style: const TextStyle(
                                fontFamily: 'Nexa',
                                color: Color.fromARGB(255, 20, 20, 20),
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  for (var item in _boletimItems(context, constraints)) item,
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _boletimItems(BuildContext context, BoxConstraints constraints) {
    return [
      _buildBoletimItem(context, 'confirmados', 'Casos Confirmados',
          const Alignment(0, -.53), constraints, true),
      _buildBoletimItem(context, 'isolamentoDomiciliar', 'Isolamento',
          Alignment(widgetx, widgety - .244), constraints),
      _buildBoletimItem(context, 'aguardandoResultado', 'Aguardando Resultados',
          Alignment(widgetx, widgety - .046), constraints),
      _buildBoletimItem(context, 'internados', 'Internados',
          Alignment(widgetx, widgety + .155), constraints),
      _buildBoletimItem(
          context,
          'recuperados',
          'Recuperados / Fim de Isolamento',
          Alignment(widgetx, widgety + .354),
          constraints),
      _buildBoletimItem(context, 'obitos', 'Óbitos',
          Alignment(widgetx, widgety + .554), constraints),
    ];
  }

  Widget _buildBoletimItem(BuildContext context, String key, String label,
      Alignment alignment, BoxConstraints constraints,
      [bool isConfirmados = false]) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () => _showPopup(context, label, key),
        child: Container(
          alignment: Alignment.center,
          width: constraints.maxHeight / (isConfirmados ? 2.8 : 5.5),
          height: constraints.maxHeight / (isConfirmados ? 13 : 15),
          child: Consumer<ValoresBoletim>(
            builder: (context, value, child) {
              return Text(
                valoresBoletimMap[key].toString(),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(
                    constraints.maxHeight / (isConfirmados ? 200 : 350)),
                style: TextStyle(
                  height: 1.8,
                  fontFamily: 'Nexa',
                  color: key == 'confirmados'
                      ? const Color.fromARGB(255, 20, 20, 20)
                      : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context, String label, String key) {
    TextEditingController cont = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(150, 255, 255, 255),
            title: Center(child: Text(label)),
            content: TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(100, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              autofocus: true,
              controller: cont,
              keyboardType: TextInputType.number,
              onChanged: (v) => print(v),
              onFieldSubmitted: (value) {
                if (cont.text.isNotEmpty) {
                  valoresBoletimMap[key] = int.parse(cont.text);
                }
                Navigator.pop(context);
              },
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (cont.text.isNotEmpty) {
                      valoresBoletimMap[key] = int.parse(cont.text);
                      Provider.of<ValoresBoletim>(context, listen: false)
                          .setValues(
                        dataString: dataBoletim,
                        confirmados:
                            key == 'confirmados' ? int.parse(cont.text) : null,
                        isolamentoDomiciliar: key == 'isolamentoDomiciliar'
                            ? int.parse(cont.text)
                            : null,
                        aguardandoResultados: key == 'aguardandoResultado'
                            ? int.parse(cont.text)
                            : null,
                        internados:
                            key == 'internados' ? int.parse(cont.text) : null,
                        recuperados:
                            key == 'recuperados' ? int.parse(cont.text) : null,
                        obitos: key == 'obitos' ? int.parse(cont.text) : null,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2012, 8),
      lastDate: DateTime(2101),
    ).then((picked) {
      if (picked != null) {
        dataBoletim =
            '${picked.day.toString().padLeft(2, '0')} DE ${DateFormat('MMMM', 'pt-BR').format(picked)} de ${picked.year}'
                .toUpperCase();
        Provider.of<ValoresBoletim>(context, listen: false)
            .setValues(dataString: dataBoletim, data: picked);
      }
    });
  }
}
