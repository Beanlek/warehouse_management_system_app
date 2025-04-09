// ignore_for_file: file_names, prefer_const_constructors, must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/warehouse_stock_take/layout/inventorylist.dart';

//this is dialog that will showned in dialog before proceed warehouse stock take
class DialogAllow extends StatelessWidget {
  final String siteId;
  final String warehouseName;

  const DialogAllow(
      {super.key, required this.siteId, required this.warehouseName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Warning",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Please ensure that to complete the entire process, any incomplete steps will not be saved.",
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InventoryList(
                            id: siteId,
                            warehouseName: warehouseName,
                          );
                        },
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogDisallow extends StatelessWidget {
  const DialogDisallow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "There are pending allotments that are not in the 'packed' status.The Warehouse Stock Take is not permitted for Site ID",
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Okay",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogConfirmation extends StatelessWidget {
  DialogConfirmation({
    super.key,
    this.toHome = false,
  });

  bool toHome;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('All of your progress will NOT be saved.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text('Are you sure you want to leave this page?',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    
                    toHome ?
                      Navigator.of(context).pop() : 
                      null;
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorMerah,
                  ),
                  child: const Text(
                    "Leave",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class DialogLogOutConfirmation extends StatelessWidget {
  const DialogLogOutConfirmation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Logging Out',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 24.0),
          Text(
            'Are you sure you want to log out?',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorMerah,
                  ),
                  child: const Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogStockMovement extends StatelessWidget {
  const DialogStockMovement({
    super.key,
    this.routes,
    this.counts,
    this.title
  });

  final List<Map<String, Widget>>? routes;
  final List<Map<String, int>>? counts;
  final String? title;

  Widget linearTile(String tileImage, String title, int count, void Function() navigateToPage,) {

    return SizedBox(
      height: 150,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: navigateToPage,

          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(24.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    biruImran,
                    colorFirst
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
                child:

                // Text('Hello', style: TextStyle(color: white),)
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    SizedBox( width: 200, height: 100, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Hello', style: TextStyle(color: white),)
                        Expanded(
                          child: SizedBox(
                            child: Image.asset(
                              tileImage,
                              color: Colors.white,
                              // width: 110,
                              // height: 110,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              count < 1000 ?
                              count < 0 ?
                              '' :
                              '${count}' :
                              NumberFormat.compact().format(count),
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                    
                    // SizedBox(height: 35),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
                        child: SizedBox(
                          child: AutoSizeText(
                            title.capitalizeCamelCase(),
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                            
                            wrapWords: false,
                            maxLines: 2,
                            minFontSize: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        content: SizedBox( width: 2000, height: (routes!.length + 1) * 135, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      
            Text('Select ${title} Movement',
              style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: biruImran,
                    fontSize: 22.0,
                  ),
            ),
      
            SizedBox(height: 24.0),
      
            Expanded( child: Column( mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded( child: ListView.builder(
                  itemCount: routes!.length,
                  itemBuilder: (context, index) =>
                  
                    linearTile(
                      'assets/homepage/icon_${routes![index].keys.toList()[0]}.png',
                      routes![index].keys.toList()[0],
                      counts![index].values.toList()[0],
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => routes![index].values.toList()[0]
                        ));
                        
                      },
                    )
                  
                  ))
              ],
            ))
          ],
        ),
      )),
    );
  }
}
class DialogDeleteConfirmation extends StatelessWidget {
  const DialogDeleteConfirmation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Deleting image.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text('Are you sure you want to delete this image?',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorMerah,
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}