import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'camera.dart';
import 'dart:io';
import 'package:imagepicker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dary';
import 'package:async/async.dart';
import 'dart:convert';


Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}

class Main extends StatefulWidget
{
  _MainState createState() => _MainState();
}

class _MainState extends State<Main>
{
  File _image;
  String prediction = "";
  double _imagewidth;
  double _imageheight;

  selectfromImagepicker() async
  {
    var _image = await ImagePicker.pickImage(sourec : ImageSource.gallery);

    if(_image == null) return;

    print("Image has been selected.")

    predict(_image)
  }

  void predict(File image) async{
    await uploadandpredict(image);

    FileImage(image)
    .resolve(Imageonfiguration())
    .addListener((ImageStreamListener((ImageInfo info, bool _)
    {
      setSate((){
        _imagewidth = info.image.width.toDouble();
        _imageheight = info.image.height.toDouble();

      });
    })));

    setState(() {
      _image = image;
    });

  }

  void uploadandpredict(File imagefile) async
  {
    var stream = new http.ByteStream(DelegateingStream.typed(imagefile.openRead()));

    var length = await imagefile.length()

    var uri = Uri.parse(("http://192.168.43.83:5000/predict"));

    var request = http.MultipartRequest("POST" , uri);

    var multipartFile = http.MultipartFile('image' , stream, length, filename: basename(imagefile.path));

    request.files.add(multipartFile);

    var res = await request.send();

    var response = await http.Response.fromStream(res);

    print(response.body);

  }

  Widget build(BuildContext contex)
  {
    Size size = MediaQuery.of(contex).size();

    List<Widget> stackchildren = [];

    stackchildren.add(Positioned( 
      top : 0.0,
      left : 0.0,
      width : size.width,
      child : _image == null? Text("no image selected" : Image.file(_image),
      ));
      
      return Scaffold(
        appBar : AppBar(
          title : Text("Image Classifier"),
        ),
        body: Stack(children : stackchildren),
        floatingActionButton : FloatingActionButton(
          child : Icon(Icons.image),
          tooltip : "Pick from image gallary",
          onPressed : selectfromImagepicker,
        ),
      );
    
  }

}
