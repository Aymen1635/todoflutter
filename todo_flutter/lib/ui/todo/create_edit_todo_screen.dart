import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/app_localizations.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/services/firestore_database.dart';

class CreateEditTodoScreen extends StatefulWidget {
  @override
  _CreateEditTodoScreenState createState() => _CreateEditTodoScreenState();
}

class _CreateEditTodoScreenState extends State<CreateEditTodoScreen> {
  late TextEditingController _taskController;
  late TextEditingController _extraNoteController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TodoModel? _todo;
  late bool _checkboxCompleted;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final TodoModel? _todoModel = ModalRoute.of(context)?.settings.arguments as TodoModel?;
    if (_todoModel != null) {
      _todo = _todoModel;
    }

    _taskController =
        TextEditingController(text: _todo?.task ?? "");
    _extraNoteController =
        TextEditingController(text: _todo?.extraNote ?? "");

    _checkboxCompleted = _todo?.complete ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_todo != null
            ? AppLocalizations.of(context)
                .translate("todosCreateEditAppBarTitleEditTxt")
            : AppLocalizations.of(context)
                .translate("todosCreateEditAppBarTitleNewTxt")),
        actions: <Widget>[
          ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final firestoreDatabase =
          Provider.of<FirestoreDatabase>(context, listen: false);

      firestoreDatabase.setTodo(TodoModel(
          id: _todo?.id ?? documentIdFromCurrentDate(),
          task: _taskController.text,
          extraNote: _extraNoteController.text.isNotEmpty
              ? _extraNoteController.text
              : "",
          complete: _checkboxCompleted));

      Navigator.of(context).pop();
    }
  },
  child: Text("Save"),
)

        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _extraNoteController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _taskController,
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)
                        .translate("todosCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color!, width: 2)),
                  labelText: AppLocalizations.of(context)
                      .translate("todosCreateEditTaskNameTxt"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  controller: _extraNoteController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 15,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
                    labelText: AppLocalizations.of(context)
                        .translate("todosCreateEditNotesTxt"),
                    alignLabelWithHint: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)
                        .translate("todosCreateEditCompletedTxt")),
                    Checkbox(
                        value: _checkboxCompleted,
                        onChanged: (value) {
                          setState(() {
                            _checkboxCompleted = value!;
                          });
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
