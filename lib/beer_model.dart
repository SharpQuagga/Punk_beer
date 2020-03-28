import 'dart:convert';

import 'WebSerive.dart';
int _page = 1;
class TheBeers {
  
  // int id;
  String name; 
  String tagline; 
  String imageUrl; 
  int _did;

  TheBeers({ this.name, this.tagline, this.imageUrl});

  factory TheBeers.fromJson(Map<String,dynamic> json) {
    return TheBeers(
      // id: json['id'],
      name: json['name'], 
      tagline: json['tagline'], 
      imageUrl: json['image_url']
    );
  }

  TheBeers.map(dynamic obj){
    this.name = obj['name'];
    this.tagline = obj['tagline'];
    this._did= obj['id'];
  }

    Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map["name"] = name;
    map["tagline"] = tagline;
    return map;
  }

    TheBeers.fromMap(Map<String, dynamic> map){
    this.name = map["name"];
    this.tagline = map["tagline"];
    this._did = map["id"];
  }



static Resource<List<TheBeers>> get all {
    String urll = 'https://api.punkapi.com/v2/beers?page=${_page.toString()}&per_page=60';
    _page += 1;

    return Resource(
      url: urll,
      parse: (response) {
        final result = json.decode(response.body); 
        print("result");
        Iterable list = result;
        print("listtttt");
        return list.map((model) => TheBeers.fromJson(model)).toList();
      }
    );

  }


}