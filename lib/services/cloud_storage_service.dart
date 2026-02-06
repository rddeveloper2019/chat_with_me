import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

const USERS_COLLECTION = 'users';

class CloudStorageService {
  final FirebaseFirestore _storage = FirebaseFirestore.instance;

  CloudStorageService() {}
}
