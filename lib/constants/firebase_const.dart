import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;

// ---------- Chat --------------------

var chatCollection = fireStore.collection('chat');

    // .doc(auth.currentUser?.uid)
    // .collection('chat')
    // .doc(auth.currentUser?.uid);
