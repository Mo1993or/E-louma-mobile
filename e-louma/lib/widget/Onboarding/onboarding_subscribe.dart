import 'dart:ui';

import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/widget/add_product.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class SellerOfferOnboardingPage extends StatefulWidget {
  final List<CategoryInterface> listCategory;
  const SellerOfferOnboardingPage({super.key, required this.listCategory});
  @override
  State<SellerOfferOnboardingPage> createState() =>
      _SellerOfferOnboardingPageState();
}

class _SellerOfferOnboardingPageState extends State<SellerOfferOnboardingPage> {
  final PageController _pageController = PageController(
    viewportFraction: .86,
  );

  int currentPage = 0;

  final offers = [
    OfferModel(
        title: "Commencez",
        subtitle: "Commencez facilement",
        products: "Ajoutez vos produits gratuitement",
        price: "0 FCFA",
        color: primaryColor,
        icon: Icons.inventory_2_rounded,
        features: [
          "Publication rapide",
          "1 mois de publication offerte",
          "Visibilité sur E-louma",
          "Support inclus",
        ],
        textButton: "Commencer"),
    OfferModel(
      title: "Business",
      subtitle: "Développez votre commerce",
      products: "Jusqu'à 20 produits",
      price: "15 000 FCFA",
      color: const Color(0xff14AE5C),
      icon: Icons.rocket_launch_rounded,
      popular: true,
      features: [
        "Plus de visibilité",
        "Meilleur référencement",
        "Support prioritaire",
      ],
      textButton: 'Choisir cette offre',
    ),
    OfferModel(
      title: "Premium",
      subtitle: "Passez au niveau supérieur",
      products: "30 à 50 produits",
      price: "25 000 FCFA",
      color: const Color(0xff6750F7),
      icon: Icons.workspace_premium_rounded,
      features: [
        "Visibilité maximale",
        "Priorité dans les recherches",
        "3 produits offert si vous vous abonnez 3 fois de suites",
      ],
      textButton: 'Choisir cette offre',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Stack(
        children: [
          /// Background
          Positioned(
            top: -180,
            right: -120,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(.10),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(.10),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(.10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.storefront_rounded,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ajoutez vos produits",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Choisissez une offre pour publier vos produits sur E-louma.",
                              style: TextStyle(
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: offers.length,
                    onPageChanged: (i) {
                      setState(() {
                        currentPage = i;
                      });
                    },
                    itemBuilder: (_, index) {
                      final offer = offers[index];

                      return AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 350,
                        ),
                        curve: Curves.ease,
                        margin: EdgeInsets.only(
                          top: currentPage == index ? 0 : 25,
                          bottom: currentPage == index ? 10 : 45,
                          left: 8,
                          right: 8,
                        ),
                        child: _OfferCard(
                          offer: offer,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// Indicateur
                _PageIndicator(
                  currentIndex: currentPage,
                  itemCount: offers.length,
                  activeColor: offers[currentPage].color,
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (offers[currentPage].textButton == "Commencer") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddProductPage(
                                          listCategory: widget.listCategory,
                                        )));
                          } else {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Information',
                                message: 'Cette offre sera bientôt activée',
                                contentType: ContentType.help,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                          // TODO: Aller vers le paiement
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (offers[currentPage].textButton == "Commencer")
                                    ? Colors.black
                                    : offers[currentPage].color,
                                (offers[currentPage].textButton == "Commencer")
                                    ? Colors.black.withOpacity(.75)
                                    : offers[currentPage]
                                        .color
                                        .withOpacity(.75),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: (offers[currentPage].textButton ==
                                        "Commencer")
                                    ? Colors.black.withOpacity(.35)
                                    : offers[currentPage]
                                        .color
                                        .withOpacity(.35),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              offers[currentPage].textButton,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Plus tard",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color activeColor;

  const _PageIndicator({
    required this.currentIndex,
    required this.itemCount,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final selected = currentIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: selected ? 30 : 8,
          decoration: BoxDecoration(
            color: selected ? activeColor : Colors.grey.withOpacity(.25),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferModel offer;

  const _OfferCard({
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.82),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(
                color: Colors.white.withOpacity(.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (offer.popular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "⭐ Le plus populaire",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  if (offer.popular) const SizedBox(height: 18),
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      color: offer.color.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      offer.icon,
                      color: offer.color,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offer.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    offer.products,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: offer.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          offer.color,
                          offer.color.withOpacity(.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "À partir de",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Inclus dans cette offre",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...offer.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: offer.color.withOpacity(.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: offer.color,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  (offer.textButton != "Commencer")
                      ? Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: offer.color.withOpacity(.06),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                color: offer.color,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Paiement sécurisé et activation immédiate de votre offre après validation.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ));
  }
}

class OfferModel {
  final String title;
  final String subtitle;
  final String products;
  final String price;
  final Color color;
  final IconData icon;
  final bool popular;
  final List<String> features;
  final String textButton;

  const OfferModel({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.price,
    required this.color,
    required this.icon,
    required this.features,
    this.popular = false,
    required this.textButton,
  });
}
