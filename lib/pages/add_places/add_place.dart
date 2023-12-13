import 'dart:io';

import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/provder/place_provider.dart';
import 'package:favorite_place_app/widget/image_input.dart';
import 'package:favorite_place_app/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectImgae;
  PlaceLocation? _placeLocation;
  TextEditingController titleControler = TextEditingController();
  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      var title = titleControler.text;
      if (title.isEmpty || _selectImgae == null || _placeLocation == null) {
        return;
      }
      ref.read(userPlacesProvider.notifier).addPlace(
            title,
            _selectImgae!,
            _placeLocation!,
          );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Places"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: titleControler,
                    maxLength: 100,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng không bỏ trống";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ImageInput(
                  onPickImage: (File image) {
                    _selectImgae = image;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                LocationInput(
                  onSelectLocation: (PlaceLocation placeLocation) {
                    _placeLocation = placeLocation;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _savePlace();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Places"),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
