import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/error_text.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/auto_complete_entries.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  final void Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<AppProvider, APIProvider,
        UsersProvider>(
      create: (context) => UsersProvider()..init(),
      update: (context, app, api, users) => users!.onUpdate(app, api),
      child: PlatformScaffold(
        body: SafeArea(
          minimum: ThemeProvider.screenEdgeInsets,
          child: Center(child: LoginForm(onLogin)),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm(this.onLogin, {Key? key}) : super(key: key);

  final void Function() onLogin;

  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    final UsersProvider users = Provider.of(context);
    _emailController =
        TextEditingController(text: users.loginCall?.username ?? "");
    _passwordController =
        TextEditingController(text: users.loginCall?.password ?? "");
    final l10n = AppLocalizations.of(context)!;

    return Container(
      constraints: const BoxConstraints(
          maxWidth: ThemeProvider.centerFormColumnMaxWidth),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _email(context),
            const SizedBox(height: ThemeProvider.formMargin),
            _password(context),
            const SizedBox(height: ThemeProvider.formMargin),
            if (users.loginCall?.error is LoginIncorrectException)
              ErrorText(l10n.loginErrorIncorrect)
            else if (users.loginCall?.error != null)
              ErrorText(l10n.loginErrorGeneral),
            const SizedBox(height: ThemeProvider.formActionMargin),
            PlatformElevatedButton(
              onPressed: _submit,
              child: PlatformText(l10n.loginAction),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final UsersProvider users = Provider.of(context, listen: false);
      users.login(
          _emailController.text, _passwordController.text, widget.onLogin);
    } else {
      _emailFocusNode.requestFocus();
    }
  }

  Widget _email(BuildContext context) => RawAutocomplete<String>(
        textEditingController: _emailController,
        focusNode: _emailFocusNode,
        optionsBuilder: (textEditingValue) {
          final text = textEditingValue.text;
          if (text == '') {
            return const Iterable<String>.empty();
          }
          //TODO: Provider.of<UsersProvider>(context).knownEmails;
          final emails = null;
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
            AutoCompleteEntries(
                entries: options,
                maxWidth: ThemeProvider.centerFormColumnMaxWidth,
                onSelected: onSelected),
      );

  Widget _emailAutocompleteField(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    final l10n = AppLocalizations.of(context)!;
    return PlatformTextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: textEditingController,
      onFieldSubmitted: (value) {
        _submit();
      },
      autofocus: true,
      focusNode: _emailFocusNode,
      validator: Validators.compose([
        Validators.required(l10n.loginEmailRequired),
        Validators.email(l10n.loginEmailInvalid),
      ]),
      material: (context, platform) => MaterialTextFormFieldData(
        decoration: InputDecoration(labelText: l10n.loginEmail),
      ),
      cupertino: (context, platform) => CupertinoTextFormFieldData(
        placeholder: l10n.loginEmail,
      ),
    );
  }

  Widget _password(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlatformTextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      onFieldSubmitted: (value) {
        _submit();
      },
      obscureText: true,
      validator: Validators.required(l10n.loginPasswordRequired),
      material: (context, platform) => MaterialTextFormFieldData(
        decoration: InputDecoration(labelText: l10n.loginPassword),
      ),
      cupertino: (context, platform) => CupertinoTextFormFieldData(
        placeholder: l10n.loginPassword,
      ),
    );
  }
}
