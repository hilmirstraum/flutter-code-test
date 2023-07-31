import 'dart:convert';

import 'package:code_test/Networking/SSE%20things/sse_client.dart';
import 'package:flutter/material.dart';

import '../../Models/Apiir data models/bikefit.dart';

class SSEListenerScreen extends StatefulWidget {
  const SSEListenerScreen({super.key});

  @override
  State<SSEListenerScreen> createState() => _SSEListenerScreenState();
}

class _SSEListenerScreenState extends State<SSEListenerScreen> {
  String bikefitId = "1eb74eca-bb08-41ef-9c62-7ca40126aabe";
  String url = "http://192.168.0.134:8080/v1/cyclist/listenForChanges/bikefit/";
  Bikefit? bikefit;

  final sseClient = SSEClient();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SSE Listener"),
      ),
      body: StreamBuilder<SSEModel>(
          stream: SSEClient().subscribeToSSE(url: "$url$bikefitId", header: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
            "Authorization": "Bearer 123abc"
          }),
          builder: (context, snapshot) {


            if (snapshot.connectionState == ConnectionState.waiting) {
              print("[!] WAITING");
              return Center(
                child: Column(
                  children: [
                    Text("Waiting"),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }

            // if (snapshot.connectionState == ConnectionState.done) {
            //   print("[!] DONE");
            //   return Center(
            //     child: Text("Done"),
            //   );
            // }

            // if (snapshot.connectionState == ConnectionState.active) {
            //   print("[!] ACTIVE");
            //   return Center(
            //     child: Text("Active"),
            //   );
            // }

            if (snapshot.hasError) {
              print("[!] ERROR");
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            if (snapshot.hasData && snapshot.data!.data != null){
              print("----");
              try {
                print("[!] SNAPSHOT: ${jsonDecode(snapshot.data!.data!)}");

              } catch (e) {
                print("[!] ERROR: $e");
              }
              print("----|||");

            try {
              bikefit = Bikefit.fromJson(
                  jsonDecode(snapshot.data!.data!));
            } catch (e) {
              print("[!] ERROR2: $e");
            }

            if (bikefit == null) {
              return Center(
                child: Text("Bikefit is null"),
              );
            }

              return Center(
                  child: Column(
                    children: [
                      Text("Bikefit name: ${bikefit?.name}"),
                      Text("Bikefit id: ${bikefit?.bid}"),
                      Text("Position: ${bikefit?.position}"),

                    ],
                  ));


            } else {
              return Center(
                child: Text("No data"),
              );
            }




          }),
    );
  }
}
