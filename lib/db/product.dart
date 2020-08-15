import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
    Firestore _firestore = Firestore.instance;
    String ref = 'products';

    void uploadProduct({String productName, String brand, String category, List sizes, List images, double price, int quantity}) {
        var id = Uuid();
        String productId = id.v1();

        _firestore.collection(ref).document(productId).setData({
            'id': productId,
            'name': productName,
            'brand': brand,
            'category': category,
            'sizes': sizes,
            'images': images,
            'price': price,
            'quantity': quantity,
        });
    }

    Future<List<DocumentSnapshot>> getProduct() {
        return _firestore.collection(ref).getDocuments().then((snaps) {
            return snaps.documents;
        });
    }
}