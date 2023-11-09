import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:models/firebase_options.dart';
import 'package:models/home%20screen.dart';
import 'package:models/password_field.dart';

import 'coaching_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: DynamicUserForm(),));
}



class DynamicUserForm extends StatefulWidget {
  @override
  _DynamicUserFormState createState() => _DynamicUserFormState();
}

class _DynamicUserFormState extends State<DynamicUserForm> {
  final _formKey = GlobalKey<FormState>();
  User _user = User(email: '', phoneNumber: 0);
  bool _showPasswordField = false;

  void _updateFormType(String input) {
    if (input.contains('@') && input.contains('.')) {
      setState(() => _showPasswordField = true);
    } else {
      setState(() => _showPasswordField = false);
    }
  }

  Future<void> _saveUserDataToFirestore(User user) async {
    // For demonstration, using a fixed document ID 'unique_user_id'
    String documentId = 'unique_user_id';
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users
        .doc(documentId)
        .set({
          'email': user.email,
          'phoneNumber': user.phoneNumber,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _user.email,
                decoration: InputDecoration(labelText: 'Email or Phone Number'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _updateFormType(value);
                },
                onSaved: (value) {
                  setState(() {
                    if (_showPasswordField) {
                      _user =
                          User(email: value!, phoneNumber: _user.phoneNumber);
                    } else {
                      _user = User(
                          email: _user.email,
                          phoneNumber: int.tryParse(value!) ?? 0);
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or phone number';
                  }
                  if (_showPasswordField && !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              if (_showPasswordField) ...[PasswordField()],
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    _saveUserDataToFirestore(_user).then((_) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }).catchError((error) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add user: $error'),
                        ),
                      );
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
