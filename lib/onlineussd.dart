import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:math';

class OnlineUssd extends StatefulWidget {
  const OnlineUssd({super.key});

  @override
  State<OnlineUssd> createState() => _OnlineUssdState();
}

class _OnlineUssdState extends State<OnlineUssd> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _selectOption = TextEditingController();
  var res;
  Random random = Random();
  int? randomNumber;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // title: const Text('Online Ussd'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Form(
            key: _form,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // start
                TextFormField(
                  controller: _phoneNumber,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 1)
                      return 'Enter phone number';
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        if (_form.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          // generate id
                          setState(() {
                            randomNumber = random.nextInt(100000);
                          });

                          final response = await http.get(
                            Uri.parse(
                                'https://mbankingtest.cbagroup.com/test_ussd/api/tz_ussd/request?MSISDN=${_phoneNumber.text}&SERVICE_CODE=*167%23&SESSION_ID=${randomNumber}&USSD_STRING='),
                          );
                          if (response.statusCode == 200) {
                            setState(() {
                              res = response.body
                                  .toString()
                                  .replaceAll('Response', '')
                                  .replaceAll("{", '')
                                  .replaceAll("}", '')
                                  .replaceAll("\"", '')
                                  .replaceAll('\\n', "\n")
                                  .replaceAll(":", '');
                            });
                            // print(res!['0']);
                          } else {
                            throw Exception('Failed to load album');
                          }
                        } else {
                          print('Enter');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 56,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                        ),
                        child: const Center(
                          child: Text(
                            'NEW SESSION',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // finish
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 20,
                ),
                res == null && isLoading != false
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : res == null
                        ? Text('')
                        : Text("$res"),
                const SizedBox(
                  height: 30,
                ),
                res != null
                    ?
                    // start
                    TextFormField(
                        controller: _selectOption,
                        decoration: InputDecoration(
                          hintText: '',
                          border: const OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              final response = await http.get(
                                Uri.parse(
                                    'https://mbankingtest.cbagroup.com/test_ussd/api/tz_ussd/request?MSISDN=${_phoneNumber.text}&SERVICE_CODE=*167%23&SESSION_ID=${randomNumber}&USSD_STRING=${_selectOption.text}'),
                              );
                              if (response.statusCode == 200) {
                                setState(() {
                                  res = response.body
                                      .toString()
                                      .replaceAll('Response', '')
                                      .replaceAll("{", '')
                                      .replaceAll("}", '')
                                      .replaceAll("\"", '')
                                      .replaceAll('\\n', "\n")
                                      .replaceAll(":", '');
                                });
                              } else {
                                throw Exception('Failed to load album');
                              }
                              _selectOption.text = "";
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: 56,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                              ),
                              child: const Center(
                                child: Text(
                                  'SEND',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    // finish

                    : const Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
