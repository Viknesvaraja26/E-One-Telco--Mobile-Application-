import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _bannerImage = [];

  getBanners() {
    return _firestore
        .collection('Banners')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (this.mounted) {
          setState(() {
            _bannerImage.add(doc['image']);
          });
        }
      });
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isemptyBanner = false;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10)),
        child: isemptyBanner == true
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('lib/assets/images/error_image.png'),
                ),
              )
            : PageView.builder(
                itemCount: _bannerImage.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: _bannerImage[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer(
                        duration: Duration(seconds: 5), //Default value
                        interval: Duration(
                            seconds: 6), //Default value: Duration(seconds: 0)
                        color: Colors.white, //Default value
                        colorOpacity: 0, //Default value
                        enabled: true, //Default value
                        direction: ShimmerDirection.fromLTRB(), //Default Value
                        child: Container(
                          color: Colors.grey.shade50,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
