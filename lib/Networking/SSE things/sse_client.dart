import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SSEClient {
  static http.Client _client = http.Client();
  static StreamController<SSEModel> _streamController = StreamController();

  ///def: Subscribes to SSE
  ///param:
  ///[url]->URl of the SSE api
  ///[header]->Map<String,String>, key value pair of the request header
  Stream<SSEModel> subscribeToSSE(
      {required String url, required Map<String, String> header}) {
    var lineRegex = RegExp(r'^([^:]*)(?::)?(?: )?(.*)?$');
    var currentSSEModel = SSEModel(data: '', id: '', event: '');
    // ignore: close_sinks
    _streamController = StreamController();
    print("--SUBSCRIBING TO SSE---");
    while (true) {
      try {
        _client = http.Client();
        var request = http.Request("GET", Uri.parse(url));

        ///Adding headers to the request
        header.forEach((key, value) {
          request.headers[key] = value;
        });

        Future<http.StreamedResponse> response = _client.send(request);

        ///Listening to the response as a stream
        response.asStream().listen((data) {
          ///Applying transforms and listening to it
          data.stream
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen(
                (dataLine) {
              if (dataLine.isEmpty) {
                ///This means that the complete event set has been read.
                ///We then add the event to the stream
                _streamController.add(currentSSEModel);
                currentSSEModel = SSEModel(data: '', id: '', event: '');
                return;
              }

              ///Get the match of each line through the regex
              Match match = lineRegex.firstMatch(dataLine)!;
              var field = match.group(1);
              if (field!.isEmpty) {
                return;
              }
              var value = '';
              if (field == 'data') {
                //If the field is data, we get the data through the substring
                value = dataLine.substring(
                  5,
                );
              } else {
                value = match.group(2) ?? '';
              }
              switch (field) {
                case 'event':
                  currentSSEModel.event = value;
                  break;
                case 'data':
                  currentSSEModel.data =
                  '${currentSSEModel.data ?? ''}$value\n';
                  break;
                case 'id':
                  currentSSEModel.id = value;
                  break;
                case 'retry':
                  break;
              }
            },
            onError: (e, s) {
              print('---ERROR---***');
              print(e);
              if (!_streamController.isClosed) {
                _streamController.addError(e, s);
              }
            },
          );
        }, onError: (e, s) {
          print('---ERROR---**');
          print(e);
          _streamController.addError(e, s);
        });
      } catch (e, s) {
        print('---ERROR---*');
        print(e);
        _streamController.addError(e, s);
      }

      Future.delayed(const Duration(seconds: 1), () {});
      return _streamController.stream;
    }
  }

  void unsubscribeFromSSE() {
    // close the stream
    _streamController.close();
    // close the http client
    _client.close();
  }
}

class SSEModel {
  //Id of the event
  String? id = '';
  //Event name
  String? event = '';
  //Event data
  String? data = '';
  SSEModel({required this.data, required this.id, required this.event});
  SSEModel.fromData(String data) {
    id = data.split("\n")[0].split('id:')[1];
    event = data.split("\n")[1].split('event:')[1];
    this.data = data.split("\n")[2].split('data:')[1];
  }
}