import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yeley_frontend/commons/decoration.dart';
import 'package:yeley_frontend/commons/validators.dart';
import 'package:yeley_frontend/providers/users.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kScaffoldBackground,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kScaffoldBackground,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: kMainGreen,
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Text(
                          'Mon adresse',
                          style: kBold18,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              hintText: 'Code postal',
                              hintStyle: kRegular16,
                            ),
                            controller: _postalCodeController,
                            validator: Validator.isNotEmpty,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              hintText: 'Ville',
                              hintStyle: kRegular16,
                            ),
                            controller: _cityController,
                            validator: Validator.isNotEmpty,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  context.watch<UsersProvider>().isSettingAddress
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: kMainGreen,
                        ))
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kMainBlue, shape: const StadiumBorder()),
                                  onPressed: () async {
                                    await context.read<UsersProvider>().getPhonePosition(context);
                                  },
                                  child: Text(
                                    "Ma position",
                                    style: kBold16.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kMainGreen, shape: const StadiumBorder()),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await context.read<UsersProvider>().setAddress(
                                            context,
                                            _postalCodeController.text,
                                            _cityController.text,
                                          );
                                    }
                                  },
                                  child: Text("Valider", style: kBold16.copyWith(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
