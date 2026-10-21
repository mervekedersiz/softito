import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/credit_card.dart';
import '../widgets/credit_card_widget.dart';

class PaymentCheckoutPage extends StatefulWidget {
  const PaymentCheckoutPage({
    required this.vehicle,
    required this.totalAmountTry,
    this.rentalDays = 1,
    super.key,
  });

  final Vehicle vehicle;
  final int totalAmountTry;
  final int rentalDays;

  @override
  State<PaymentCheckoutPage> createState() => _PaymentCheckoutPageState();
}

class _PaymentCheckoutPageState extends State<PaymentCheckoutPage> {
  final _numberCtrl = TextEditingController(text: '4543 2800 1928 4402');
  final _nameCtrl = TextEditingController(text: 'AHMET YILMAZ');
  final _expiryCtrl = TextEditingController(text: '08/28');
  final _cvvCtrl = TextEditingController(text: '842');

  bool _showBack = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  CreditCardModel get _currentCard => CreditCardModel(
        number: _numberCtrl.text,
        holderName: _nameCtrl.text,
        expiryDate: _expiryCtrl.text,
        cvv: _cvvCtrl.text,
      );

  void _simulateSuccess() {
    final feedback = AppScope.of(context).feedback;
    final currency = AppScope.of(context).currency;
    final nav = Navigator.of(context);

    final convertedPrice = currency.format(widget.totalAmountTry);
    final txnId = 'TXN-YOL-${DateTime.now().millisecondsSinceEpoch % 1000000}';

    showAppStatusDialog(
      context: context,
      status: AppFeedbackStatus.success,
      title: 'Ödeme Onaylandı!',
      message: 'Kiralama bedeli olan $convertedPrice başarıyla tahsil edildi. '
          'Aracınız teslime hazır duruma getirildi.',
      detailCode: txnId,
      primaryButtonLabel: 'Rezervasyonlarıma Git',
      onPrimary: () {
        feedback.postSuccess(
          title: 'Ödeme Başarılı',
          message: '$txnId nolu ödeme tamamlandı. İyi yolculuklar!',
        );
        nav.pop(true);
      },
    );
  }

  void _simulateFailureLimit() {
    final feedback = AppScope.of(context).feedback;
    showAppStatusDialog(
      context: context,
      status: AppFeedbackStatus.failure,
      title: 'Ödeme Reddedildi',
      message: 'Banka kartınızın limiti bu işlem için yetersiz veya yurt dışı / e-ticaret kullanımına kapalı.',
      detailCode: 'ERR_CARD_LIMIT_EXCEEDED',
      secondaryButtonLabel: 'Kapat',
      primaryButtonLabel: 'Farklı Kart Dene',
      onPrimary: () {
        feedback.postFailure(
          title: 'Ödeme Başarısız',
          message: 'Kart limiti yetersiz. Lütfen başka bir ödeme yöntemi seçin.',
          code: 'ERR_LIMIT',
        );
      },
    );
  }

  void _simulateFailureCvv() {
    final feedback = AppScope.of(context).feedback;
    showAppStatusDialog(
      context: context,
      status: AppFeedbackStatus.failure,
      title: 'Güvenlik Kodu Hatası',
      message: 'Girdiğiniz CVV güvenlik kodu veya son kullanma tarihi bankanız tarafından doğrulanamadı.',
      detailCode: 'ERR_INVALID_CVV',
      primaryButtonLabel: 'Tekrar Dene',
      onPrimary: () {
        feedback.postFailure(
          title: 'CVV Doğrulama Hatası',
          message: 'Kartın arkasındaki 3 haneli kodu kontrol ediniz.',
          code: 'ERR_CVV',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currency = AppScope.of(context).currency;

    return Scaffold(
      appBar: AppBar(title: const Text('Kredi Kartı ile Ödeme')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Currency converted rate summary box
                  ListenableBuilder(
                    listenable: currency,
                    builder: (context, _) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.vehicle.brand} ${widget.vehicle.model}',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '${widget.rentalDays} Günlük Kiralama Tutarı',
                                style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                currency.format(widget.totalAmountTry),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colors.primary,
                                ),
                              ),
                              if (currency.selected.code != 'TRY')
                                Text(
                                  'Baz: ₺${widget.totalAmountTry}',
                                  style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Animated Credit Card
                  CreditCardWidget(card: _currentCard, showBack: _showBack),
                  const SizedBox(height: 20),
                  // Form inputs
                  TextFormField(
                    controller: _numberCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Kart Numarası',
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Kart Üzerindeki İsim',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Son Kullanma (AA/YY)',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) => setState(() => _showBack = hasFocus),
                          child: TextFormField(
                            controller: _cvvCtrl,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'CVV Kodu',
                              prefixIcon: Icon(Icons.security),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Action buttons: Success & Failure demonstrations
                  FilledButton.icon(
                    onPressed: _simulateSuccess,
                    icon: const Icon(Icons.verified),
                    label: Text('${currency.format(widget.totalAmountTry)} Öde (Başarılı İşlem)'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _simulateFailureLimit,
                          icon: const Icon(Icons.error_outline, size: 18),
                          label: const Text('Bakiye Hatası Testi'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _simulateFailureCvv,
                          icon: const Icon(Icons.gpp_bad_outlined, size: 18),
                          label: const Text('CVV Hatası Testi'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
