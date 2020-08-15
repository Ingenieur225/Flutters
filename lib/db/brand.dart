import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService{
    Firestore _firestore = Firestore.instance;
    String ref = 'brands';

    void createBrand(String name){
      var id = Uuid();
      String brandId = id.v1();

      _firestore.collection(ref).document(brandId).setData({'brand': name});
    }

    Future<List<DocumentSnapshot>> getBrands() {
        return _firestore.collection(ref).getDocuments().then((snaps) {
            return snaps.documents;
        });
    }

    Future<List<DocumentSnapshot>> getSuggestions(String suggestion) {
        return _firestore.collection(ref).where('brand', isEqualTo: suggestion).getDocuments().then((snaps) {
            return snaps.documents;
        });
    }
}