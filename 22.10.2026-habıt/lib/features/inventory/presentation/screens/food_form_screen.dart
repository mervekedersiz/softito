import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_header.dart';
import '../../domain/entities/food_item.dart';
import '../providers/inventory_providers.dart';

class FoodFormScreen extends ConsumerStatefulWidget {
  final String? foodId;

  const FoodFormScreen({super.key, this.foodId});

  @override
  ConsumerState<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends ConsumerState<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _subLocationController;
  late TextEditingController _priceController;
  late TextEditingController _noteController;

  String _selectedUnit = 'adet';
  FoodCategory _selectedCategory = FoodCategory.produce;
  StorageLocation _selectedLocation = StorageLocation.fridge;
  DateType _selectedDateType = DateType.stt;
  PackageStatus _selectedPackageStatus = PackageStatus.unopened;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));

  bool _isInit = false;
  bool _isLoading = false;

  final List<String> _units = ['adet', 'g', 'kg', 'ml', 'L', 'paket', 'demet', 'kavanoz'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController(text: '1');
    _subLocationController = TextEditingController();
    _priceController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit && widget.foodId != null) {
      _loadExistingItem();
      _isInit = true;
    }
  }

  Future<void> _loadExistingItem() async {
    final food = await ref.read(foodRepositoryProvider).getFoodById(widget.foodId!);
    if (food != null && mounted) {
      setState(() {
        _nameController.text = food.name;
        _quantityController.text = food.quantity.toString();
        _selectedUnit = food.unit;
        _selectedCategory = food.category;
        _selectedLocation = food.storageLocation;
        _subLocationController.text = food.subLocation;
        _selectedDateType = food.dateType;
        _selectedDate = food.expiryDate;
        _selectedPackageStatus = food.packageStatus;
        if (food.purchasePrice != null) {
          _priceController.text = food.purchasePrice!.toString();
        }
        if (food.note != null) {
          _noteController.text = food.note!;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _subLocationController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final double qty = double.tryParse(_quantityController.text.trim()) ?? 1.0;
      final double? price = _priceController.text.trim().isNotEmpty
          ? double.tryParse(_priceController.text.trim())
          : null;

      final food = FoodItem(
        id: widget.foodId ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        quantity: qty,
        unit: _selectedUnit,
        category: _selectedCategory,
        storageLocation: _selectedLocation,
        subLocation: _subLocationController.text.trim(),
        dateType: _selectedDateType,
        expiryDate: _selectedDate,
        purchasePrice: price,
        note: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : null,
        packageStatus: _selectedPackageStatus,
        createdAt: now,
        updatedAt: now,
      );

      final notifier = ref.read(foodsListProvider.notifier);
      if (widget.foodId != null) {
        await notifier.updateFood(food);
      } else {
        await notifier.addFood(food);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.foodId != null
                ? 'Ürün bilgileri güncellendi.'
                : 'Yeni ürün envantere eklendi.'),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt başarısız: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.foodId != null;

    return Scaffold(
      appBar: AppHeader(
        subtitle: isEditing ? 'Ürün Düzenle' : 'Yeni Ürün Ekle',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              const Text('Ürün Adı *', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Organik Köy Sütü, Kaşar Peyniri',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen bir ürün adı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantity & Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Miktar *', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: '1'),
                          validator: (val) {
                            if (val == null || double.tryParse(val.trim()) == null) {
                              return 'Geçerli miktar girin.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Birim', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedUnit,
                          decoration: const InputDecoration(),
                          items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedUnit = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category & Location
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<FoodCategory>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(),
                          items: FoodCategory.values
                              .map((c) => DropdownMenuItem(value: c, child: Text(c.label, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saklama Alanı', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<StorageLocation>(
                          initialValue: _selectedLocation,
                          decoration: const InputDecoration(),
                          items: StorageLocation.values
                              .map((l) => DropdownMenuItem(value: l, child: Text(l.label, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedLocation = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // SubLocation (Raf, Çekmece)
              const Text('Alt Bölme / Raf', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _subLocationController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Üst Raf, Sebzelik, Bakliyat Rafı',
                ),
              ),
              const SizedBox(height: 16),

              // Date Type & Expiry Date
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tarih Türü', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<DateType>(
                          initialValue: _selectedDateType,
                          decoration: const InputDecoration(),
                          items: DateType.values
                              .map((d) => DropdownMenuItem(value: d, child: Text(d.label)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedDateType = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Son Tüketim Tarihi', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    DateFormatter.toShortDate(_selectedDate),
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Package Status (Crucial for donations!)
              const Text('Ambalaj Durumu (Bağış Uygunluğu İçin Önemlidir)', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              DropdownButtonFormField<PackageStatus>(
                initialValue: _selectedPackageStatus,
                decoration: const InputDecoration(),
                items: PackageStatus.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPackageStatus = val);
                },
              ),
              const SizedBox(height: 16),

              // Purchase Price
              const Text('Satın Alma Fiyatı (₺ - İsteğe Bağlı)', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Örn: 35.00',
                  prefixText: '₺ ',
                ),
              ),
              const SizedBox(height: 16),

              // Note
              const Text('Ek Not', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Örn: Vakumlu paket, 2 gün önce açıldı vb.',
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Değişiklikleri Kaydet' : 'Ürünü Envantere Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
