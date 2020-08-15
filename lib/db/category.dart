import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
    Firestore _firestore = Firestore.instance;
    String ref = 'categories';

    void createCategory(String name){
        var id = Uuid(); // Uuid permet de générer des chaine de caractère
        String categoryId = id.v1();
        
        _firestore.collection(ref).document(categoryId).setData({'category': name});
    }

    Future<List<DocumentSnapshot>> getCategory() {
        return _firestore.collection(ref).getDocuments().then((snaps) {
            return snaps.documents;
        });
    }

    Future<List<DocumentSnapshot>> getSuggestions(String suggestion) {
        return _firestore.collection(ref).where('category', isEqualTo: suggestion).getDocuments().then((snaps) {
            return snaps.documents;
        });
    }
}