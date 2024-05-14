// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../HomeScreen.dart';
import '../Logic.dart';



class MonoalphabeticCipherAlgorithmScreen extends StatefulWidget {
  const MonoalphabeticCipherAlgorithmScreen({super.key});

  @override
  State<MonoalphabeticCipherAlgorithmScreen> createState() => _MonoalphabeticCipherAlgorithmScreenState();
}

class _MonoalphabeticCipherAlgorithmScreenState extends State<MonoalphabeticCipherAlgorithmScreen> {
  var cipher = MonoalphabeticCipher();
  GlobalKey <FormState> formKey= GlobalKey();
  String? controller;// on words متغير لتخزين النص  المدخل من المستخدم
  bool pressed = false;
  bool copy = false;
  String? text;
  var regex = RegExp(r'^[a-zA-Z ]');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          title: Text(
            "تعلم",
            style: TextStyle(color: Colors.indigo.shade600),


          ),
          actions: [IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }, icon: Icon(Icons.home))],
          elevation: 2,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Form(
          key:formKey ,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Image.asset('images/logo.png'),
                  backgroundColor: Colors.indigo,
                  radius: 90,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (data){
                      if (data == null || data.isEmpty) {
                        return 'Please enter some text.';
                      }
            
            
                      if (!regex.hasMatch(data)) {
                        return 'Please enter words only. Letters, spaces, and apostrophes are allowed.';
                      }
                      return null;
                    },
                    keyboardType:TextInputType.text,
                    onChanged: (data) {
                      setState(() {
                        controller = data;
                        pressed=false;
                        if(formKey.currentState!.validate()){}
                        // algorithm=algorithm;
            
                      });
                    },
                    decoration:  InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
            
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        hintText: "Enter words"
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){ setState(() {
                          pressed = true;
                          text=cipher.encrypt(controller!);
                          // تقسيم النص عند الضغط
                        });
                        }},
                      child: const Text('Encrypt'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){  setState(() {
                          pressed = true;
                          text=cipher.decrypt(controller!);
                          // تقسيم النص عند الضغط
                        });
                        }},
                      child: const Text('Decrypt'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                if (pressed)
                  Column(
                    children: [
                      if(copy)Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            "$text",
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: "$text"));
            
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
            
                          // نسخ النص عند الضغط
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Text(
                                  "$text",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            const Positioned(
            
                              top: 14,
                              right:5,
                              height: double.minPositive,
            
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo,
                                child: Icon(Icons.copy),
                              ),
                            ),
            
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
