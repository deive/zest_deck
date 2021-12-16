import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/auto_complete_options_view.dart';
import 'package:zest_deck/app/users/users_provider.dart';

/// Shows the login page.
/// onLogin callback is called when the user successfully logs in.
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  final void Function() onLogin;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return PlatformScaffold(
      body: orientation == Orientation.portrait
          ? Column(
              children: _layout(context, orientation),
            )
          : Row(
              children: _layout(context, orientation),
            ),
    );
  }

  List<Widget> _layout(BuildContext context, Orientation orientation) => [
        Expanded(
            flex: 1,
            child: orientation == Orientation.portrait
                ? Column(
                    children: [
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Expanded(flex: 1, child: SizedBox.shrink()),
                              Expanded(
                                  flex: 3,
                                  child: _zestIcon(context, orientation)),
                              const Expanded(flex: 1, child: SizedBox.shrink()),
                            ],
                          ))
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                      Expanded(flex: 3, child: _zestIcon(context, orientation))
                    ],
                  )),
        Expanded(
            flex: 2,
            child: LoginForm(() {
              AutoRouter.of(context).removeLast();
              // TODO: Still web has an active back button :-(
              // see https://github.com/Milad-Akarie/auto_route_library/issues/794#issuecomment-971654316
              // App.appRouter.markUrlStateForReplace();
              onLogin();
            }))
      ];

  // TODO: Icon to SVG. (Svg.asset())
  Widget _zestIcon(BuildContext context, Orientation orientation) {
    final l10n = AppLocalizations.of(context)!;
    final icon = Image.asset("assets/logos/zest_icon.png");
    final text = Text(l10n.appName.toUpperCase(),
        style: const TextStyle(
            fontFamily: 'nasalization', color: ThemeProvider.zestyOrangeDark));
    return orientation == Orientation.portrait
        ? Row(
            children: [
              Expanded(child: icon),
              Expanded(child: FittedBox(child: text)),
            ],
          )
        : Column(
            children: [
              const Expanded(flex: 1, child: SizedBox.shrink()),
              Expanded(
                  flex: 4,
                  child: Align(alignment: Alignment.bottomCenter, child: icon)),
              Expanded(flex: 3, child: FittedBox(child: text)),
            ],
          );
  }
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

    final orientation = MediaQuery.of(context).orientation;
    return Form(
        key: _formKey,
        child: orientation == Orientation.portrait
            ? _formPortrait()
            : _formLandscape());
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

  Widget _formPortrait() => Row(children: [
        const Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
            flex: 4,
            child: Container(
              decoration: _formContainerDecoration(),
              child: Row(
                children: [
                  const Expanded(flex: 1, child: SizedBox.shrink()),
                  Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(height: ThemeProvider.formMargin),
                        _email(context),
                        const SizedBox(height: ThemeProvider.formMargin),
                        _password(context),
                        const SizedBox(height: ThemeProvider.formMargin),
                        ..._formErrors(),
                        const SizedBox(height: ThemeProvider.formMargin),
                        _formAction(),
                        const SizedBox(height: ThemeProvider.formMargin),
                      ]),
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox.shrink()),
                ],
              ),
            )),
      ]);

  Widget _formLandscape() => Row(children: [
        const Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: _formContainerDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            const SizedBox(height: ThemeProvider.formMargin),
                            _email(context),
                            const SizedBox(height: ThemeProvider.formMargin),
                            _password(context),
                            const SizedBox(height: ThemeProvider.formMargin),
                            ..._formErrors(),
                            const SizedBox(height: ThemeProvider.formMargin),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _formAction(),
                              const SizedBox(height: ThemeProvider.formMargin),
                              const SizedBox(height: ThemeProvider.formMargin),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            )),
      ]);

  List<Widget> _formErrors() => [
        if (users.loginCall?.error != null)
          const SizedBox(height: ThemeProvider.formMargin),
        if (users.loginCall?.error is LoginIncorrectException)
          Text(l10n.loginErrorIncorrect,
              style: platformThemeData(
                context,
                material: (data) =>
                    data.textTheme.bodyText1!.copyWith(color: data.errorColor),
                cupertino: (data) => data.textTheme.textStyle,
              ))
        else if (users.loginCall?.error != null)
          Text(l10n.loginErrorGeneral,
              style: platformThemeData(
                context,
                material: (data) =>
                    data.textTheme.bodyText1!.copyWith(color: data.errorColor),
                cupertino: (data) => data.textTheme.textStyle,
              ))
        else
          const SizedBox(height: ThemeProvider.formMargin),
      ];

  BoxDecoration _formContainerDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeProvider.zestyOrangeLight,
              ThemeProvider.zestyOrangeDark
            ]),
      );

  Widget _formAction() => AnimatedSwitcher(
      child: users.loginCall?.loading == true
          ? PlatformCircularProgressIndicator()
          : PlatformElevatedButton(
              onPressed: _submit,
              cupertino: (context, platform) => CupertinoElevatedButtonData(
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: PlatformText(
                  l10n.loginAction,
                  maxLines: 1,
                  style: TextStyle(
                      color: platformThemeData(
                    context,
                    material: (theme) => theme.textTheme.bodyText1!.color,
                    cupertino: (theme) => theme.textTheme.textStyle.color,
                  )),
                ),
              ),
            ),
      duration: const Duration(milliseconds: 100));

  Widget _email(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
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
                    maxWidth: constraints.biggest.width,
                    onSelected: onSelected),
          ));

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
