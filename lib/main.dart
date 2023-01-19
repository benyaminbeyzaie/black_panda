import 'package:black_panda/input_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/panda_form_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PandaFormCubit(),
      child: MaterialApp(
        title: 'Black Panda',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Black Panda'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _linesTextFieldController =
      TextEditingController();
  final TextEditingController _columnsTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Input your ideal form columns number:',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Columns',
                hintText: '1',
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
              controller: _columnsTextFieldController,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Enter your ideal form using the format {Type} {Label} in each line:',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _linesTextFieldController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Enter multiline text',
                hintText: 'type something...',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<PandaFormCubit>().loadForm(
                      _linesTextFieldController.text,
                      _columnsTextFieldController.text,
                    );
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Done'),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          _buildForm()
        ],
      ),
    );
  }

  Widget _buildForm() {
    return BlocBuilder<PandaFormCubit, PandaFormState>(
      builder: (context, state) {
        if (state is PandaFormInitial) {
          return const SizedBox.shrink();
        }
        if (state is PandaFormError) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Panda can't generate a form for you: ${state.message}",
              textAlign: TextAlign.center,
            ),
          ));
        }
        if (state is PandaFormLoading) {
          return const CircularProgressIndicator();
        }
        if (state is PandaFormLoaded) {
          return GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: state.columnsCount,
                mainAxisExtent: 80,
              ),
              children: _buildInputs(state.inputModels));
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _buildInputs(List<InputModel> inputModels) {
    List<Widget> inputs = [];
    for (var i = 0; i < inputModels.length; i++) {
      if (inputModels[i].type == InputType.bool) {
        inputs.add(
          SwitchListTile(
            title: Text(inputModels[i].label),
            value: inputModels[i].value,
            onChanged: (value) {
              setState(() {
                inputModels[i].value = value;
              });
            },
          ),
        );
        continue;
      }
      if (inputModels[i].type == InputType.string) {
        inputs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                label: Text(inputModels[i].label),
              ),
              onChanged: (value) => inputModels[i].value = value,
            ),
          ),
        );
        continue;
      }
    }
    return inputs;
  }
}
