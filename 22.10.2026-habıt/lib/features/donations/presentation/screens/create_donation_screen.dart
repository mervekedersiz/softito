import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../providers/donation_providers.dart';

class CreateDonationScreen extends ConsumerStatefulWidget {
  const CreateDonationScreen({super.key});

  @override
  ConsumerState<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends ConsumerState<CreateDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Dayanışma Erzak Paketi');
  final _descController = TextEditingController(
      text: 'Kapalı paketli bakliyat ve gıdalarla hazırlanan yerel destek paketi.');
  final _notesController = TextEditingController();

  String _selectedCenter = 'Kadıköy Aşevi & Gıda Bankası';
  final Set<String> _selectedFoodIds = {};
  bool _isLoading = false;

  final List<String> _centers = [
    'Kadıköy Aşevi & Gıda Bankası',
    'Moda Mahalle Dayanışma Dolabı',
    'Gıda Kurtarma Ağı (GKTD)',
    'Diğer Yerel Aşevi / Öğrenci Evi',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFoodIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen pakete en az 1 adet uygun ürün ekleyin.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final ctrl = ref.read(donationControllerProvider);
      final draftId = await ctrl.createDraft(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        itemIds: _selectedFoodIds.toList(),
        targetCenterName: _selectedCenter,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yeni bağış paketi taslağı başarıyla oluşturuldu.'),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pushReplacement('/donations/drafts/$draftId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paket oluşturulamadı: $e'),
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
    final eligibleAsync = ref.watch(eligibleDonationFoodsProvider);

    return Scaffold(
      appBar: const AppHeader(
        subtitle: 'Yeni Bağış Paketi',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Paket Başlığı *',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Kış Dayanışması Erzak Paketi',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen bir başlık girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text('Açıklama', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Paket içeriği ve hedeflenen ihtiyaç hakkında bilgi.',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Hedef Bağış Noktası',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCenter,
                decoration: const InputDecoration(),
                items: _centers
                    .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCenter = val);
                },
              ),
              const SizedBox(height: 20),

              // Selectable Products
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pakete Eklenecek Ürünler *',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${_selectedFoodIds.length} Ürün Seçildi',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              eligibleAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (err, _) => Text('Hata: $err'),
                data: (eligibleList) {
                  if (eligibleList.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Envanterde henüz bağışa uygun (kapalı ambalajlı ve tarihi geçmemiş) ürün bulunmuyor.',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: eligibleList.map((wrapper) {
                        final food = wrapper.food;
                        final isSelected = _selectedFoodIds.contains(food.id);

                        return CheckboxListTile(
                          activeColor: AppColors.primary,
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedFoodIds.add(food.id);
                              } else {
                                _selectedFoodIds.remove(food.id);
                              }
                            });
                          },
                          title: Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            '${food.quantity.toStringAsFixed(0)} ${food.unit} • ${food.storageLocation.label} (${wrapper.eligibility.statusTag})',
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: const Icon(Icons.check, size: 20),
                  label: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Taslağı Kaydet & Paketi Oluştur',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
