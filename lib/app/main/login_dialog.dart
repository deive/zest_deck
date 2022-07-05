import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:zest/api/calls/login.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/auto_complete_options_view.dart';
import 'package:zest/generated/l10n.dart';

/// Login dialog
class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Row(
          children: const [
            Expanded(flex: 4, child: SizedBox.shrink()),
            Expanded(flex: 8, child: LoginFormLogo()),
            Expanded(flex: 1, child: SizedBox.shrink()),
            Expanded(flex: 16, child: LoginFormMaterial()),
            Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        ),
      );
}

class LoginFormLogo extends StatelessWidget {
  const LoginFormLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(flex: 1, child: SvgPicture.asset("assets/zest_z.svg")),
          Expanded(
              flex: 2,
              child: AutoSizeText(
                S.of(context).appName.toUpperCase(),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 100,
                  fontFamily: 'nasalization',
                ),
              )),
        ],
      );
}

/// Adds required material to a LoginForm.
class LoginFormMaterial extends StatelessWidget {
  const LoginFormMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Localizations(
        locale: Localizations.localeOf(context),
        delegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: const LoginForm(),
      ),
    );
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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _emailController =
        TextEditingController(text: authProvider.loginCall?.username ?? "");
    _passwordController =
        TextEditingController(text: authProvider.loginCall?.password ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _email(context),
                const SizedBox(height: 10),
                _password(context),
                ..._formErrors(context, authProvider.loginCall,
                    authProvider.reloginRequested),
                _formAction(context),
                // TODO: Cancel when re-logging in.
              ],
            ),
          ),
        ));
  }

  Widget _email(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
            optionsBuilder: (textEditingValue) {
              final text = textEditingValue.text;
              if (text == '') {
                return const Iterable<String>.empty();
              }
              final emails = null; //TODO: users.knownEmails;
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
        enabled: Provider.of<AuthProvider>(context).loginCall?.loading != true,
        autofocus: true,
        focusNode: _emailFocusNode,
        validator: Validators.compose([
          Validators.required(S.of(context).loginEmailRequired),
          Validators.email(S.of(context).loginEmailInvalid),
        ]),
        decoration: InputDecoration(
          labelText: S.of(context).loginEmail,
          border: const OutlineInputBorder(),
        ),
      );

  Widget _password(BuildContext context) => TextFormField(
        key: _passwordKey,
        keyboardType: TextInputType.visiblePassword,
        onFieldSubmitted: (value) {
          _submit();
        },
        enabled: Provider.of<AuthProvider>(context).loginCall?.loading != true,
        focusNode: _passwordFocusNode,
        obscureText: true,
        validator: Validators.required(S.of(context).loginPasswordRequired),
        decoration: InputDecoration(
          labelText: S.of(context).loginPassword,
          border: const OutlineInputBorder(),
        ),
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

  Widget _formAction(BuildContext context) => AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: Provider.of<AuthProvider>(context).isLoggingIn
          ? const CircularProgressIndicator()
          : ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                Provider.of<ThemeProvider>(context).zestHighlightColour,
              )),
              onPressed: _submit,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  S.of(context).loginAction,
                  maxLines: 1,
                ),
              ),
            ));

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login(LoginCall(
        _emailController.text,
        _passwordController.text,
      ));
    } else {
      if (_emailKey.currentState!.hasError) {
        _emailFocusNode.requestFocus();
      } else {
        _passwordFocusNode.requestFocus();
      }
    }
  }
}
