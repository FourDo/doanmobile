import 'package:doanngon/Bloc/bookingnow_bloc.dart';
import 'package:doanngon/Bloc/favorite_bloc.dart';
import 'package:doanngon/View/page/DestinationPage.dart';
import 'package:doanngon/View/page/FavoriteScreen.dart';
import 'package:doanngon/View/page/TicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doanngon/bloc/home_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doanngon/Repository/listtour.dart';
import 'package:doanngon/Model/tour.dart';

import 'ProfileScreen.dart';
import 'SearchScreen.dart';

class FullAppPage extends StatelessWidget {
  final List<List<Map<String, String>>> bookings;

  const FullAppPage({super.key, this.bookings = const []});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => FavoriteBloc()), 
        BlocProvider(create: (context) => BookingBloc()),
      ],
      child: FullAppView(bookings: bookings),
    );
  }
}

class FullAppView extends StatefulWidget {
  final List<List<Map<String, String>>> bookings;

  const FullAppView({super.key, required this.bookings});

  @override
  State<FullAppView> createState() => _FullAppViewState();
}

class _FullAppViewState extends State<FullAppView> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeScreen(),
      BlocProvider.value(
        value: context.read<HomeBloc>(), 
        child: const FavoriteScreen(),
      ),
      const SearchScreen(),
      TicketScreen(bookings: widget.bookings),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return IndexedStack(
            index: state is HomeInitial ? state.pageIndex : 0,
            children: pages,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state is HomeInitial ? state.pageIndex : 0,
            onTap: (index) {
              context.read<HomeBloc>().add(PageChanged(index));
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Calendar'),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.search, color: Colors.white)),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined), label: 'Messages'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> destinationsFuture;

  @override
  void initState() {
    super.initState();
    destinationsFuture = fetchDestinations();
  }

  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    final tourRepository = TourRepository();
    final tours = await tourRepository.fetchTours();
    return tours.map((tour) {
      return {
        'id': tour.id,
        "title": tour.name,
        "destination": tour.destination,
        "description": tour.description,
        "price": tour.price,
        "startDate": "${tour.startDate.toLocal()}".split(' ')[0],
        "endDate": "${tour.endDate.toLocal()}".split(' ')[0],
        "location": tour.destination,
        "rating": 4.5, // Default rating
        "image": AssetImage(tour.imageUrl), // Use AssetImage for local assets
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: Icon(Icons.person,color: Colors.blue,),
                  ),const SizedBox(width: 8),
                  Text("Username",style: TextStyle(fontSize: 18),)
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  padding:  EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.black87),
                    onPressed: () {},
                  ),
                ),
                Positioned(right: 10,top: 14,child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle
                  ),
                ))
              ],
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: destinationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load destinations'));
          } else {
            final destinations = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      children: [
                        TextSpan(text: "Explore the\n"),
                        TextSpan(
                          text: "Beautiful ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: "world!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 120),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Best Destination",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("View all",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];
                      return DestinationCard(destination: destination);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class DestinationCard extends StatefulWidget {
  final Map<String, dynamic> destination;
  const DestinationCard({Key? key, required this.destination}) : super(key: key);

  @override
  _DestinationCardState createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DestinationDetailPage(destination: widget.destination)),
        );
      },
      child: Container(
        width: 300,
        margin: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1)
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image(
                        image: widget.destination["image"],
                        height: 280,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            if (isFavorite) {
                              context
                                  .read<FavoriteBloc>()
                                  .add(AddFavorite(widget.destination));
                            } else {
                              context
                                  .read<FavoriteBloc>()
                                  .add(RemoveFavorite(widget.destination));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.destination["title"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(widget.destination["location"],
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}