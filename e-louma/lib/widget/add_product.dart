import 'package:E_louma/Interface/categoryInterface.dart';
import 'package:E_louma/Pages/HomePage/ShopPage.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/product_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:animate_do/animate_do.dart';
import 'package:E_louma/Pages/Auth/signIn.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  final List<CategoryInterface> listCategory;

  const AddProductPage({required this.listCategory});
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? selectedCategory;
  String? selectedCondition;
  String? selectedAmountType;
  String? selectedQuantity;
  String idCat = "";

  final List<File> _images = [];
  List<String> items = [];
  List<dynamic> imagesPath = [];

  _fetItemsCat() {
    for (var element in widget.listCategory) {
      items.add(element.name);
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<File>? images = await showImagePicker(context);

    if (images != null && images.isNotEmpty) {
      // Une seule image si elle vient de la caméra.
      // Plusieurs si elles viennent de la galerie.
      // final List<File> pickedFiles = await _picker.pickMultiImage();
      for (final image in images) {
        setState(() {
          print(image.path);

          _images.add(image);
          imagesPath.add(image.path);
        });
      }
    }
    // final List<XFile> pickedFiles = await _picker.pickMultiImage();

    // if (pickedFiles.isNotEmpty) {
    //   setState(() {
    //     _images.addAll(
    //       pickedFiles.map((e) => File(e.path)),
    //     );
    //     for (var element in _images) {
    //       imagesPath.add(element.path);
    //     }
    //   });
    // }
  }

  void _setCategoryFromValue(String? value) {
    if (value == null || !value.contains(',')) return;
    final parts = value.split(',');
    idCat = parts.first;
    selectedCategory = value;
  }

  void _closeLoadingDialog() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _showMessage(String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom du produit est obligatoire';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le prix est obligatoire';
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Entrez un prix valide';
    }
    return null;
  }

  _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (idCat.isEmpty) {
      _showMessage(
        'Champ manquant',
        'Veuillez choisir une catégorie',
        ContentType.warning,
      );
      return;
    }
    if (selectedCondition == null || selectedCondition!.isEmpty) {
      _showMessage(
        'Champ manquant',
        'Veuillez choisir la condition du produit',
        ContentType.warning,
      );
      return;
    }
    if (selectedQuantity == null || selectedQuantity!.isEmpty) {
      _showMessage(
        'Champ manquant',
        'Veuillez choisir une quantité',
        ContentType.warning,
      );
      return;
    }
    if (selectedAmountType == null || selectedAmountType!.isEmpty) {
      _showMessage(
        'Champ manquant',
        'Indiquez si le montant est négociable',
        ContentType.warning,
      );
      return;
    }
    if (_images.isEmpty) {
      _showMessage(
        'Photo manquante',
        'Ajoutez au moins une photo du produit',
        ContentType.warning,
      );
      return;
    }

    try {
      showAlertDialog(context);
      var conditionEnum = "";
      setState(() {
        switch (selectedCondition) {
          case "Neuf":
            conditionEnum = "neuf";
          case "Second main":
            conditionEnum = "seconde_main";
          case "Trés bon état":
            conditionEnum = "tres_bon_etat";
          case "Bon état":
            conditionEnum = "bon_etat";
          case "Satisfaisant":
            conditionEnum = "satisfaisant";
            break;
          default:
        }
      });

      var data = {
        "title": nameController.text.trim(),
        'price': int.parse(priceController.text.trim()),
        'category': idCat,
        'brand': descriptionController.text.trim(),
        'quantity': selectedQuantity,
        'condition': conditionEnum,
        'pricenegotiable': selectedAmountType == "Oui",
      };
      var result = await ProductService().addProduct(data, imagesPath);

      print("result $result");
      if (!mounted) return;
      _closeLoadingDialog();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ShopPage()));

      _showMessage('Succès', 'Produit ajouté', ContentType.success);
    } catch (error) {
      print("error $error");
      if (!mounted) return;
      _closeLoadingDialog();
      _showMessage(
        'Erreur',
        error.toString().replaceFirst('Exception: ', ''),
        ContentType.failure,
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetItemsCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Ajouter un produit"),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: FadeInUp(
            duration: Duration(milliseconds: 1400),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE UPLOAD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            children: [
                              const Icon(Icons.photo_library_outlined),
                              const SizedBox(width: 10),
                              const Text(
                                "Photos du produit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),

                              /// ADD BUTTON
                              GestureDetector(
                                onTap: _pickImages,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// GRID IMAGES
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _images.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              /// ADD CARD
                              if (index == _images.length) {
                                return GestureDetector(
                                  onTap: _pickImages,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          size: 32,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Ajouter",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              /// IMAGE CARD
                              return Stack(
                                children: [
                                  /// IMAGE
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: FileImage(_images[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  /// DELETE BUTTON
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // NOM PRODUIT
                    TextFormField(
                      controller: nameController,
                      cursorColor: primaryColor,
                      validator: _validateTitle,
                      decoration: InputDecoration(
                        labelText: "Nom du produit",
                        labelStyle: TextStyle(
                          color: primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // CATEGORIE
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: Text("Choisir une catégorie"),
                      validator: (value) =>
                          value == null ? 'Choisissez une catégorie' : null,
                      items: widget.listCategory
                          .map((cat) => DropdownMenuItem(
                                value: "${cat.id},${cat.name}",
                                child: Text(cat.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _setCategoryFromValue(value));
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      cursorColor: primaryColor,
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description / Marque",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: primaryColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCondition,
                      hint: Text("Condition"),
                      items: [
                        "Neuf",
                        "Second main",
                        "Trés bon état",
                        "Bon état",
                        "Satisfaisant"
                      ]
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCondition = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedAmountType,
                      hint: Text("Montant Négociable ?"),
                      items: [
                        "Non",
                        "Oui",
                      ]
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAmountType = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // PRIX
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      validator: _validatePrice,
                      decoration: InputDecoration(
                        fillColor: primaryColor,
                        focusColor: primaryColor,
                        labelText: (selectedAmountType == "Oui")
                            ? "Montant provisoire"
                            : "Montant définitif",
                        labelStyle: TextStyle(
                          color: primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // QUANTITE
                    DropdownButtonFormField<String>(
                      value: selectedQuantity,
                      hint: Text("Quantité"),
                      items: ["1", "2", "3", "4", "5", "6", "7"]
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedQuantity = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: TextStyle(
                          color: primaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // BOUTON
                    CustomFormButton(
                      innerText: 'Ajouter',
                      onPressed: () async {
                        await _addProduct();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

final ImagePicker _picker = ImagePicker();

Future<List<File>?> showImagePicker(BuildContext context) async {
  return await showModalBottomSheet<List<File>?>(
    context: context,
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galerie"),
              onTap: () async {
                final List<XFile> images = await _picker.pickMultiImage(
                  imageQuality: 90,
                );

                if (context.mounted) {
                  Navigator.pop(
                    context,
                    images.map((e) => File(e.path)).toList(),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Caméra"),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 90,
                );

                if (context.mounted) {
                  Navigator.pop(
                    context,
                    image != null ? [File(image.path)] : null,
                  );
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
