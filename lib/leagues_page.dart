import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agra_tpm/teams_page.dart';
import 'dart:convert';

class LeagueListPage extends StatefulWidget {
  @override
  LeagueListPageState createState() => LeagueListPageState();
}

class LeagueListPageState extends State<LeagueListPage> {
  List<dynamic> _leagues = [];

  Future<void> _fetchLeagues() async {
    try {
      final response = await http
          .get(Uri.parse('https://go-football-api-v44dfgjgyq-et.a.run.app/'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('League data fetched: $jsonData');
        setState(() {
          _leagues = jsonData['Data'] ?? [];
        });
      } else {
        print('Failed to load leagues: ${response.statusCode}');
        throw Exception('Failed to load leagues');
      }
    } catch (e) {
      print('Error fetching leagues: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _leagues.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _leagues.length,
                itemBuilder: (context, index) {
                  final league = _leagues[index];
                  final leagueName = league['leagueName'] ?? 'Unknown League';
                  final country = league['country'] ?? 'Unknown Country';
                  final logoUrl = league['logoLeagueUrl'] ?? '';

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.blue[100], // Tambahkan warna latar belakang
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TeamScreen(leagueId: league['idLeague']),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: logoUrl.isNotEmpty
                                ? Image.network(
                                    logoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  )
                                : Icon(Icons.sports_soccer),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  leagueName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        18, // Tambahkan ukuran font yang lebih besar
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Ubah warna teks
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  country,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700], // Ubah warna teks
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
    );
  }
}
