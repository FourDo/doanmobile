import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'loginpage.dart';

class Introlpage extends StatefulWidget {
  const Introlpage({super.key});

  @override
  State<Introlpage> createState() => _IntrolpageState();
}

class _IntrolpageState extends State<Introlpage> {
  int currentIndex = 0;

  List<dynamic> images = <dynamic>[
    "hinh1.png",
    "hinh2.png",
    "hinh3.png"
  ];

  List<String> titles =[
    "Life is short and the world is wide",
    "It’s a big world out there go explore",
    "People don’t take trips, trips take people"
  ];

  List<String> descriptions = [
    "At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world",
    "To get the best of your adventure you just need to leave and go where you like. we are waiting for you",
    "To get the best of your adventure you just need to leave and go where you like. we are waiting for you"
  ];

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (BuildContext _, int index) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.55,
                      child: Image.asset("image/" + images[index], fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 42, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          titles[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          descriptions[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,  // PageController
                  count: images.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 12,
                    activeDotColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex == images.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => loginpage()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      currentIndex == images.length - 1 ? "Get Started" : "Next",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}