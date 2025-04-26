import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/user_model.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register admin
  Future<String?> registerAdmin(
    String name,
    String email,
    String password,
  ) async {
    try {
      if(email!="kayanihamad25@gmail.com" && password!="newpass12A@"){
        Get.snackbar("Register Admin", "Incorrect Credentials");
      }
   else{
       final UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
                  final deviceToken = await FirebaseMessaging.instance.getToken();

                  if(deviceToken!.isNotEmpty){
   UserModel admin = UserModel(
    userDeviceToken: deviceToken,
        role:
            email == "kayanihamad25@gmail.com" && password == "newpass12A@"
                ? "admin"
                : "patient",
        id: userCred.user!.uid,
        name: name,
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(admin.id).set(admin.toMap());
      return null; // success
                  }


   
   }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Login admin
  Future<String?> loginAdmin(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get user document from Firestore
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (!userDoc.exists) {
      return "User data not found!";
    }

    // Convert Firestore doc to UserModel
    UserModel loggedInUser = UserModel(
    userDeviceToken: userDoc['userDeviceToken'],
      id: userDoc['id'],
      name: userDoc['name'],
      email: userDoc['email'],
      role: userDoc['role'],
      password: '', // Do NOT store password locally
    );

    // Store user data locally
    await storeUserDataLocally(loggedInUser);

    return null; // success
  } on FirebaseAuthException catch (e) {
    if(kDebugMode){
      print("Error while storing data locally ${e.message}");
    }
    return e.message;
  } catch (e) {
    if(kDebugMode){
      print("Error is ${e.toString()}");
    }
    return e.toString();
  }
}

// Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }
Future<void> storeUserDataLocally(UserModel user) async {
  LocalStorage localStorage = LocalStorage();

  await localStorage.setValue('id', user.id);
  await localStorage.setValue('email', user.email);
  await localStorage.setValue('name', user.name);
  await localStorage.setValue('role', user.role);
  await localStorage.setValue("userDeviceToken", user.userDeviceToken);

  // Check values to verify
  String? id = await localStorage.getValue('id');
  String? email = await localStorage.getValue('email');
  String? name = await localStorage.getValue('name');
  String? role = await localStorage.getValue('role');
  String ? userDeviceToken=await localStorage.getValue("userDeviceToken");

  print("Stored User Data:");
  print("ID: $id");
  print("Email: $email");
  print("Name: $name");
  print("Role: $role");
  print("device Token: $userDeviceToken");
}


}
