import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AthleteSchemesPage extends StatefulWidget {
  @override
  _AthleteSchemesPageState createState() => _AthleteSchemesPageState();
}

class _AthleteSchemesPageState extends State<AthleteSchemesPage> {
  List<Map<String, String>> schemes = [
    {
      "name": "Khelo India Scheme",
      "description":
          "Financial support of ₹5 lakh per year for 8 years to nurture young athletes.",
      "details":
          "The Khelo India Scheme aims to build a strong sports culture in India. It provides financial support of ₹5 lakh per year for 8 years to talented athletes, organizes annual Khelo India Games, and upgrades sports infrastructure.",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSod6cg8v8o4gd1k65Ggw2Scf9qu1jPZgxTyg&s",
      "link": "https://yas.gov.in/sports/khelo-india"
    },
    {
      "name": "TOPS (Target Olympic Podium Scheme)",
      "description":
          "Provides elite athletes with world-class training, equipment, and international exposure.",
      "details":
          "TOPS provides financial assistance, coaching, and medical support to athletes preparing for the Olympics and other international competitions. It covers training abroad, coaching fees, and high-performance tracking.",
      "image":
          "https://sportsauthorityofindia.nic.in/sai/assets/frontend/images/TOPS_Intro.jpg",
      "link": "https://www.sportsauthorityofindia.nic.in/index1.asp?ls_id=1191"
    },
    {
      "name": "Pension Scheme for Meritorious Sportspersons",
      "description":
          "Provides monthly pension for retired athletes who have won medals at major events.",
      "details":
          "This scheme offers lifelong financial support to retired athletes who have represented India in the Olympics, Asian Games, and Commonwealth Games. The pension varies from ₹12,000 to ₹20,000 per month based on achievements.",
      "image":
          "https://sportsauthorityofindia.nic.in/sai/assets/frontend/images/TOPS_Intro.jpg",
      "link": "https://yas.gov.in/sports/pension-scheme"
    },
  ];

  List<Map<String, String>> filteredSchemes = [];

  @override
  void initState() {
    super.initState();
    filteredSchemes = schemes;
  }

  void filterSchemes(String query) {
    setState(() {
      filteredSchemes = schemes
          .where((scheme) =>
              scheme["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showSchemeDetails(Map<String, String> scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(scheme["image"]!, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              SizedBox(height: 10),
              Text(
                scheme["name"]!,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                scheme["details"]!,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse(scheme["link"]!)),
                icon: Icon(Icons.open_in_new),
                label: Text("Read More"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Athlete Schemes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              onChanged: filterSchemes,
              decoration: InputDecoration(
                labelText: "Search Schemes",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchemes.length,
                itemBuilder: (context, index) {
                  final scheme = filteredSchemes[index];
                  return GestureDetector(
                    onTap: () => showSchemeDetails(scheme),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              scheme["image"]!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scheme["name"]!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  scheme["description"]!,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => showSchemeDetails(scheme),
                                    style: ButtonStyle(backgroundColor:  WidgetStateProperty.all(Colors.blueAccent)),
                                    child: Text("More Details",style:TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
