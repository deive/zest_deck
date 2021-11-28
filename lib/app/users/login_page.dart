import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:zest_deck/app/error_text.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/auto_complete_options_view.dart';
import 'package:zest_deck/app/users/users_provider.dart';

/// Shows the login page.
/// onLogin callback is called when the user successfully logs in.
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  final void Function() onLogin;

  @override
  Widget build(BuildContext context) => PlatformScaffold(
        body: SafeArea(
          minimum: ThemeProvider.screenEdgeInsets,
          child: Center(child: LoginForm(() {
            AutoRouter.of(context).removeLast();
            // TODO: Still web has an active back button :-(
            // see https://github.com/Milad-Akarie/auto_route_library/issues/794#issuecomment-971654316
            // App.appRouter.markUrlStateForReplace();
            onLogin();
          })),
        ),
      );
}

/// Shows the login form.
/// onLogin callback is called when the user successfully logs in.
class LoginForm extends StatefulWidget {
  const LoginForm(this.onLogin, {Key? key}) : super(key: key);

  final void Function() onLogin;

  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  late UsersProvider users;
  late AppLocalizations l10n;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    users = Provider.of(context);
    l10n = AppLocalizations.of(context)!;
    _emailController =
        TextEditingController(text: users.loginCall?.username ?? "");
    _passwordController =
        TextEditingController(text: users.loginCall?.password ?? "");

    return Container(
      constraints: const BoxConstraints(
          maxWidth: ThemeProvider.centerFormColumnMaxWidth),
      child: _form(context),
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

  Widget _form(BuildContext context) => Form(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AnimatedSwitcher(
                      child: users.loginCall?.loading == true
                          ? PlatformCircularProgressIndicator()
                          : PlatformElevatedButton(
                              onPressed: _submit,
                              child: PlatformText(l10n.loginAction),
                            ),
                      duration: const Duration(milliseconds: 100)),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _email(BuildContext context) => RawAutocomplete<String>(
        textEditingController: _emailController,
        focusNode: _emailFocusNode,
        optionsBuilder: (textEditingValue) {
          final text = textEditingValue.text;
          if (text == '') {
            return const Iterable<String>.empty();
          }
          final emails = users.knownEmails;
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
      enabled: users.loginCall?.loading != true,
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
      enabled: users.loginCall?.loading != true,
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
