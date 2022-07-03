import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:zest/api/calls/login.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/main_provider.dart';
import 'package:zest/app/navigation/nav_bar.dart';
import 'package:zest/app/shared/auto_complete_options_view.dart';
import 'package:zest/generated/l10n.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) =>
          MainProvider(Provider.of<AppProvider>(context, listen: false)),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/banner-bg.png"),
                    fit: BoxFit.cover)),
          ),
          const AutoRouter(),
          const NavBar(),
          const LoginDialog(),
        ],
      ));
}

class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: mainProvider.isLoggedIn
            ? const SizedBox.shrink()
            : LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Color(0xDD000000)),
                    ),
                    Center(
                      child: SizedBox(
                        width: constraints.maxWidth / 2,
                        child: Material(
                          elevation: 10.0,
                          child: Localizations(
                            locale: Localizations.localeOf(context),
                            delegates: const [
                              S.delegate,
                              GlobalMaterialLocalizations.delegate,
                              GlobalWidgetsLocalizations.delegate,
                            ],
                            child: const LoginForm(),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _email(context),
                _password(context),
                ..._formErrors(context, mainProvider.loginCall,
                    mainProvider.isReloggingIn),
                _formAction(context, mainProvider.loginCall),
              ],
            ),
          ),
        ));
  }

  Widget _email(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
            // textEditingController: _emailController,
            // focusNode: _emailFocusNode,
            optionsBuilder: (textEditingValue) {
              final text = textEditingValue.text;
              if (text == '') {
                return const Iterable<String>.empty();
              }
              final emails = null; //users.knownEmails;
              if (emails == null) {
                return const Iterable<String>.empty();
              }
              return emails.where((element) {
                return element.length > text.length &&
                    element.startsWith(text.toLowerCase());
              });
            },
            fieldViewBuilder: _emailAutocompleteField,
            optionsViewBuilder: (context, onSelected, options) =>
                AutoCompleteOptionsView(
                    entries: options,
                    maxWidth: constraints.biggest.width,
                    onSelected: onSelected),
          ));

  Widget _emailAutocompleteField(
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) =>
      TextFormField(
        key: _emailKey,
        keyboardType: TextInputType.emailAddress,
        controller: textEditingController,
        onFieldSubmitted: (value) {
          _passwordFocusNode.requestFocus();
        },
        enabled: Provider.of<MainProvider>(context).loginCall?.loading != true,
        autofocus: true,
        focusNode: _emailFocusNode,
        validator: Validators.compose([
          Validators.required(S.of(context).loginEmailRequired),
          Validators.email(S.of(context).loginEmailInvalid),
        ]),
        decoration: InputDecoration(labelText: S.of(context).loginEmail),
      );

  Widget _password(BuildContext context) => TextFormField(
        key: _passwordKey,
        keyboardType: TextInputType.visiblePassword,
        // controller: controller,
        onFieldSubmitted: (value) {
          _submit();
        },
        enabled: Provider.of<MainProvider>(context).loginCall?.loading != true,
        focusNode: _passwordFocusNode,
        obscureText: true,
        validator: Validators.required(S.of(context).loginPasswordRequired),
        decoration: InputDecoration(labelText: S.of(context).loginPassword),
      );

  List<Widget> _formErrors(
      BuildContext context, LoginCall? loginCall, bool reLogin) {
    return [
      if (loginCall?.error != null) const SizedBox(height: 10),
      if (loginCall?.error is LoginIncorrectException)
        Text(reLogin
            ? S.of(context).reLoginErrorIncorrect
            : S.of(context).loginErrorIncorrect)
      else if (loginCall?.error != null)
        Text(S.of(context).loginErrorGeneral)
      else
        const SizedBox(height: 10),
    ];
  }

  Widget _formAction(BuildContext context, LoginCall? loginCall) =>
      AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: loginCall?.loading == true
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submit,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      S.of(context).loginAction,
                      maxLines: 1,
                      // style: TextStyle(
                      //     color: platformThemeData(
                      //   context,
                      //   material: (theme) => theme.textTheme.bodyText1!.color,
                      //   cupertino: (theme) => theme.textTheme.textStyle.color,
                      // )),
                    ),
                  ),
                ));

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // final UsersProvider users = Provider.of(context, listen: false);
      // users.login(
      //     _emailController.text, _passwordController.text, widget.onLogin);
    } else {
      if (_emailKey.currentState!.hasError) {
        _emailFocusNode.requestFocus();
      } else {
        _passwordFocusNode.requestFocus();
      }
    }
  }
}
