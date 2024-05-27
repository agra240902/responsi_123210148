import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamDetailScreen extends StatefulWidget {
  final int teamId;

  TeamDetailScreen({required this.teamId});

  @override
  TeamDetailScreenState createState() => TeamDetailScreenState();
}

class TeamDetailScreenState extends State<TeamDetailScreen> {
  Map<String, dynamic>? _teamDetails;
  bool _isLoading = true;
  bool _isFavorite = false; // Track favorite status

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'https://go-football-api-v44dfgjgyq-et.a.run.app/1/${widget.teamId}'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Team details fetched: $jsonData');
        setState(() {
          _teamDetails = jsonData['Data'];
          _isLoading = false;
        });
      } else {
        print('Failed to load team details: ${response.statusCode}');
        throw Exception('Failed to load team details');
      }
    } catch (e) {
      print('Error fetching team details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite; // Toggle favorite status
    });

    // Show snackbar based on favorite status
    final snackBar = SnackBar(
      content: Text(
        _isFavorite ? 'Berhasil ditambahkan' : 'Berhasil menghapus',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: _isFavorite ? Colors.green : Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Details'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _teamDetails == null
              ? Center(child: Text('No details found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[100],
                            ),
                            child: _teamDetails!['LogoClubUrl'] != null
                                ? Image.network(
                                    _teamDetails!['LogoClubUrl'],
                                    height: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  )
                                : Icon(Icons.sports, size: 100),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 180),
                              child: Text(
                                _teamDetails!['NameClub'] ?? 'Unknown Team',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildDetailCard('HeadCoach', _teamDetails!['HeadCoach']),
                      _buildDetailCard('Captain', _teamDetails!['CaptainName']),
                      _buildDetailCard('Stadium', _teamDetails!['StadiumName']),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _showClubLogo(_teamDetails!['LogoClubUrl']);
                        },
                        child: Text('Show Club Logo'),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : null,
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String? value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value ?? 'Unknown',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showClubLogo(String? logoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: logoUrl != null
              ? Image.network(
                  logoUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load logo');
                  },
                )
              : Text('Logo not available'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

