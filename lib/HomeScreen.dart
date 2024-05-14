import 'package:flutter/material.dart';
import 'package:fsc/learnScreen.dart';

import 'widgets/CustomDashboard.dart';
int numberOfAlgorithm=0;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("تعلم",style: TextStyle(color: Colors.indigo),),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsetsDirectional.only(top: 20),
          decoration: BoxDecoration(color: Colors.deepPurple.shade900),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding:
                const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 15),
            children: [
              CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));
                   setState(() {
                     numberOfAlgorithm=0;
                   });
                },
                title: "Caesar cipher",
                subTitle: "symmetric",
                image: "images/1.jpg",
              ),
              CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));

                  setState(() {
                    numberOfAlgorithm=1;
                  });
                },
                title: "Monoalphabetic",
                subTitle: "symmetric",
                image: "images/3.jpg",
              ),
              CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));

                  setState(() {
                    numberOfAlgorithm=2;
                  });
                },
                title: "Affine Cipher",
                subTitle: "symmetric",
                image: "images/2.jpg",
              ),
              CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));

                  setState(() {
                    numberOfAlgorithm=3;
                  });
                },
                title: "Playfair Cipher",
                subTitle: "symmetric",
                image: "images/6.jpg",
              ),CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));

                  setState(() {
                    numberOfAlgorithm=4;
                  });
                },
                title: "SHA1",
                subTitle: "Hash",
                image: "images/5.jpg",
              ),CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));

                  setState(() {
                    numberOfAlgorithm=5;
                  });
                },
                title: "DES",
                subTitle: "Block",
                image: "images/7.jpg",
              ),
              CustomDashboard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnScreen(),));

                  setState(() {
                    numberOfAlgorithm=6;
                  });
                },
                title: "RSA",
                subTitle: "Symmetric",
                image: "images/4.jpg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
