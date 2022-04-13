import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:massive_messages/providers/send_messages_provider.dart';
import 'package:massive_messages/ui/input_decorations.dart';
import 'package:massive_messages/widgets/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:cool_alert/cool_alert.dart';

class SendMessagesScreen extends StatelessWidget {
  const SendMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackGround(
          icon: Icons.file_present_rounded,
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
                        'Mensajeria masiva',
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
  bool isLoading = false;
  bool error = false;
  late PlatformFile file;
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
                        IconButton(
                            onPressed: () {
                              setState(() {
                                openFile(file);
                              });
                            },
                            icon: const Icon(Icons.file_present_rounded,
                                color: Colors.green)),
                        SizedBox(
                          width: 180,
                          child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                openFile(file);
                              });
                            }),
                            child: Text(fileName,
                                softWrap: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
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
                        file = result.files.first;
                        fileName = result.files.single.name;
                        isSelected = true;
                      });
                    }),
                    child: const Text('Subir archivo')),
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    loginform.positionPhone = int.parse(value),
                decoration: InputDecorations.authInputDecoration(
                    hintText: '',
                    labelText: 'posicion del telefono...',
                    prefixIcon: Icons.phone_iphone),
                validator: (value) {
                  if (value != null && value != '') return null;
                  return 'La posoción  del  telefono es necesaria..';
                }),
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.text,
                onChanged: (value) => loginform.positionEmail = value,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '',
                    labelText: 'posicion del email...',
                    prefixIcon: Icons.email_sharp),
                validator: (value) {
                  if (value != null && value != '') return null;
                  return 'La posoción del email  es necesaria..';
                }),
            TextFormField(
              maxLines: 50,
              minLines: 1,
              onChanged: (value) => loginform.message = value,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '',
                  labelText: 'mensaje..',
                  prefixIcon: Icons.message_sharp),
              validator: (value) {
                if (value != null && value.length >= 6) return null;
                return 'El mensaje no puede ser vacio..';
              },
            ),
            // const SizedBox(height: 30),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: !loginform.isLoading
                  ? () async {
                      FocusScope.of(context).unfocus();
                      if (!loginform.isvalidForm()) return;
                      isLoading = true;
                      loginform.isLoading = true;

                      if (isLoading) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.loading,
                          text: "Enviando mensajes...",
                        );
                      }
                      await loginform.sendData(
                          file: loginform.file,
                          message: loginform.message,
                          positionPhone: loginform.positionPhone,
                          positionEmail: loginform.positionEmail);
                      setState(() {
                        isLoading = false;
                        Navigator.of(context).pop();
                      });
                      await Future.delayed(const Duration(milliseconds: 200));
                      loginform.isLoading = false;
                      if (loginform.showError) {
                        error = loginform.showError;
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: loginform.errorMessage,
                        );
                      }
                      if (loginform.responseMessage ==
                          'Fallaron los envios de algunos mensajes :(') {
                        CoolAlert.show(
                          title: ':(',
                          context: context,
                          type: CoolAlertType.info,
                          text: loginform.responseMessage,
                        );
                      } else {
                        CoolAlert.show(
                          title: 'Completado!',
                          context: context,
                          type: CoolAlertType.success,
                          text: loginform.responseMessage,
                        );
                      }
                      loginform.resetForm();
                      setState(() {
                        isSelected = false;
                      });
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
