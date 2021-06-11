import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/localization/localization.dart';
import 'package:starterapp/signup/blocs/blocs.dart';

class SignUpPage extends StatefulWidget {
  final String title;

  SignUpPage({required this.title});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignUpPage(title: 'Create Account'));
  }

  @override
  _SignUpPageState createState() {
    return _SignUpPageState(this.title);
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final String title;
  _SignUpPageState(this.title);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocaleBloc, LocaleState>(
        listener: (context, state) {
          print('current locale ${state.locale}');
        },
        child:BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context).translate('sign_up'), style: TextStyle(fontSize: 16,)),
                  actions: [
                    IconButton(
                      icon: Image.asset(AppLocalizations.of(context).isEnLocale
                          ? "assets/images/language.png"
                          : "assets/images/myanmar_lan.png", width: 20, height: 20,),
                      onPressed: () async {
                        context.read<LocaleBloc>().add(
                            ToggleLanguage(newLanguage: AppLocalizations.of(context).isEnLocale ? 'my' : 'en'));
                      },
                    ),

                  ],
                ),
                body: SafeArea(
                      minimum: const EdgeInsets.all(16),
                      child: Container(
                          alignment: Alignment.center,
                          child:  _SignUpForm(),
                      ),
                    )
              );


            }
        ),
    );

  }

}

class _SignUpForm extends StatefulWidget {
  @override
  __SignUpFormState createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  @override
  Widget build(BuildContext context) {

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _EmailInput(),
                  SizedBox(
                    height: 12,
                  ),
                  _PasswordInput(),
                  const SizedBox(
                    height: 16,
                  ),

                  _SignUpButton(),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 8.0),
                  _LoginButton(),

                ],
              ),


          );
        },
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (password) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(password)),
          obscureText: false,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate("email"),
            helperText: '',
            errorText: state.email.invalid ? AppLocalizations.of(context).translate('invalid_email') : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('password'),
            helperText: '',
            errorText: state.password.invalid ? AppLocalizations.of(context).translate('invalid_password') : null,
          ),
        );
      },
    );
  }

}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Container(
            child: Center(child: CircularProgressIndicator(),)
        )
            :
          ElevatedButton(
          key: const Key('signUpForm_continue_raisedButton'),
          child: Text(AppLocalizations.of(context).translate('sign_up_btn')),
          onPressed: state.status.isValidated? () {
            context.read<SignUpBloc>().add(SignUpWithEmailButtonPressed());
          }
              : null,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SignUpBloc signUpBloc = BlocProvider.of<SignUpBloc>(context);
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('signUpForm_login_flatButton'),
      onPressed: () => signUpBloc.add(SignUpLoginPressed()),
      child: Text(
        AppLocalizations.of(context).translate('login'),
        style: TextStyle(color: theme.primaryColor),

      ),
    );
  }
}
