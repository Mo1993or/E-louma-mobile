import 'package:E_louma/Interface/productInterface.dart';
import 'package:E_louma/Pages/client/reservations_list_page.dart';
import 'package:E_louma/Utils/constant.dart';
import 'package:E_louma/services/reservation_service.dart';
import 'package:E_louma/widget/showAlertCustom.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Formulaire client : coordonnées + confirmation avant réservation API.
class ReservationFormPage extends StatefulWidget {
  final ProductInterface product;

  const ReservationFormPage({super.key, required this.product});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  static const _bg = Color(0xFFF8F9FC);
  static const _fieldFill = Color(0xFFF7F7F7);
  static final _accent = primaryColor;
  static final _accentDark = primaryColor;
  static final _accentDeep = primaryColor;

  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');


  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'SN', dialCode: '+221');
  String _fullPhoneNumber = '';
  bool _phoneValid = false;
  bool _phoneReady = false;
  bool _showConfirmation = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _fullNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _quantityCtrl,
    ]) {
      c.addListener(_onFieldsChanged);
    }
    _loadSavedContact();
  }

  void _onFieldsChanged() {
    if (mounted) setState(() {});
  }

  bool _isValidIso(String? iso) =>
      iso != null && RegExp(r'^[A-Za-z]{2}$').hasMatch(iso);

  Future<void> _loadSavedContact() async {
    try {
      final saved = await ReservationService.loadSavedContact();
      if (!mounted) return;

      PhoneNumber phone = PhoneNumber(isoCode: 'SN', dialCode: '+221');
      final iso = saved['isoCode'] ?? saved['countryName'];
      if (_isValidIso(iso)) {
        phone = PhoneNumber(
          isoCode: iso!.toUpperCase(),
          dialCode: saved['dialCode'] ??
              (iso.toUpperCase() == 'SN' ? '+221' : null),
        );
      }

      setState(() {
        if (saved['fullName']?.isNotEmpty == true) {
          _fullNameCtrl.text = saved['fullName']!;
        }
        if (saved['email']?.isNotEmpty == true) {
          _emailCtrl.text = saved['email']!;
        }
        if (saved['phone']?.isNotEmpty == true) {
          _phoneCtrl.text = saved['phone']!;
        }
        if (saved['address']?.isNotEmpty == true) {
          _addressCtrl.text = saved['address']!;
        }
        _phoneNumber = phone;
        final dial = phone.dialCode ?? '+221';
        final local = _phoneCtrl.text.trim();
        if (local.isNotEmpty) {
          _fullPhoneNumber = '$dial$local';
          _phoneValid = local.length >= 7;
        }
        _phoneReady = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _phoneNumber = PhoneNumber(isoCode: 'SN', dialCode: '+221');
        _phoneReady = true;
      });
    }
  }

  @override
  void dispose() {
    for (final c in [
      _fullNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _quantityCtrl,
    ]) {
      c.removeListener(_onFieldsChanged);
      c.dispose();
    }
    super.dispose();
  }

  int get _priceValue => widget.product.price;

  int get _maxQuantity {
    final q = int.tryParse(widget.product.quantity.trim());
    if (q == null || q < 1) return 1;
    return q;
  }

  int get _selectedQuantity =>
      int.tryParse(_quantityCtrl.text.trim()) ?? 1;

  void _setQuantity(int value) {
    final clamped = value.clamp(1, _maxQuantity);
    _quantityCtrl.text = '$clamped';
  }

  bool get _isFormValid {
    final name = _fullNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final quantity = int.tryParse(_quantityCtrl.text.trim());

    if (name.isEmpty) return false;
    if (email.isEmpty || !email.contains('@')) return false;
    if (!_phoneValid || _phoneCtrl.text.trim().isEmpty) return false;
    if (address.isEmpty) return false;
    if (quantity == null || quantity < 1) return false;
    if (quantity > _maxQuantity) return false;

    return true;
  }

  void _goToConfirmation() {
    if (!_isFormValid) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _showConfirmation = true);
  }

  Future<void> _submitReservation() async {
    setState(() => _submitting = true);
    showAlertDialog(context);

    final phoneToSend = _fullPhoneNumber.isNotEmpty
        ? _fullPhoneNumber
        : _phoneCtrl.text.trim();

    try {
      final message = await ReservationService.submitReservation(
        fullname: _fullNameCtrl.text,
        email: _emailCtrl.text,
        phonenumber: phoneToSend,
        address: _addressCtrl.text,
        productId: widget.product.id,
        price: _priceValue,
        quantity: _quantityCtrl.text,
      );

      await ReservationService.saveContact(
        fullName: _fullNameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text,
        dialCode: _phoneNumber.dialCode,
        countryName: _phoneNumber.isoCode,
        isoCode: _phoneNumber.isoCode,
      );

      await ReservationService.cacheReservation(
        product: widget.product,
        fullName: _fullNameCtrl.text,
        phone: phoneToSend,
        email: _emailCtrl.text,
        note: 'Quantité : ${_quantityCtrl.text}',
        phoneNumberSeller: widget.product.seller.phonenumber,
      );

      if (!mounted) return;
      Navigator.pop(context);

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Réservation confirmée',
          message: message,
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ReservationsListPage(isCommingSeller: false),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Réservation échoué',
          message: e.toString().replaceFirst('Exception: ', ''),
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_accentDeep, _accentDark, _accent],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: _showConfirmation
                        ? _buildConfirmation()
                        : _buildForm(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_showConfirmation) {
                setState(() => _showConfirmation = false);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _showConfirmation ? 'Confirmation' : 'Réserver',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                Text(
                  _showConfirmation
                      ? 'Vérifiez vos informations'
                      : 'Finalisez votre demande',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _showConfirmation ? '2 / 2' : '1 / 2',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProductHero(product: widget.product),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vos informations',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Le vendeur vous contactera pour finaliser l’achat.',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(text: 'Nom complet'),
                  _RoundedField(
                    controller: _fullNameCtrl,
                    hint: 'Ex. Ibrahima Diouf',
                    keyboardType: TextInputType.name,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'E-mail'),
                  _RoundedField(
                    controller: _emailCtrl,
                    hint: 'Ex. ibrahima@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'E-mail requis';
                      if (!v.contains('@')) return 'E-mail invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'Téléphone'),
                  if (!_phoneReady)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: LinearProgressIndicator(minHeight: 2),
                    )
                  else
                    InternationalPhoneNumberInput(
                      key: ValueKey(
                        'phone_${_phoneNumber.isoCode}_${_phoneNumber.dialCode}',
                      ),
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          _phoneNumber = number;
                          _fullPhoneNumber = number.phoneNumber ??
                              '${number.dialCode ?? ''}${_phoneCtrl.text.trim()}';
                        });
                      },
                      onInputValidated: (bool value) {
                        setState(() => _phoneValid = value);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        setSelectorButtonAsPrefixIcon: true,
                        leadingPadding: 14,
                        useEmoji: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: TextStyle(color: primaryColor),
                      initialValue: _phoneNumber,
                      textFieldController: _phoneCtrl,
                      formatInput: false,
                      inputDecoration: InputDecoration(
                        hintText: 'Numéro de téléphone (WhatsApp)',
                        labelStyle: TextStyle(color: primaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      onSaved: (PhoneNumber number) {},
                    ),
                  const SizedBox(height: 14),
                  _FieldLabel(text: 'Adresse'),
                  _RoundedField(
                    controller: _addressCtrl,
                    hint: 'Ex. Dakar, Plateau',
                    keyboardType: TextInputType.streetAddress,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Adresse requise'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(text: 'Quantité'),
                            _QuantityStepper(
                              value: _selectedQuantity,
                              max: _maxQuantity,
                              accent: _accentDark,
                              onChanged: _setQuantity,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(text: 'Prix'),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _fieldFill,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '${widget.product.price} XOF',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Disponible : $_maxQuantity chez le vendeur',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _PrimaryButton(
              label: 'Continuer',
              enabled: _isFormValid,
              onPressed: _goToConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmation() {
    return SingleChildScrollView(
      key: const ValueKey('confirm'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProductHero(product: widget.product),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Récapitulatif',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _ConfirmRow(label: 'Nom', value: _fullNameCtrl.text.trim()),
                _ConfirmRow(label: 'E-mail', value: _emailCtrl.text.trim()),
                _ConfirmRow(label: 'Téléphone', value: _fullPhoneNumber),
                _ConfirmRow(label: 'Adresse', value: _addressCtrl.text.trim()),
                _ConfirmRow(
                  label: 'Quantité',
                  value: '$_selectedQuantity / $_maxQuantity',
                ),
                _ConfirmRow(label: 'Prix', value: '$_priceValue XOF'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _fieldFill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'En confirmant, vous demandez la réservation de cet article. Le vendeur vous recontactera.',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _PrimaryButton(
            label: _submitting ? 'Envoi…' : 'Confirmer la réservation',
            enabled: !_submitting,
            onPressed: _submitReservation,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _submitting
                ? null
                : () => setState(() => _showConfirmation = false),
            child: Text(
              'Modifier mes informations',
              style: GoogleFonts.poppins(
                color: _accentDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  final ProductInterface product;

  const _ProductHero({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: product.primaryImageUrl.isNotEmpty
                ? Image.network(
                    product.primaryImageUrl,
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${product.price} XOF',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 84,
      height: 84,
      color: const Color(0xFFF7F7F7),
      alignment: Alignment.center,
      child: Icon(Icons.inventory_2_outlined, color: Colors.grey.shade500),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: const Color(0xFF3D3A36),
        ),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;

  const _RoundedField({
    required this.controller,
    required this.hint,
    required this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFC44536)),
        ),
      ),
      validator: validator,
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final int max;
  final Color accent;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({
    required this.value,
    required this.max,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrease = value > 1;
    final canIncrease = value < max;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            accent: accent,
            onTap: () => onChanged(value - 1),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$value/$max',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: accent,
                  ),
                ),
                Text(
                  'choisi / stock',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            accent: accent,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color accent;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 20,
            color: enabled ? accent : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.55,
      child: SizedBox(
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: enabled
                  ? [Colors.black87, Colors.black]
                  : [Colors.grey.shade500, Colors.grey.shade400],
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
