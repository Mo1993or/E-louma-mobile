import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/client/reservation_form_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:E_louma/Utils/size.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductInterface product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          /// IMAGE HEADER
          SizedBox(
            height: mediaHeight(context) / 2,
            width: double.infinity,
            child: Hero(
              tag: product.primaryImageUrl.isNotEmpty
                  ? product.primaryImageUrl
                  : product.id,
              child: product.primaryImageUrl.isNotEmpty
                  ? Image.network(
                      product.primaryImageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: Icon(Icons.image_outlined,
                          size: 64, color: Colors.grey.shade600),
                    ),
            ),
          ),

          /// OVERLAY GRADIENT
          FadeInUp(
              duration: Duration(milliseconds: 1500),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )),

          /// BACK BUTTON

          /// CONTENT
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return FadeInUp(
                  duration: Duration(milliseconds: 1500),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      controller: controller,
                      children: [
                        /// HANDLE
                        Center(
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// NAME
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// PRICE
                        Text(
                          "${product.price}",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// QUALITY
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange),
                            const SizedBox(width: 5),
                            Text(
                              product.quantity,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// DESCRIPTION (FAKE)
                        const Text(
                          "Description du produit",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Ce produit est de très bonne qualité. Design moderne, durable et adapté à un usage quotidien.",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ));
            },
          ),

          /// BOTTOM BUTTON
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomFormButton(
              innerText: 'Acheter maintenant',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReservationFormPage(product: product),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60, left: 25),
            alignment: Alignment.topLeft,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      left: 5,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor,
                    )))),
          ),
        ],
      ),
    );
  }
}
