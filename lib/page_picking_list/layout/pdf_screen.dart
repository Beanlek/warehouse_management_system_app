// ignore_for_file: prefer_const_constructors_in_immutables, annotate_overrides, library_private_types_in_public_api, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:warehouse/utils/utils.dart';

class PDFScreen extends StatefulWidget {
  const PDFScreen({super.key,
      required this.path,
      required this.fileName,
  });

  final String path;
  final String fileName;

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          title: AutoSizeText(
            widget.fileName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              debugPrint(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              debugPrint('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              debugPrint('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              debugPrint('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData) {
      //       return FloatingActionButton.extended(
      //         label: Text("Go to ${pages! ~/ 2}"),
      //         onPressed: () async {
      //           await snapshot.data!.setPage(pages! ~/ 2);
      //         },
      //       );
      //     }

      //     return Container();
      //   },
      // ),
    ));
  }
}