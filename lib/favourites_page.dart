import 'package:beer_app/beer_model.dart';
import 'package:beer_app/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Favourites extends StatefulWidget {
  @override
   _FavouritesState createState() => _FavouritesState();

    // final List<String> fav;
    // Favourites({this.fav});

}
class _FavouritesState extends State<Favourites> {
  var db;
  List _fav = new List();

  users() async {
    _fav = await db.getAll();
    setState(() {
    print("Fav pages"+_fav.length.toString());
    // Toast.show("Fav pages"+_fav.length.toString(), context);
    });
  } 

  @override
  void initState(){
    db = new DatabaseHelper();
    users();
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text("Favourites Page"),
       centerTitle: true,
     ),
     body: _fav.length == 0 ? Center(child: Text("No Favourites Marked")) :
     ListView.builder(
       itemCount: _fav.length,
       itemBuilder: (BuildContext context, int index) {
         return Card(
           elevation: 10,
           color: Colors.orange[400],
                    child: ListTile(
              leading: new CircleAvatar(
              child:  Text("${TheBeers.fromMap(_fav[index]).name.substring(0, 1)}"),
            ),
             title: Text("${TheBeers.fromMap(_fav[index]).name}"),
             subtitle: Text("${TheBeers.fromMap(_fav[index]).tagline}"),
           ),
         );
       },
     )
    );
  }
} 