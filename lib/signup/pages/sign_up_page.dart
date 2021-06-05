import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:starterapp/signup/blocs/blocs.dart';

class SignUpPage extends StatefulWidget {
  final String title;

  SignUpPage({required this.title});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignUpPage(title: ''));
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
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Container(
              alignment: Alignment.center,
              child: _SignUpForm(),
              ),
              //_SignUpForm(),
            )
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
            labelText: 'email',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
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
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
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
          child: const Text('Sign Up'),
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
        'LOGIN',
        style: TextStyle(color: theme.primaryColor),

      ),
    );
  }
}
