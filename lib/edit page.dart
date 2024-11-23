import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_web_api/Model.dart';
import 'package:flutter_web_api/api_handler.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class Edit_page extends StatefulWidget {
  final User user;
  Edit_page({super.key, required this.user});

  @override
  State<Edit_page> createState() => _Edit_pageState();
}

class _Edit_pageState extends State<Edit_page> {
  ApiHandler apiHandler = ApiHandler();
  final _formkey = GlobalKey<FormBuilderState>();
  late http.Response response;
  void updateData() async {
    if (_formkey.currentState!.saveAndValidate()) {
      final data = _formkey.currentState!.value;
      final user = User(
        userId: widget.user.userId,
        name: data['name'],
        address: data['address'],
      );
      response =
          await apiHandler.updateUser(userId: widget.user.userId, user: user);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          color: Colors.green,
          textColor: Colors.white,
          onPressed: updateData,
          child: const Text("Update"),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FormBuilder(
          key: _formkey,
          initialValue: {
            'name': widget.user.name,
            'address': widget.user.address
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'address',
                decoration: InputDecoration(labelText: 'Address'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
