import 'package:appcinema2020/GlobalVariables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
class SallesPage extends StatefulWidget {
  dynamic cinema;
  SallesPage(this.cinema);
 
  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  List<dynamic> listSalles;
   List<int> selectedTickets = new List<int>();
  Color mainColor = const Color(0xff3C3261);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
      elevation: 0.3,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading:new IconButton(
        icon: new Icon(Icons.arrow_back,size: 24.0,color: mainColor,), onPressed: (){
           Navigator.pop(context);
             }),
      title: new Text(
        ' ${widget.cinema['name']} rooms',
        style: new TextStyle(color: mainColor,fontFamily: 'Arvo',fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        new Icon(
          Icons.local_movies,
          color: mainColor,
        )
      ],
      
    ),
      body: Center(
        child: (this.listSalles==null)?CircularProgressIndicator():
        ListView.builder(
          itemCount: this.listSalles==null?0:this.listSalles.length,
            itemBuilder: (context,index){
            return Card(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color:Colors.purple[50] ,
                        child: Text(this.listSalles[index]['name'],style: TextStyle(color: mainColor),),
                        onPressed: (){
                          loadProjections(this.listSalles[index]);
                          },
                      ),
                    ),
                  ),
                  if(this.listSalles[index]['projections']!=null)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      children: <Widget>[
                        Image.network(GlobalData.host+"/imageFilm/${this.listSalles[index]['currentProjection']['film']['id']}",width: 150,),
                        Column(
                          children: <Widget>[
                            ...(this.listSalles[index]['projections'] as List<dynamic>).map((projection){
                                 return RaisedButton(
                                   color: (this.listSalles[index]['currentProjection']['id']==projection['id']?Colors.purple[200]:mainColor),
                                   child: Text("${projection['seance']['heureDebut']}(${projection['film']['duree']}, Prix=${projection['prix']})",style: TextStyle(color: Colors.white,fontSize: 12),),
                                   onPressed: (){
                                     loadTickets(projection,this.listSalles[index]);

                                   },
                                 );
                            })
                          ],
                        )
                      ],
                    ),
                  ),
                  if(this.listSalles[index]['currentProjection']!=null &&
                      this.listSalles[index]['currentProjection']['listTickets']!=null &&
                      this.listSalles[index]['currentProjection']['listTickets'].length>0)
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Number of places available: ${this.listSalles[index]['currentProjection']['nombrePlacesDisponibles']}")
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Your Name'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Payment Code'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Number of tickets'),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            color: mainColor,
                            child: Text("Reserve places",style: TextStyle(color: Colors.white),),
                            onPressed: (){

                            },
                          ),
                        ),
                        Wrap(
                          children: <Widget>[
                            ...this.listSalles[index]['currentProjection']['listTickets'].map((ticket){
                              if(ticket['reserve']==false)
                                return Container(
                                  width: 50,
                                  padding: EdgeInsets.all(1),
                                  child: RaisedButton(
                                    color: ticket['reserve']!=null && ticket['reserve']==true?Colors.purple[50]:Colors.purple[300],
                                    child: Text("${ticket['place']['numero']}",style: TextStyle(color: Colors.white,fontSize: 12),),
                                    onPressed: (){
                                   


                                    },
                                  ),
                                );
                              else return Container();
                            })
                          ],
                        )

                      ],
                    ),

                ],
              ),
            );
            }),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalles();
  }

  void loadSalles() {
    String url=this.widget.cinema['_links']['salles']['href'];
    http.get(url).then((resp){
      setState(() {
        this.listSalles=json.decode(resp.body)['_embedded']['salles'];
      });

    }).catchError((err){
      print(err);
    });
  }

  void loadProjections(salle) {
   // String url1=GlobalData.host+"/salles/${salle['id']}/projections?projection=p1";
    String url2=salle['_links']['projections']['href'].toString()
        .replaceAll("{?projection}", "?projection=p1");
 //   print(url1);
    print(url2);
    http.get(url2).then((resp){
      setState(() {
        salle['projections']=json.decode(resp.body)['_embedded']['projections'];
        salle['currentProjection']=salle['projections'][0];
        salle['currentProjection']['listTickets']=[];
      });

    }).catchError((err){
      print(err);
    });
  }

  void loadTickets(projection,salle) {
    String url=projection['_links']['tickets']['href'].toString()
        .replaceAll("{?projection}", "?projection=ticketProj");
    print(url);
    http.get(url).then((resp){
      setState(() {
        projection['listTickets']=json.decode(resp.body)['_embedded']['tickets'];
        salle['currentProjection']=projection;
        projection['nombrePlacesDisponibles']=nombrePlaceDisponibles(projection);

      });

    }).catchError((err){
      print(err);
    });
  }
  nombrePlaceDisponibles(projection){
    int nombre=0;
    for(int i=0;i<projection['tickets'].length;i++){
      if(projection['tickets'][i]['reserve']==false) ++nombre;
    }
    return nombre;
  }
  


}