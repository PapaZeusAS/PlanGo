import 'package:flutter/material.dart';
import 'package:plan_go_software_project/Verification/CreateAccount.dart';
import 'package:plan_go_software_project/EventView/EventList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plan_go_software_project/Verification/ResetPassword.dart';

class LogIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLogInPage(),
    );
  }
}

class MyLogInPage extends StatefulWidget {
  MyLogInPage({Key key}) : super(key: key);


  @override
  _MyLogInPageState createState() => _MyLogInPageState();
} 

class _MyLogInPageState extends State<MyLogInPage> {

  String _email;
  String _password;
  String _authHint = '';
  bool _isLoading = false;
  bool _obscurePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override 
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  
  void signIn() async{
    final _formState = _formKey.currentState;

    setState(() {
      _isLoading = true;  
    });
    
    if(_formState.validate()){
      _formState.save();

    //.trim() leaves no space at the end of the email
    //so a bad formatting exception wont be thrown
      try{
        AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.toString().trim(),
                                                                      password: _passwordController.text);

        if(user.user.isEmailVerified) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EventList())); 
          setState(() {
            _isLoading = false;
            _authHint = '';
          });
        } else {
          setState(() {
            _isLoading = false;
            _authHint = 'Please verify your email';
          });
        }
      }catch(e){
        setState(() {
          _isLoading = false; 
          _authHint = 'Email or password is invalid';
        });
        print(e.message);
      }
    }
  }

  //gets called when user tries to call signIn
  String messageNotifier(String message) {
    _isLoading = false;
    return '$message';
  }

  //it only returns the TextFormField Widget
  Widget emailTextFormField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: 'Email'
      ),
      obscureText: false,
      validator: (value) => value.isEmpty ? messageNotifier('Please enter an email') : null,
      onSaved: (value) => _email == value,
    );
  }

  Widget passwordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
              ? Icons.visibility
              : Icons.visibility_off
          ),
          onPressed: (){
            setState(() {
              _obscurePassword = !_obscurePassword;  
            });
          },
        ),
      ),
      validator: (value) => value.isEmpty ? messageNotifier('Please enter a password') : null,
      onSaved: (value) => _password == value,
    );
  }
  List<Widget> submitWidgets() {
    return[
      emailTextFormField(),
      passwordTextFormField()
    ];
  }

  List<Widget> navigateWidgets() {
    return[
      Padding(
        padding: EdgeInsets.all(15.0),
        child: _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RaisedButton(
            onPressed: signIn,
            child: Text('Sign in')
          ), 
      ),
      FlatButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateAccount()));
        },
        textColor: Theme.of(context).accentColor,
        child: new Text('Create Account?'),
      ),
      FlatButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetPassword()));
        },
        textColor: Theme.of(context).accentColor,
        child: new Text('Reset Password'),
      ),
    ];
  }

  Widget signInSuccess() {
    return new Container(
      child: Text(
        _authHint,
        style: TextStyle(
          color: Colors.red
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('LogIn'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Card(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.all(15.0),
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          children: 
                            submitWidgets() +
                            navigateWidgets()
                        )
                      )
                    )
                  ],
                ),
              ),
              signInSuccess()
            ],
          ),
        ),
      ), 
    );
  }
}