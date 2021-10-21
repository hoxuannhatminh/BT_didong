import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp5());
}
class MyApp5 extends StatelessWidget {
  const MyApp5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage5(),
    );
  }
}
class HomePage5 extends StatefulWidget {
  const HomePage5({Key? key}) : super(key: key);

  @override
  _HomePage5State createState() => _HomePage5State();
}

class _HomePage5State extends State<HomePage5> {
  late Future<List<Photo>> lsPhoto;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lsPhoto = Photo.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: lsPhoto,
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List<Photo> data = snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  var photo= data[index];
                  return Card(
                    elevation: 0,
                    child:ListTile(
                      leading: Image.network(photo.image),
                      title: Text(photo.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Nhập số lượng'),
                                          content: TextFormField(),
                                          actions: [
                                            TextButton(
                                                onPressed: () => Navigator.pop(context, 'OK'),
                                                child: Text('OK')),
                                            TextButton(
                                                onPressed: () => Navigator.pop(context, 'Close'),
                                                child: Text('Close')),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(Icons.add_shopping_cart)),

                          ],
                        )

                    ),
                  );
                });
          }
          else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
class ratting{
  final double rate;
  final int count;

  ratting(this.rate, this.count);
}
class Photo {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Map ratting;
  Photo(this.id, this.title, this.price, this.description, this.category, this.image, this.ratting);
  static Future<List<Photo>> fetchData() async {
    String url = "https://fakestoreapi.com/products";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = response.body;
      print(result);
      var jsonData = jsonDecode(result);
      List<Photo> lsPhoto = [];
      for (var item in jsonData) {
        print(item);
        var id = item['id'];
        var title = item["title"];
        var price = item['price'];
        var description = item['description'];
        var category = item['category'];
        var image = item['image'];
        var ratting = item['ratting'];
        Photo p = new Photo(id, title, price, description, category, image, ratting);
        lsPhoto.add(p);
      }
      return lsPhoto;
    } else {
      print(response.statusCode);
      throw Exception("Loi lay du lieu");
    }
  }
}
