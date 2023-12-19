import 'package:flutter/material.dart';
import 'package:incluye_me/views/login/student_password_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

// -------------------------------------------------------------------

class StudentLoginView extends StatefulWidget {
  const StudentLoginView({Key? key}) : super(key: key);

  @override
  _StudentLoginViewState createState() => _StudentLoginViewState();
}

class _StudentLoginViewState extends State<StudentLoginView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes')),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          double buttonPadding = sizingInformation.isMobile ? 5.0 : 20.0;
          double childAspectRatio = sizingInformation.isMobile ? 1.0 : 1.59;

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int pageIndex) {
                    return GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(
                        sizingInformation.isMobile ? 40.0 : 50.0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: sizingInformation.isMobile ? 2 : 3,
                        mainAxisSpacing:
                            sizingInformation.isMobile ? 25.0 : 25.0,
                        crossAxisSpacing:
                            sizingInformation.isMobile ? 25.0 : 25.0,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginWithSymbols(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(width: 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: buttonPadding,
                              vertical: 20,
                            ),
                          ),
                          child: Image.asset('assets/usuario_sin_foto.png'),
                        );
                      },
                      itemCount: 6,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: sizingInformation.isMobile ? 20.0 : 50.0,
                  left: sizingInformation.isMobile ? 20.0 : 80.0,
                  right: sizingInformation.isMobile ? 20.0 : 80.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
