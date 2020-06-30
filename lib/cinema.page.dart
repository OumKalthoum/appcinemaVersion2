import 'package:appcinema2020/salles.page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
class CinemaPage extends StatefulWidget {
  dynamic ville;
  CinemaPage(this.ville);
  @override
  _CinemaPageState createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  List<dynamic> listCinemas;
  Color mainColor = const Color(0xff3C3261);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    backgroundColor: Colors.white,
    appBar: new AppBar(
      elevation: 0.3,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back,size: 24.0,color: mainColor,), onPressed: (){
           Navigator.pop(context);
             }),
      title: new Text(
        ' ${widget.ville['name']} Cinemas',
        style: new TextStyle(color: mainColor,fontFamily: 'Arvo',fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        new Icon(
          Icons.local_movies,
          color: mainColor,
        )
      ],
      
    ),
    body: Padding(
      
      
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: (this.listCinemas==null)?CircularProgressIndicator():
          ListView.builder(
            itemCount: this.listCinemas==null?0:this.listCinemas.length,
              itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.purple[50],
  child: Padding(
      
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
    
      title: Text(this.listCinemas[index]['name'],style: TextStyle(color: mainColor,fontSize: 18,fontWeight: FontWeight.normal),),
      leading: Icon(Icons.movie_filter, color:mainColor,),
      onTap: () {
         Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context)=>new SallesPage(this.listCinemas[index])

                              ));
      },
    ),
  ),
),
              );
              }),
        ),
    ),
);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCinema();
  }

  void loadCinema() {
    String url=this.widget.ville['_links']['cinemas']['href'];
    http.get(url).then((resp){
      setState(() {
        this.listCinemas=json.decode(resp.body)['_embedded']['cinemas'];
      });

    }).catchError((err){
      print(err);
    });
  }
}
