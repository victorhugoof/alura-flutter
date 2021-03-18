import 'package:bytebank/components/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameCubit extends Cubit<String> {
  NameCubit(String initialState) : super(initialState);
  void change(String newState) => emit(newState);
}

class NameContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<NameCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text('Change name')),
      body: Column(
        children: [
          TextEditor(
            labelText: 'Name',
            controller: _nameController,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                child: Text('Change'),
                onPressed: () {
                  context.read<NameCubit>().change(_nameController.text);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
