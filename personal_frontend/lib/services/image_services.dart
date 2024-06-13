import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/services/authorization_services.dart';

class ImageServices {
  // object to use AuthServices methods
  final AuthServices authServices = AuthServices();

  // Method to allow a user to upload their own profile image from their device
  Future<String> uploadProfileImage(String userId) async {
    try {
      if (kIsWeb) {
        html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();
        await uploadInput.onChange.first;

        if (uploadInput.files!.isNotEmpty) {
          final file = uploadInput.files!.first;
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          await reader.onLoad.first;

          final encodedImage = reader.result as String;
          final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
          final uploadTask = storageRef.putString(encodedImage, format: PutStringFormat.dataUrl);

          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          return downloadUrl;
        } else {
          throw Exception("No image selected");
        }
      } else {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final imageFile = File(pickedFile.path);
          final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
          final uploadTask = storageRef.putFile(imageFile);

          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          return downloadUrl;
        } else {
          throw Exception("No image selected");
        }
      }
    } catch (e) {
      print('Error in uploadProfileImage: $e');
      throw e;
    }
  }

  // Method to get the download url of the user's image and update their profile_image_url field in firestore
  Future<void> updateUserProfileImage(String userId) async {
    try {
      String downloadUrl = await uploadProfileImage(userId);

      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('updateProfileImage');
      
      // Call the backend endpoint to update the user's profile_image_url
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'profile_image_url': downloadUrl,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated profile image URL
        print("Profile image updated successfully");
      } else {
        // Handle error
        print("Failed to update profile image URL");
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error in updateUserProfileImage: $e');
    }
  }
}


