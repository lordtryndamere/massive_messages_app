import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:massive_messages/providers/login_form_provider.dart';
import 'package:massive_messages/ui/input_decorations.dart';
import 'package:massive_messages/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackGround(
          icon: Icons.person_pin,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        isLogin ? 'Login' : 'Registrarme',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ChangeNotifierProvider(
                          create: (_) => LoginFormProvider(),
                          child: isLogin
                              ? const _LoginForm()
                              : const _RegisterForm()),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: (() {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  }),
                  child: Text(
                    isLogin ? 'Crear una nueva cuenta' : 'Volver al login',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
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
  @override
  Widget build(BuildContext context) {
    final loginform = Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginform.formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => loginform.email = value,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'example@gmail.com',
                  labelText: 'Correo electronico',
                  prefixIcon: Icons.alternate_email_rounded),
              validator: (value) {
                if (loginform.showError) {
                  return loginform.errorMessage;
                }
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo es invalido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              onChanged: (value) => loginform.password = value,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '***',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              validator: (value) {
                if (loginform.showError) {
                  return loginform.errorMessage;
                }
                if (value != null && value.length >= 6) return null;
                return 'La contraseña debe ser mayor o igual a 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: !loginform.isLoading
                  ? () async {
                      FocusScope.of(context).unfocus();
                      if (!loginform.isvalidForm()) return;
                      loginform.isLoading = true;
                      final connection = await loginform.login(
                          email: loginform.email, password: loginform.password);

                      if (connection['code'] == 100) {
                        Navigator.pushReplacementNamed(context, 'home');
                      }
                      loginform.isLoading = false;
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
                    loginform.isLoading ? 'espere' : 'ingresar',
                    style: const TextStyle(color: Colors.white),
                  )),
            )
          ],
        ));
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final loginform = Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginform.formRegisterKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => loginform.fullName = value,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'bob...',
                  labelText: 'nombre completo',
                  prefixIcon: Icons.person),
              validator: (value) {
                if (value != null && value != '') return null;
                return 'El nombre es obligatorio';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              onChanged: (value) => loginform.document = value,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '1111',
                  labelText: 'numero de documento',
                  prefixIcon: Icons.document_scanner),
              validator: (value) {
                if (value != null && value != '') return null;
                return 'El numero de documento es obligatorio..';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              onChanged: (value) => loginform.phoneNumber = value,
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '311111111',
                  labelText: 'celular',
                  prefixIcon: Icons.phone),
              validator: (value) {
                if (value != null && value.length == 10 && value != '') {
                  return null;
                }
                return 'numero de telefono invalido';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              onChanged: (value) => loginform.address = value,
              autocorrect: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'av#..',
                  labelText: 'direccion',
                  prefixIcon: Icons.location_city),
              validator: (value) {
                if (value != null && value != '') return null;
                return 'la direccion es obligatoria ..';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              onChanged: (value) => loginform.email = value,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'example@gmail.com',
                  labelText: 'Correo electronico',
                  prefixIcon: Icons.alternate_email_rounded),
              validator: (value) {
                if (loginform.showError) {
                  return loginform.errorMessage;
                }
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo es invalido';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              onChanged: (value) => loginform.password = value,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '***',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              validator: (value) {
                if (loginform.showError) {
                  return loginform.errorMessage;
                }
                if (value != null && value.length >= 6) return null;
                return 'La contraseña debe ser mayor o igual a 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: !loginform.isLoading
                  ? () async {
                      FocusScope.of(context).unfocus();
                      if (!loginform.isvalidFormRegister()) return;
                      loginform.isLoading = true;
                      if (loginform.isLoading) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.loading,
                          text: "Espere...",
                        );
                      }
                      final connection = await loginform.register(
                        fullName: loginform.fullName,
                        document: loginform.document,
                        phoneNumber: loginform.phoneNumber,
                        address: loginform.address,
                        email: loginform.email,
                        password: loginform.password,
                      );

                      Navigator.of(context).pop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      loginform.isLoading = false;
                      if (loginform.showError) {
                        CoolAlert.show(
                          context: context,
                          type: connection['code'] == 102
                              ? CoolAlertType.info
                              : CoolAlertType.error,
                          text: loginform.errorMessage,
                        );
                      } else {
                        CoolAlert.show(
                          title: 'Registro exitoso!',
                          context: context,
                          type: CoolAlertType.success,
                          text: loginform.responseMessage,
                        );
                      }
                      //TODO:Crear pantalla de verificar usuario para activar
                      await Future.delayed(const Duration(milliseconds: 1000));
                      if (connection['code'] == 100) {
                        Navigator.pushReplacementNamed(context, 'home');
                        loginform.resetRegister();
                      }
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
                    loginform.isLoading ? 'espere' : 'Registrarme',
                    style: const TextStyle(color: Colors.white),
                  )),
            )
          ],
        ));
  }
}
