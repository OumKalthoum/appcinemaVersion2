import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'GlobalVariables.dart';
import 'dart:convert';
import 'cinema.page.dart';

class CityList extends StatefulWidget {
  @override
 _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
Color mainColor = const Color(0xff3C3261);
 List<dynamic>listVilles;
  @override
  Widget build(BuildContext context) {
      return new Scaffold(
    backgroundColor: Colors.white,
    appBar: new AppBar(
      elevation: 0.3,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: new Icon(
         Icons.home,
        color: mainColor,
      ),
      title: new Text(
        'CINEMA',
        style: new TextStyle(color: mainColor,fontFamily: 'Arvo',fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        new Icon(
          Icons.local_movies,
          color: mainColor,
        )
      ],
      
    ),
    body: new Column(
      
      children: <Widget>[

           Center(
             child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Icon(Icons.location_on, size: 40,color: mainColor,),    
          ),),
            new Text("Choose Your City"),
      new Expanded(
        child: this.listVilles==null?CircularProgressIndicator():
            ListView.builder(
              itemCount: (this.listVilles==null)?0:this.listVilles.length,
                itemBuilder:(context,index){
                    return  Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Card(
	
      shape: RoundedRectangleBorder(

	
        borderRadius: BorderRadius.circular(20.0,),
        
	
      ),
	
      color: Colors.purple[50] ,
	
      elevation: 10,
	
      child: Column(
	
        mainAxisSize: MainAxisSize.min,
	
        children: <Widget>[
          
          ListTile(
	
           leading:Icon(Icons.location_city,size:70,color: mainColor,),
	          title: Text(this.listVilles[index]['name'],
                              style: TextStyle(color: mainColor,fontSize: 19,fontWeight: FontWeight.normal),),
  
	
          ),
	
          ButtonTheme.bar(
	
            child: ButtonBar(
	
              children: <Widget>[
	
                FlatButton(
	
                  child:Icon(Icons.navigate_next , size: 30,color: mainColor,),
	
                  onPressed: () {
                       Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context)=> new CinemaPage(listVilles[index])
                                  ));

                  },
	
                ),
	
              ],
	
            ),
	
          ),
	
        ],
	
      ),
	
    ),
                    );
                }
            )
      ),
      ],
    )
);
}
@override
  void initState() {
    super.initState();
    loadVilles();
  }

  void loadVilles() {
    //String url="http://192.168.1.14:8080/villes";
    String url=GlobalData.host+"/villes";
    http.get(url).then((resp){
      setState(() {
        this.listVilles=json.decode(resp.body)['_embedded']['villes'];
      });
    }).catchError((err){
      print(err);
    });
  }
}