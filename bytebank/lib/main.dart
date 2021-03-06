import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListaTransferencias(),
    );
  }
}

class FormularioTransferencia extends StatefulWidget {
  final Transferencia editing;
  FormularioTransferencia({this.editing});

  @override
  _FormularioTransferenciaState createState() {
    return _FormularioTransferenciaState();
  }
}

class _FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta = TextEditingController();
  final TextEditingController _controladorCampoDigitoConta = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.editing != null) {
      _controladorCampoNumeroConta.text = widget.editing.numeroConta.toString();
      _controladorCampoDigitoConta.text = widget.editing.digitoConta;
      _controladorCampoValor.text = widget.editing.valorStr;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Criando Transferência')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Editor(
                    labelText: 'Número da Conta',
                    controller: _controladorCampoNumeroConta,
                    hintText: '0000',
                    keyboardType: TextInputType.number,
                    margin: EdgeInsets.fromLTRB(16, 16, 0, 16),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Editor(
                    labelText: 'Dígito',
                    controller: _controladorCampoDigitoConta,
                    hintText: '1',
                    maxLength: 1,
                  ),
                ),
              ],
            ),
            Editor(
              labelText: 'Valor',
              controller: _controladorCampoValor,
              icon: Icon(Icons.monetization_on),
              hintText: '100.00',
              prefixText: 'R\$ ',
              keyboardType: TextInputType.number,
            ),
            Botao(
              child: Text('Confirmar'),
              onPressed: () => _salvaTransferencia(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _salvaTransferencia(BuildContext context) {
    final String numeroConta = _controladorCampoNumeroConta.text;
    final String digitoConta = _controladorCampoDigitoConta.text;
    final String valor = _controladorCampoValor.text;

    if (numeroConta == null || numeroConta.length == 0) {
      _showSnackbar(context, 'Número da conta é obrigatório!');
      return;
    }

    final int numeroContaInt = int.tryParse(numeroConta);
    if (numeroContaInt == null) {
      _showSnackbar(context, 'Número da conta inválida! Utilize somente números');
      return;
    }

    if (digitoConta == null || digitoConta.length == 0) {
      _showSnackbar(context, 'Dígito da conta é obrigatório!');
      return;
    }

    final int digitoContaInt = int.tryParse(digitoConta);
    if (digitoContaInt == null && 'x' != digitoConta.toLowerCase()) {
      _showSnackbar(context, 'Dígito da conta inválido! Utilize númericos ou \'x\'');
      return;
    }

    if (valor == null || numeroConta.length == 0) {
      _showSnackbar(context, 'Valor é obrigatório!');
      return;
    }

    final double valorDouble = double.tryParse(valor.replaceAll('.', '').replaceAll(',', '.'));
    if (valorDouble == null) {
      _showSnackbar(context, 'Valor inválido! Utilize somente números separados por vírgula');
      return;
    }

    final Transferencia transferencia = _persistirTransferencia(numeroContaInt, digitoConta.toLowerCase(), valorDouble);
    Navigator.pop(context, transferencia);
  }

  Transferencia _persistirTransferencia(int numeroConta, String digitoConta, double valor) {
    if (widget.editing == null) {
      return Transferencia(
        numeroConta: numeroConta,
        digitoConta: digitoConta.toLowerCase(),
        valor: valor,
      );
    }

    widget.editing.numeroConta = numeroConta;
    widget.editing.digitoConta = digitoConta;
    widget.editing.valor = valor;
    return widget.editing;
  }
}

class Botao extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  Botao({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
      ),
    );
  }
}

class Editor extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final double fontSize;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final EdgeInsets margin;
  final int maxLength;
  final String prefixText;

  Editor({
    @required this.labelText,
    this.controller,
    this.fontSize = 16.0,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.margin = const EdgeInsets.all(16.0),
    this.maxLength,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          labelText: labelText,
          hintText: hintText,
          prefixText: prefixText,
          isDense: true,
          counterText: '',
        ),
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _tranferencias = <Transferencia>[];

  @override
  _ListaTransferenciasState createState() {
    return _ListaTransferenciasState();
  }
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transferências')),
      body: ListView.builder(
        itemCount: widget._tranferencias.length,
        itemBuilder: (context, index) => ItemTransferencia(
          transferencia: widget._tranferencias[index],
          onEdit: (transferencia) => _editOrCreate(transferencia),
          onDelete: (transferencia) => _delete(transferencia),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _editOrCreate(null),
      ),
    );
  }

  void _editOrCreate(Transferencia transferencia) {
    Future<Transferencia> future = Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormularioTransferencia(editing: transferencia)),
    );

    future.then((value) {
      if (value != null) {
        setState(() {
          if (transferencia == null) {
            widget._tranferencias.add(value);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transferência salva com sucesso!')));
        });
      }
    });
  }

  void _delete(Transferencia transferencia) {
    if (transferencia != null) {
      setState(() {
        bool removida = widget._tranferencias.remove(transferencia);
        if (removida) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transferência removida com sucesso!')));
        }
      });
    }
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia transferencia;
  final void Function(Transferencia value) onEdit;
  final void Function(Transferencia value) onDelete;

  ItemTransferencia({
    @required this.transferencia,
    @required this.onEdit,
    @required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.monetization_on,
          color: Theme.of(context).primaryColor,
          size: 36,
        ),
        title: Text('R\$ ' + transferencia.valorStr),
        subtitle: Text(transferencia.contaFormat),
        trailing: PopupMenuButton<String>(
          onSelected: (result) {
            if (result == 'edit') {
              onEdit(transferencia);
            } else if (result == 'delete') {
              onDelete(transferencia);
            }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Editar'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Excluir'),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class Transferencia {
  int numeroConta;
  String digitoConta;
  double valor;

  Transferencia({
    @required this.numeroConta,
    @required this.digitoConta,
    @required this.valor,
  });

  String get valorStr {
    return valor.toStringAsFixed(2).replaceAll(',', '').replaceAll('.', ',');
  }

  String get contaFormat {
    return numeroConta.toString() + '-' + digitoConta;
  }

  @override
  String toString() {
    return 'Transferencia{numeroConta: $numeroConta, digitoConta: $digitoConta, valor: $valor}';
  }
}
