import 'package:dod/return_functions/position.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class Location extends StatefulWidget {
   Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List<String> filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = controller.text.toLowerCase();
    if (query.length >= 4) {
      setState(() {
        filteredPlaces = places
            .where((place) => place.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        filteredPlaces.clear();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text("Search Location",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Center(
            child: Container(
              width: w - 10,
              height: 45,
              decoration: BoxDecoration(
                color: Global.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.location_on),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      onChanged: (String str){
                        _onSearchChanged();
                      },
                      onSaved: (value){
                        _onSearchChanged();
                      },
                      decoration: InputDecoration(
                        hintText: "Enter 4 letters to start searching",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPlaces[index]),
                  onTap: () {
                    Navigator.pop(context,filteredPlaces[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (_)=>Position()));
          },
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_location,color: Colors.green,),
                SizedBox(width: 7,),
                Text("Locate on the Map",style: TextStyle(fontWeight: FontWeight.w800),)
              ],
            ),
          ),
        )
      ],
    );
  }

  List<String> places = [
    "Ahmedabad Junction Railway Station, Kalupur Railway Station Road, Sakar Bazzar, Kalupur, Ahmedabad, Gujarat 380002" ,  // main railway station :contentReference[oaicite:0]{index=0}
    "Divisional Railway Manager's Office, Amdupura, Naroda Road, Ahmedabad, Gujarat 382345" ,  // Western Railway administrative office :contentReference[oaicite:1]{index=1}
    "Gheekanta Metro Station, Old City, Gheekanta, Bhadra, Ahmedabad, Gujarat 380001" ,  // metro station on Blue Line :contentReference[oaicite:2]{index=2}
    "Amraiwadi Metro Station, Rabari Colony, Amraiwadi, Ahmedabad, Gujarat 380026" ,  // elevated metro station, Blue Line :contentReference[oaicite:3]{index=3}
    "Old High Court Metro Station, Shreyas Colony, Navrangpura, Ahmedabad, Gujarat 380009" ,  // interchange station between Blue & Red Lines :contentReference[oaicite:4]{index=4}
    "Sabarmati Ashram, Gandhi Smarak Sangrahalaya, Sabarmati, Ahmedabad, Gujarat 380005" ,  // historic ashram of Mahatma Gandhi :contentReference[oaicite:5]{index=5}
    "Kankaria Lake, Kankaria, Ahmedabad, Gujarat" ,  // large lake + amusement areas :contentReference[oaicite:6]{index=6}
    "Jama Masjid, Manek Chowk, Old Ahmedabad, Gujarat 380001" ,  // major mosque in walled city :contentReference[oaicite:7]{index=7}
    "Sidi Saiyyed Mosque, Shah Jali, Shahibaug, Ahmedabad, Gujarat" ,  // known for its stone lattice (jali) work :contentReference[oaicite:8]{index=8}
    "Swaminarayan Temple, Kalupur, Ahmedabad, Gujarat" ,  // Kalupur Swaminarayan Temple :contentReference[oaicite:9]{index=9}
    "Bhadra Fort, Bhadra, Ahmedabad, Gujarat" ,  // historic fort in old city :contentReference[oaicite:10]{index=10}
    "Teen Darwaza, Bhadra, Ahmedabad, Gujarat" ,  // historic gate in old city :contentReference[oaicite:11]{index=11}
    "Ashram Road, Ahmedabad, Gujarat" ,  // major road with multiple public offices (RBI, Income Tax etc.) :contentReference[oaicite:12]{index=12}
    "Reserve Bank of India, Ashram Road, Ahmedabad, Gujarat" ,  // office on Ashram Road :contentReference[oaicite:13]{index=13}
    "Income Tax Office Buildings, Ashram Road, Ahmedabad, Gujarat" ,  // on Ashram Road :contentReference[oaicite:14]{index=14}
    "Ahmedabad Collectorate, Ashram Road, Ahmedabad, Gujarat" ,  // collector’s office, Ashram Road :contentReference[oaicite:15]{index=15}
    "All India Radio, Ashram Road, Ahmedabad, Gujarat" ,  // radio office on Ashram Road :contentReference[oaicite:16]{index=16}
    "Law Garden Market, Near Sanskar Kendra, Ahmedabad, Gujarat" ,  // popular shopping / night market area :contentReference[oaicite:17]{index=17}
    "Hutheesing Jain Temple, Shahibaug, Ahmedabad, Gujarat" ,  // marble temple in Shahibaug area :contentReference[oaicite:18]{index=18}
    "Auto World Vintage Car Museum, Shahibaug, Ahmedabad, Gujarat" ,  // automobile museum :contentReference[oaicite:19]{index=19}
    "Calico Museum of Textiles, Relief Road, Ahmedabad, Gujarat" ,  // textile museum :contentReference[oaicite:20]{index=20}
    "Vastrapur Lake, Vastrapur, Ahmedabad, Gujarat" ,  // lake & public space :contentReference[oaicite:21]{index=21}
    "Sarkhej Roza, Santej-Sarkhej Road, Ahmedabad, Gujarat" ,  // historic monument on outskirts :contentReference[oaicite:22]{index=22}
    "Science City, Sola, Ahmedabad, Gujarat" ,  // science & exhibition centre in Sola area :contentReference[oaicite:23]{index=23}
    "Sayaji Baug (Kamati Baug), Near Sayajirao Garden Road, Vadodara, Gujarat 390001",  // large garden + museum + zoo :contentReference[oaicite:0]{index=0}
    "Lakshmi Vilas Palace, Champaner Road, Vadodara, Gujarat 390020",  // royal palace/museum :contentReference[oaicite:1]{index=1}
    "Kirti Mandir, Vishwamitri Bridge Road, Vadodara, Gujarat 390001",  // memorial temple :contentReference[oaicite:2]{index=2}
    "Sursagar Lake (Chand Talao), Old City, Vadodara, Gujarat 390001",  // central lake landmark :contentReference[oaicite:3]{index=3}
    "Chimnabai Clock Tower (Raopura Tower), Raopura, Vadodara, Gujarat 390001",  // heritage clock tower :contentReference[oaicite:4]{index=4}
    "Gujarat Government Narmada Bhavan, 3rd Floor, C-Block, Jail Road, Anandpura, Vadodara, Gujarat 390001",  // state govt office :contentReference[oaicite:5]{index=5}
    "Vadodara Municipal Corporation, 4-D, Bapod, Waghodia, Vadodara, Gujarat 390019",  // civic administration office :contentReference[oaicite:6]{index=6}
    "SDM Vadodara City, Kothi Building, Kothi Cross Road, Raopura, Mandvi, Vadodara, Gujarat 390001",  // Sub-Divisional Magistrate office :contentReference[oaicite:7]{index=7}
    "Collector Office, Jilla Seva Sadan, Kothi Building, Raopura, Vadodara, Gujarat 390001",  // District Collectorate :contentReference[oaicite:8]{index=8}
    "Vadodara Junction Railway Station, Alkapuri Road, Sayajigunj, Vadodara, Gujarat 390005",  // main railway station :contentReference[oaicite:9]{index=9}
    "General Post Office Vadodara, Kharivav Road, Near Surya Narayan Mandir, Raopura, Jambubet, Vadodara, Gujarat 390001",  // main post office :contentReference[oaicite:10]{index=10}
    "Fatehgunj Post Office, VIP Road, Fatehgunj, Vadodara, Gujarat 390002",  // post office in Fatehgunj area :contentReference[oaicite:11]{index=11}
    "Karelibaug Post Office, Mental Hospital Road, Vitthal Nagar, Vadodara, Gujarat 390018",  // post office in Karelibaug :contentReference[oaicite:12]{index=12}
    "Pratapgunj Post Office, PMG Office, Pratap Ganj, Vadodara, Gujarat 390002"  // post office in Pratapgunj area :contentReference[oaicite:13]{index=13}
    // Hospitals / Medical
    "Sterling Hospital Vadodara, Race Course Road, Opposite Inox Cinema, Circle West, Hari Nagar, Vadodara, Gujarat 390007",  // super speciality hospital :contentReference[oaicite:0]{index=0}
    "VINS Hospital, 99 Urmi Society, Opp Haveli, Off Productivity Road, Akota, Vadodara, Gujarat 390007",  // private hospital :contentReference[oaicite:1]{index=1}
    "Bankers Heart Institute, Old Padra Road, Opposite Suryakiran Complex, Old Padra Road, Vadodara, Gujarat 390015",  // cardiac hospital :contentReference[oaicite:2]{index=2}
    "Tricolour Hospitals, Dr. Vikram Sarabhai Road, Genda Circle, Vadiwadi, Vadodara, Gujarat 390007",  // hospital :contentReference[oaicite:3]{index=3}
    "Aashray Urology Institute, 80/A Sampatrao Colony, Lane Opposite Circuit House, Off R.C. Dutt Road, Vadodara, Gujarat 390007",  // urology speciality :contentReference[oaicite:4]{index=4}
    "Aayushya Multi Speciality Hospital, A-16 Mukhi Nagar Society, Near My Shannen School, Opp Darshanam Oasis, Khodiyar Nagar, New VIP Road, Vadodara, Gujarat 390019",  // multi-speciality :contentReference[oaicite:5]{index=5}
    "Abhishek Hospital, Shanti Park Society, Besides Jay Mahisagar Maa Mandir, Gorwa Road, Vadodara, Gujarat 390023",  // general hospital :contentReference[oaicite:6]{index=6}

    // Colleges / Universities
    "Maharaja Sayajirao University of Baroda, Pratapgunj, Vadodara, Gujarat 390002",  // major public university :contentReference[oaicite:7]{index=7}
    "The M.S. University of Baroda, Faculty of Fine Arts, Nyay Mandir, Kala Bhavan, Vadodara, Gujarat 390001",  // fine arts faculty :contentReference[oaicite:8]{index=8}
    "Baroda Medical College, J.N. Marg, Pratapgunj, Vadodara, Gujarat 390001",  // medical college :contentReference[oaicite:9]{index=9}
    "Parul University, P.O. Limda, Taluka Waghodia, Vadodara, Gujarat 391760",  // large private university campus :contentReference[oaicite:10]{index=10}
    "Navrachana University, Vasna Bhayli Road, Vadodara, Gujarat 391410",  // private university :contentReference[oaicite:11]{index=11}
    "Vadodara Institute Of Engineering, Kotambi, Halol Toll Road, Near Kotambi, Waghodia, Vadodara, Gujarat 391510",  // engineering college :contentReference[oaicite:12]{index=12}
    "Kala Bhavan Engineering College, Jawaharlal Nehru Marg, Babajipura, Vadodara, Gujarat 390001",  // engineering college within MSU :contentReference[oaicite:13]{index=13}
    "Sigma Institute of Engineering, Ajwa Nimeta Road, Bakrol, Vadodara, Gujarat 391510",  // engineering college :contentReference[oaicite:14]{index=14}

    // Malls / Shopping Centers
    "Mahima Resicom, Sharnam Road, Makarpura, Dhaniavi, Vadodara, Gujarat 390014",  // shopping mall in Dhaniavi area :contentReference[oaicite:15]{index=15}
    "Padmavati Shopping Center, Lehripura Gate, Kansara Pole, Bajwada, Mandvi, Vadodara, Gujarat 390001",  // shopping centre in Baranpura / Mandvi :contentReference[oaicite:16]{index=16}

    // Other Notable Places
    "Khanderao Market, Chamaraja Road, Vadodara, Gujarat",  // historic market & municipal offices at Chamaraja Road :contentReference[oaicite:17]{index=17}
    "Swarnim Gujarat Sports University, Opp. Taluka Seva Sadan, Desar, Vadodara, Gujarat 391774",  // sports university campus in Desar :contentReference[oaicite:18]{index=18}
    "Central University of Gujarat, Kundhela Village, Dabhoi Taluka, Vadodara District, Gujarat 391107",  // central University campus :contentReference[oaicite:19]{index=19}
    // Medical / Hospitals
    "SoLA Civil Hospital, Sarkhej-Gandhinagar Highway, Sola Road, Ahmedabad, Gujarat 380060",  // large public hospital :contentReference[oaicite:0]{index=0}
    "Government Mental Hospital, Shahibaug, Ahmedabad, Gujarat",  // govt mental health institution :contentReference[oaicite:1]{index=1}
    "Gujarat Cancer Research Institute, Shahibaug, Ahmedabad, Gujarat",  // cancer research & hospital centre :contentReference[oaicite:2]{index=2}
    "Smt. NHL Municipal Medical College, Ellisbridge, Paldi, Ahmedabad, Gujarat 380006",  // medical college & associated hospital :contentReference[oaicite:3]{index=3}

    // Colleges / Medical Education
    "B. J. Medical College, Asarwa, Ahmedabad, Gujarat 380016",  // one of principal medical colleges :contentReference[oaicite:4]{index=4}
    "AMC MET Medical College, LG Hospital Campus, Maninagar, Ahmedabad, Gujarat 380008",  // AMC's medical college :contentReference[oaicite:5]{index=5}
    "GCS Medical College, Opposite D. R. M. Office, Chamunda Bridge, Naroda Road, Ahmedabad-380025, Gujarat",  // medical college on Naroda Road :contentReference[oaicite:6]{index=6}

    // Metro / Transit
    "Jivraj Park Metro Station, Jivraj Park, Ahmedabad, Gujarat 380051",  // Red Line metro station :contentReference[oaicite:7]{index=7}
    "Usmanpura Metro Station, Sattar Taluka Society, Usmanpura, Ahmedabad, Gujarat 380014",  // metro station on Red Line :contentReference[oaicite:8]{index=8}
    "Vadaj Metro Station, Akhbar Nagar, Nava Vadaj, Ahmedabad, Gujarat 380081",  // elevated metro station :contentReference[oaicite:9]{index=9}

    // Malls / Shopping Centres
    "Phoenix Mall, Sarkhej-Gandhinagar Highway, Thaltej, Ahmedabad, Gujarat",  // large mall in Thaltej area :contentReference[oaicite:10]{index=10}
    "Palladium Ahmedabad, Sarkhej-Gandhinagar Highway, Thaltej, Ahmedabad, Gujarat",  // high-end shopping centre :contentReference[oaicite:11]{index=11}
    "Acropolis Mall, Thaltej Cross Road, Thaltej Road, Thaltej, Ahmedabad, Gujarat",  // near Thaltej cross roads :contentReference[oaicite:12]{index=12}
    "Himalaya Mall, Gurukul, Ahmedabad, Gujarat",  // mall in Gurukul area :contentReference[oaicite:13]{index=13}
    "Nexus Ahmedabad One, Vastrapur Road, Vastrapur, Ahmedabad, Gujarat",  // big mall in Vastrapur region :contentReference[oaicite:14]{index=14}
    "Iskcon Mall, Iskcon Cross Road, Satellite, Ahmedabad, Gujarat",  // shopping center in Satellite area :contentReference[oaicite:15]{index=15}
    "CG Square Mall, Navrangpura, Ahmedabad, Gujarat",  // mall on CG Road / Navrangpura area :contentReference[oaicite:16]{index=16}
    "Ishaan 3, Near Shell Petrol Pump, Prahladnagar, Ahmedabad, Gujarat",  // smaller shopping complex :contentReference[oaicite:17]{index=17}
  ];




  TextEditingController controller=TextEditingController();
}
