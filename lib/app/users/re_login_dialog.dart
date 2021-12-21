import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

Future<T?> showReLoginDialog<T>(BuildContext context) {
  final users = Provider.of<UsersProvider>(context, listen: false);
  if (users.canReLogin()) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    onLogin() {
      if (formKey.currentState!.validate()) {
        users.reLogin(passwordController.text, () => Navigator.pop(context));
      }
    }

    return showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(l10n.loginAction),
        content: StatefulBuilder(builder: (context, setState) {
          return ReLoginWidget(
            formKey: formKey,
            passwordController: passwordController,
            onLogin: onLogin,
          );
        }),
        actions: [
          PlatformDialogAction(
            child: PlatformText(l10n.appActionCancel),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText(l10n.loginAction),
            onPressed: onLogin,
          )
        ],
      ),
    );
  }
  throw StateError("No user to re-login");
}

class ReLoginWidget extends StatefulWidget {
  const ReLoginWidget(
      {Key? key,
      required this.formKey,
      required this.passwordController,
      required this.onLogin})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final void Function() onLogin;

  @override
  State<StatefulWidget> createState() => ReLoginWidgetState();
}

class ReLoginWidgetState extends State<ReLoginWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final users = Provider.of<UsersProvider>(context);
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: ThemeProvider.formMargin),
          Text(l10n.reLoginDescription),
          passwordFormField(context, widget.passwordController, () {}, true),
          const SizedBox(height: ThemeProvider.formMargin),
          AnimatedSwitcher(
              child: users.loginCall?.loading == true
                  ? PlatformCircularProgressIndicator()
                  : Column(
                      children: formErrors(context, users, reLogin: true),
                    ),
              duration: const Duration(milliseconds: 100)),
          const SizedBox(height: ThemeProvider.formMargin),
        ],
      ),
    );
  }
}

Widget passwordFormField(BuildContext context, TextEditingController controller,
    Function() submit, bool enabled) {
  final l10n = AppLocalizations.of(context)!;
  return PlatformTextFormField(
    keyboardType: TextInputType.visiblePassword,
    controller: controller,
    onFieldSubmitted: (value) {
      submit();
    },
    enabled: enabled,
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

List<Widget> formErrors(BuildContext context, UsersProvider users,
    {bool reLogin = false}) {
  final l10n = AppLocalizations.of(context)!;
  return [
    if (users.loginCall?.error != null)
      const SizedBox(height: ThemeProvider.formMargin),
    if (users.loginCall?.error is LoginIncorrectException)
      Text(reLogin ? l10n.reLoginErrorIncorrect : l10n.loginErrorIncorrect,
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
}
