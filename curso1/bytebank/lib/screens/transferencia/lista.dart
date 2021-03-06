import 'package:bytebank/models/transferencia_model.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:flutter/material.dart';

const _labelAppBar = 'Transferências';
const _messageTransfSalva = 'Transferência salva com sucesso!';
const _messageTransfRemovida = 'Transferência removida com sucesso!';
const _prefixValor = 'R\$ ';
const _labelButtonEdit = 'Editar';
const _labelButtonDelete = 'Remover';

class ListaTransferencia extends StatefulWidget {
  final List<TransferenciaModel> _tranferencias = <TransferenciaModel>[];

  @override
  _ListaTransferenciaState createState() {
    return _ListaTransferenciaState();
  }
}

class _ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labelAppBar)),
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
        onPressed: () => _editOrCreate(null),
      ),
    );
  }

  void _editOrCreate(TransferenciaModel transferencia) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormularioTransferencia(editing: transferencia)),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (transferencia == null) {
            widget._tranferencias.add(value);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_messageTransfSalva)));
        });
      }
    });
  }

  void _delete(TransferenciaModel transferencia) {
    if (transferencia != null) {
      setState(() {
        bool removida = widget._tranferencias.remove(transferencia);
        if (removida) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_messageTransfRemovida)));
        }
      });
    }
  }
}

class ItemTransferencia extends StatelessWidget {
  final TransferenciaModel transferencia;
  final void Function(TransferenciaModel value) onEdit;
  final void Function(TransferenciaModel value) onDelete;

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
        title: Text(_prefixValor + transferencia.valorStr),
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
                child: Text(_labelButtonEdit),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text(_labelButtonDelete),
              ),
            ];
          },
        ),
      ),
    );
  }
}
