// import 'dart:io';
// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:wapar/model/user_,model.dart';
// import 'package:wapar/provider/profile_provider/profile_provider.dart';
// import 'package:wapar/screens/home_screen.dart';
// import 'package:wapar/profile/widgets/profile.dart';
// import 'package:wapar/profile/widgets/profile_edit.dart';

// class ProfileScreen extends StatefulWidget {
//   final UserModel currentUser;
//   ProfileScreen({this.currentUser});
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool isEdit = false;
//   File _image;
//   User user = FirebaseAuth.instance.currentUser;

//   // Future<String> _uploadFile(File _camaraImage) async {
//   //   var storageReference =
//   //       FirebaseStorage.instance.ref().child('images/${user.uid}');
//   //   var uploadTask = storageReference.putFile(_camaraImage);
//   //   var task = await uploadTask;
//   //   final String _imageUrl = (await task.ref.getDownloadURL());

//   //   return _imageUrl;
//   // }

//   // var imageMap;
//   ProfileProvider profileProvider;
//   Widget falseImage() {
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.grey,
//           radius: 55,
//           child: CircleAvatar(
//             backgroundColor: Colors.grey,
//             backgroundImage: _image == null
//                 ? NetworkImage(
//                     widget.currentUser.userImage ?? '',
//                   )
//                 : FileImage(
//                     _image,
//                   ),
//             radius: 52,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget trueImage(context) {
//     var alert;
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.grey,
//           radius: 55,
//           child: GestureDetector(
//             onTap: () {
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//                 child: alert = AlertDialog(
//                   title: new Text(
//                     "SELECT",
//                   ),
//                   content: new Text(
//                     "your choice",
//                   ),
//                   actions: <Widget>[
//                     new MaterialButton(
//                       child: new Text("Gallery"),
//                       onPressed: () async {
//                         await getImage(source: ImageSource.gallery);
//                         Navigator.pop(context);
//                       },
//                     ),
//                     new MaterialButton(
//                       child: Text("Camera"),
//                       onPressed: () async {
//                         await getImage(source: ImageSource.camera);
//                         Navigator.pop(context);
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//               );

//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return alert;
//                 },
//               );
//             },
//             child: CircleAvatar(
//               backgroundColor: Colors.grey,
//               backgroundImage: _image == null
//                   ? NetworkImage(
//                       widget.currentUser.userImage ?? '',
//                     )
//                   : FileImage(
//                       _image,
//                     ),
//               radius: 52,
//               child: Text(
//                 'Click On',
//                 style: TextStyle(
//                     color: Theme.of(context).accentColor, fontSize: 17),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget topPart(context) {
//     return Container(
//       width: double.infinity,
//       color: Theme.of(context).primaryColor,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: profileProvider.isEdit == true
//                 ? trueImage(context)
//                 : falseImage(),
//           ),
//         ],
//       ),
//     );
//   }

//   var imageUrl;

//   Future<void> _uploadFile(File _image) async {
//     var storageReference =
//         FirebaseStorage.instance.ref().child('user_image').child('${user.uid}.jpg');
//     var uploadTask = storageReference.putFile(_image);
//     var task = await uploadTask;
//     setState(() {
//       imageUrl = task.ref.getDownloadURL();
//     });
//   }

//   Future getImage({ImageSource source}) async {
//     var pickedImage = await ImagePicker().getImage(
//       source: source,
//       imageQuality: 25,
//     );
//     setState(() {
//       _image = File(pickedImage.path);
//     });
//     await _uploadFile(_image);
//   }

//   // void checkUpdate(String fullName, String email, String password,
//   //     String phoneNumber, String fullAddress) async {
//   //   setState(() {
//   //     isEdit = false;
//   //   });
//   //   _image != null ? imageMap = await _uploadFile(_image) : Container();
//   //   await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
//   //     "userImage": _image == null ? widget.currentUser.userImage : imageMap,
//   //     'userFullName': fullName,
//   //     'userEmail': email,
//   //     'userPassword': password,
//   //     'userPhoneNumber': phoneNumber,
//   //     'userFullAddress': fullAddress,
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//         print("---------------$imageUrl-----------------");

//     double height = MediaQuery.of(context).size.height;
//     profileProvider = Provider.of<ProfileProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         leading: profileProvider.isEdit == false
//             ? IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => HomeScreen(),
//                     ),
//                   );
//                 },
//               )
//             : IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () {
//                   profileProvider.getIsEdit(false);
//                 },
//               ),
//         actions: [
//           MaterialButton(
//             onPressed: () {
//               profileProvider.getIsEdit(true);
//             },
//             child: Text(
//               'Edit',
//               style: TextStyle(
//                   color: Theme.of(context).accentColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17),
//             ),
//           )
//         ],
//         elevation: 0.0,
//       ),
//       body: Column(
//         children: [
//           topPart(context),
//           SizedBox(
//             height: height / 10,
//           ),
//           profileProvider.isEdit == false
//               ? Profile(
//                   currentUser: widget.currentUser,
//                 )
//               : ProfileEdit(
//                   currentUser: widget.currentUser,
//                   isEdit: isEdit,
//                 ),
//         ],
//       ),
//     );
//   }
// }
