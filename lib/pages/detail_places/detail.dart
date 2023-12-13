import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/pages/map/map_screen.dart';
import 'package:flutter/material.dart';

class DetailPlace extends StatelessWidget {
  const DetailPlace({super.key, required this.placeModel});
  final PlaceModel placeModel;
  String get locationImage {
    final lat = placeModel.location.latitude;
    final lng = placeModel.location.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&markers=color:green%7Clabel:G%7C$lat,$lng&markers=color:red%7Clabel:C%7C$lat,$lng&key=AIzaSyAiYUEd5r-RSmTkG7dKfQIfowPIFrkuoGw";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeModel.title),
      ),
      body: Stack(
        children: [
          Image.file(
            placeModel.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return MapScreen(
                          location: placeModel.location,
                          isSelecting: false,
                        );
                      }));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(locationImage),
                      radius: 80,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    placeModel.location.address,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
