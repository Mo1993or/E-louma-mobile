import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/widget/CategoryPage.dart';
import 'package:flutter/material.dart';

Widget makeCategory(
    CategoryInterface category, context, List<ProductInterface> listProduct) {
  List<ProductInterface> listProductFilter = [];
  for (int i = 0; i < listProduct.length; i++) {
    if (category.name == listProduct[i].category.name) {
      listProductFilter.add(listProduct[i]);
    }
  }
  return AspectRatio(
    aspectRatio: 2 / 2.2,
    child: Hero(
      tag: category.name,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryPage(
                        image: category.image,
                        title: category.name,
                        tag: category.name,
                        listProduct: listProductFilter,
                        isComming: false,
                      )));
        },
        child: Container(
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(category.image), fit: BoxFit.cover)),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.0),
                  ])),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    category.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
            ),
          ),
        
      ),
    ),
  );
}

Widget makeBestCategory(CategoryInterface category, int lengthMyProduct,
    context, List<ProductInterface> listProduct, bool isComming) {
  List<ProductInterface> listProductFilter = [];
  for (int i = 0; i < listProduct.length; i++) {
    if (category.name == listProduct[i].category.name) {
      listProductFilter.add(listProduct[i]);
    }
  }
  return AspectRatio(
      aspectRatio: 3 / 2.2,
      child: Hero(
          tag: category.name,
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                              image: category.image,
                              title: category.name,
                              tag: category.name,
                              listProduct: listProductFilter,
                              isComming: isComming,
                            )));
              },
              child: Stack(alignment: Alignment.centerRight, children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(category.image),
                          fit: BoxFit.cover)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.8),
                              Colors.black.withOpacity(.0),
                            ])),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          category.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                ),
                (listProductFilter.length > 0)
                    ? Container(
                        margin: EdgeInsets.only(top: 10, right: 40, bottom: 80),
                        alignment: Alignment.topRight,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                          },
                          child: Container(
                              // margin: EdgeInsets.only(left: 5),
                              child: Center(
                                  child: Text(
                            "${listProductFilter.length}",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ))),
                        ))
                    : Container(),
              ]))));
}
