import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamproject/provider/User.dart';
import 'package:teamproject/style.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<bool> rentalStatus = [false, false, false];    // MacBook, LG gram, WebCam

  Future<String> getMacBookDuedate(String studentId) async {
    var result = await http.get(
        Uri.parse('http://10.0.2.2:8000/rental_records/devices/$studentId/now/')
    );
    String dueDate = '-';
    if (result.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(result.body);
      for (var data in responseData) {
        int deviceId = int.parse(data['device'].toString());
        if (deviceId <= 27) {
          dueDate = data['end_date'].toString().substring(0, 10);
          rentalStatus[0] = true;
        }
      }
    }
    return dueDate;
  }

  Future<String> getLgGramDuedate(String studentId) async {
    var result = await http.get(
        Uri.parse('http://10.0.2.2:8000/rental_records/devices/$studentId/now/')
    );
    String dueDate = '-';
    if (result.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(result.body);
      for (var data in responseData) {
        int deviceId = int.parse(data['device'].toString());
        if (27 < deviceId && deviceId <= 27 + 22) {
          dueDate = data['end_date'].toString().substring(0, 10);
          rentalStatus[1] = true;
        }
      }
    }
    return dueDate;
  }

  Future<String> getWebCamDuedate(String studentId) async {
    var result = await http.get(
        Uri.parse('http://10.0.2.2:8000/rental_records/devices/$studentId/now/')
    );
    String dueDate = '-';
    if (result.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(result.body);
      for (var data in responseData) {
        int deviceId = int.parse(data['device'].toString());
        if (deviceId > 27 + 22) {
          dueDate = data['end_date'].toString().substring(0, 10);
          rentalStatus[2] = true;
        }
      }
    }
    return dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: [
              const SizedBox(height: 70),
              const Text('My Page', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              Container(
                width: 320,
                height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(width: 2, color: AppColor.Blue)
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.Blue),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            context.read<UserProvider>().userName,
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                            textAlign: TextAlign.right
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Student ID',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.Blue),
                            textAlign: TextAlign.left
                          ),
                          Text(
                            context.read<UserProvider>().userStudentId,
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                            textAlign:TextAlign.right
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.Blue),
                              textAlign:TextAlign.left
                          ),
                          Text(
                              context.read<UserProvider>().userPhoneNumber,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                              textAlign: TextAlign.right
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Container(
                height: 1.0,
                width: 300.0,
                color: AppColor.Grey1,
              ),

              const SizedBox(height: 30),

              const Text('Rental Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              const SizedBox(height: 25),


              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    SizedBox(
                      width: 100,
                      child: Column(
                          children:[
                            const Text('MacBook', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.Blue)),
                            const SizedBox(height: 8),
                            Container(
                              height: 2.0,
                              width: 70.0,
                              color: AppColor.Blue,
                            ),
                            const SizedBox(height: 14),

                            rentalStatus[0]
                                ? const Icon(Icons.laptop_mac, color: AppColor.Blue4, size: 65)
                                : const Icon(Icons.close_rounded, color: AppColor.Grey1, size: 65),


                            FutureBuilder<String>(
                              future: getMacBookDuedate(context.read<UserProvider>().userStudentId),
                              builder: (context, snapshot) {

                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                  );
                                }
                                return const Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
                              },
                            ),



                          ]
                      ),
                    ),

                    SizedBox(
                      width: 100,
                      child: Column(
                          children:[
                            const Text('LG gram', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.Blue)),
                            const SizedBox(height: 8),
                            Container(
                              height: 2.0,
                              width: 70.0,
                              color: AppColor.Blue,
                            ),
                            const SizedBox(height: 14),

                            rentalStatus[1]
                              ? const Icon(Icons.laptop_windows, color: AppColor.Blue4, size: 65)
                              : const Icon(Icons.close_rounded, color: AppColor.Grey1, size: 65),


                            FutureBuilder<String>(
                              future: getLgGramDuedate(context.read<UserProvider>().userStudentId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                  );
                                }
                                return const Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
                              },
                            ),

                          ]
                      ),
                    ),


                    SizedBox(
                      width: 100,
                      child: Column(
                          children:[
                            const Text('WebCam', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.Blue)),
                            const SizedBox(height: 8),
                            Container(
                              height: 2.0,
                              width: 70.0,
                              color: AppColor.Blue,
                            ),
                            const SizedBox(height: 14),

                            rentalStatus[2]
                                ? const Icon(Icons.photo_camera, color: AppColor.Blue4, size: 65)
                                : const Icon(Icons.close_rounded, color: AppColor.Grey1, size: 65),

                            FutureBuilder<String>(
                              future: getWebCamDuedate(context.read<UserProvider>().userStudentId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                  );
                                }
                                return const Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
                              },
                            ),

                          ]
                      ),
                    ),
                  ]
              ),

              const SizedBox(height: 25),

              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColor.Blue),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  fixedSize: MaterialStateProperty.all<Size>(const Size(90, 30)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 14),
                ),
              ),

            ]
        ),
      ),
    );
  }
}