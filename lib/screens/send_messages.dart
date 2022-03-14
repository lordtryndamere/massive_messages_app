import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:massive_messages/providers/send_messages_provider.dart';
import 'package:massive_messages/ui/input_decorations.dart';
import 'package:massive_messages/widgets/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class SendMessagesScreen extends StatelessWidget {
  const SendMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackGround(
          icon: Icons.message_outlined,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 250,
                ),
                CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Mensages Masivos',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ChangeNotifierProvider(
                          create: (_) => SendMessagesProvider(),
                          child: const _LoginForm()),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const SizedBox(height: 50),
              ],
            ),
          )),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  bool isSelected = false;
  String fileName = "";
  @override
  Widget build(BuildContext context) {
    final loginform = Provider.of<SendMessagesProvider>(context);
    void openFile(PlatformFile file) {
      OpenFile.open(file.path);
    }

    return Form(
        key: loginform.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            isSelected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.file_present_rounded,
                              color: Colors.green),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 195,
                          child: Text(fileName,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black)),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isSelected = false;
                              });
                            },
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                            ))
                      ])
                : ElevatedButton(
                    onPressed: (() async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result == null) return;
                      loginform.file = result.files.single.path!;
                      setState(() {
                        fileName = result.files.single.name;
                        isSelected = true;
                      });
                    }),
                    child: const Text('Subir archivo')),
            TextFormField(
              maxLines: 50,
              minLines: 1,
              onChanged: (value) => loginform.message = value,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '',
                  labelText: 'mensaje..',
                  prefixIcon: Icons.email),
              validator: (value) {
                if (value != null && value.length >= 6) return null;
                return 'El mensaje no puede ser vacio..';
              },
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: !loginform.isLoading
                  ? () async {
                      FocusScope.of(context).unfocus();
                      if (!loginform.isvalidForm()) return;
                      loginform.isLoading = true;
                      final connection = await loginform.sendData(
                          file: loginform.file, message: loginform.message);

                      loginform.isLoading = false;
                      // Navigator.pushReplacementNamed(context, 'home');
                    }
                  : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginform.isLoading ? 'espere' : 'Enviar',
                    style: const TextStyle(color: Colors.white),
                  )),
            )
          ],
        ));
  }
}
