import 'package:beer_app/WebSerive.dart';
import 'package:beer_app/beer_model.dart';
import 'package:flutter/material.dart';
import 'package:beer_app/auth.dart';
import 'package:beer_app/favourites_page.dart';
import 'package:beer_app/database_helper.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TheBeers> _theBeers = List<TheBeers>(); 
  ScrollController _scrollController = new ScrollController();
  List<String> _favourites = List<String>();
  var db;
  var connectivityResult;
  List _previousLiked;
  int i;

 void _populateTheBeers() {
    
    Webservice().load(TheBeers.all).then((beers) => {
      setState(() => {
        _theBeers.addAll(beers),
        // _theBeers = beers
      })
    } );
  }

  _buildItemsForListView(BuildContext context, int index){
      index == _theBeers.length?
      CircularProgressIndicator():
       Card(
        elevation: 10,
        margin: EdgeInsets.all(2),
          child: ListTile(
          leading: _theBeers[index].imageUrl !=null ? Image.network(_theBeers[index].imageUrl):null,
          title:  Text(_theBeers[index].name), 
          subtitle: Text(_theBeers[index].tagline, style: TextStyle(fontSize: 18)),
          trailing: GestureDetector(
            onTap: (){
              if (_favourites.contains(_theBeers[index].name)){
                setState(() {
                _favourites.remove(_theBeers[index].name);
                db.deleteBeer(_theBeers[index].name);
                });
              }else{
                setState(()  {
                _favourites.add(_theBeers[index].name);
                 db.saveBeer(new TheBeers(name:_theBeers[index].name,tagline: _theBeers[index].tagline ));
                });
              }
            },
            child: _favourites.contains(_theBeers[index].name) ? Icon(Icons.favorite):Icon(Icons.favorite_border)
            ),
        ),
      );
      
  }

  _getPrevious() async{
    connectivityResult = await (Connectivity().checkConnectivity());
    try{
       _previousLiked = await db.getAll();
      for (int i = 0; i < _previousLiked.length; i++) {
        TheBeers user = TheBeers.map(_previousLiked[i]);
    _favourites.add(user.name);
  // Toast.show("DD I", context);
  
    // print("Username: ${user.name }, User Id: ${user.tagline}");
    // print("Oneee"+_previousLiked[0]);
  }
  print("len"+_favourites.length.toString());  
  Toast.show("len"+_favourites.length.toString(), context);
 
    }catch(Exception){
      print("Nhi chala");
      // Toast.show("Nhi chala", context);
    }
  }

    @override
  void initState() {
    db = new DatabaseHelper();
    _getPrevious();
    _populateTheBeers(); 
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        Toast.show("Loading More Results", context);
        _populateTheBeers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Top Beers"),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
               Navigator.push(context, MaterialPageRoute(builder:(context)=>Favourites()));
            },
            child: Icon(Icons.favorite,color: Colors.black54,)),
          Padding(padding: EdgeInsetsDirectional.only(end: 16),)
        ],
      ),
      body: connectivityResult == ConnectivityResult.none ?Center( child: Text("No Internet Connection Detected. You can still view yours favourites by going to the Favourites Page.")) :
      ListView.builder(
        controller: _scrollController,
        itemCount: _theBeers.length+1,
        // itemBuilder: _buildItemsForListView,
        itemBuilder: (context, index) {
          if (index == _theBeers.length) {
            return CircularProgressIndicator();
          }
          return Card(
        elevation: 10,
        margin: EdgeInsets.all(2),
          child: ListTile(
          leading: _theBeers[index].imageUrl !=null ? Image.network(_theBeers[index].imageUrl):null,
          title:  Text(_theBeers[index].name), 
          subtitle: Text(_theBeers[index].tagline, style: TextStyle(fontSize: 18)),
          trailing: GestureDetector(
            onTap: (){
              if (_favourites.contains(_theBeers[index].name)){
                setState(() {
                _favourites.remove(_theBeers[index].name);
                db.deleteBeer(_theBeers[index].name);
                });
              }else{
                setState(()  {
                _favourites.add(_theBeers[index].name);
                 db.saveBeer(new TheBeers(name:_theBeers[index].name,tagline: _theBeers[index].tagline ));
                });
              }
            },
            child: _favourites.contains(_theBeers[index].name) ? Icon(Icons.favorite):Icon(Icons.favorite_border)
            ),
        ),
      );
        },
        )
    );
  }
}
