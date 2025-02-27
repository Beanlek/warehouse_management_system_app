// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:warehouse/van%20allotment/widget/expansion_panel.dart';

class FancyAppbarAnimation extends StatefulWidget {
  const FancyAppbarAnimation({super.key});
  @override
  _FancyAppbarAnimationState createState() => _FancyAppbarAnimationState();
}

class _FancyAppbarAnimationState extends State<FancyAppbarAnimation> {
  final ScrollController _scrollController = ScrollController();
  Color? appBarBackground;
  late double topPosition;
  @override
  void initState() {
    topPosition = -80;
    appBarBackground = Colors.transparent;
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  double _getOpacity() {
    double op = (topPosition + 80) / 80;
    return op > 1 || op < 0 ? 1 : op;
  }

  _onScroll() {
    if (_scrollController.offset > 50) {
      if (topPosition < 0) {
        setState(() {
          topPosition = -130 + _scrollController.offset;
          if (_scrollController.offset > 130) topPosition = 0;
        });
      }
    } else {
      if (topPosition > -80) {
        setState(() {
          topPosition--;
          if (_scrollController.offset <= 0) topPosition = -80;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 50),
                  height: 150,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const SizedBox(height: 70),
                      Row(
                        children: [
                          const Text(
                            "Van Allotment List",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                          const SizedBox(width: 20.0),
                          Image.asset(
                            'assets/van.png',
                            width: 70,
                            height: 70,
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // //i want to put it here the list
                // const SizedBox(height: 30.0),
                // Container(
                //   height: 300,
                //   color: Colors.orange,

                // ),
                // const SizedBox(height: 20.0),
                // Container(
                //   height: 300,
                //   color: Colors.red,
                // ),
                // const SizedBox(height: 30.0),
                // Container(
                //   height: 300,
                //   color: Colors.yellow,
                // ),
                // const SizedBox(height: 10.0),
                // Container(
                //   height: 300,
                //   color: Colors.pink,
                // ),
                // const SizedBox(height: 10.0),
                ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ExpansionPanelWidget(
                        index: index,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
              top: topPosition,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                padding:
                    const EdgeInsets.only(left: 50, top: 25.0, right: 20.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30.0)),
                  color: Colors.white.withOpacity(_getOpacity()),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  child: Semantics(
                    header: true,
                    child: const Text(
                      'Van Allotment List',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 80,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
