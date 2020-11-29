import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chatbot",
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xff121212),
        scaffoldBackgroundColor: Color(0xff28293d)
      ),
//        visualDensity: VisualDensity.adaptivePlatformDensity,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title:"Chatbot"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
void response(query) async{
  AuthGoogle authGoogle= await AuthGoogle(
    fileJson: "assets/botfile.json"
  ).build();
  Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
  AIResponse aiResponse = await dialogflow.detectIntent(query);
  setState(() {
    messages.insert(0, {
      "data": 0,
      "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
    });
  });
  print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
}



final messageController = TextEditingController();
List<Map> messages = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chatbot'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  "Today, ${DateFormat("h:mm").format(DateTime.now())}",
                  style: TextStyle(
                    fontSize: 18,

                  ),
                  ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) => chat(
                  messages[index]["message"].toString(),
                  messages[index]["data"]
                  )),
            ),
            Divider(
              height: 5,
              color: Colors.white10,
            ),
            Container(
              child: ListTile(
                title: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white12,
                  ),
                  padding: EdgeInsets.only(left: 5),
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Enter Text Here...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    onChanged: (value){},
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.send,
                    color: Color(0xffbb86fc),
                    size: 35,
                  ),
                  onPressed: () {
                    if (messageController.text.isEmpty) {
                      print("Empty Message");
                    }
                    else {
                      setState(() {
                        messages.insert(0, {"data": 1, "message": messageController.text});
                      });
                      response(messageController.text);
                      messageController.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if(!currentFocus.hasPrimaryFocus){
                      currentFocus.unfocus();
                      }
                    }
                ),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
  Widget chat(String message, int data){
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: data==1 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        data == 0 ? Container(
          height: 45,
          width: 45,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/bot.jpg"),
          ),

        ): Container(),

  Padding(
  padding: EdgeInsets.only(left: 1, top: 10, right:1 ,bottom: 10),
    child: Bubble(
    radius: Radius.circular(15),
    color: data == 0 ? Color(0xff03dac6) : Color(0xff84c0f1),
    elevation: 0,
    child: Padding(
    padding: EdgeInsets.all(2),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
    width: 5,
    ),
    Flexible(
    child: Container(
    constraints: BoxConstraints(maxWidth: 200),
    child: Text(message,
    style: TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold),
    ),
    ))
    ],
    ),
    )),
  ),
    data == 1 ? Container(
    height: 45,
    width: 45,
    child: CircleAvatar(
    backgroundImage: AssetImage("assets/you.jpg"),
    ),
    ): Container(),
      ],
    ),
  );
  }
  }
