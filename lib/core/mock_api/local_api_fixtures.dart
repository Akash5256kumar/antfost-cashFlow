import '../../features/orders/domain/entities/new_cash_order_request.dart';

/// API-shaped local fixtures. Field names match current_screen_api_map.csv.
class LocalApiFixtures {
  const LocalApiFixtures._();

  static const projectsResponse = {
    'items': [
      {
        'id': 'project-abu-dhabi-001',
        'name': 'Al Reef Villas - Phase 2',
        'location': 'Al Reef Villas, Abu Dhabi',
        'description': 'Block A foundation works',
      },
      {
        'id': 'project-dubai-002',
        'name': 'Dubai Marina Tower',
        'location': 'Dubai Marina, Dubai',
        'description': 'Block B columns',
      },
    ],
    'page': 1,
    'pageSize': 20,
    'total': 2,
  };

  static const savedLocationsResponse = {
    'items': [
      {
        'id': 'location-abu-dhabi-main-gate',
        'projectId': 'project-abu-dhabi-001',
        'name': 'Main Villa Entrance',
        'address': 'Al Reef Villas, Abu Dhabi',
        'latitude': 24.48862,
        'longitude': 54.38652,
        'contactName': 'Ahmed Khalid',
        'contactPhone': '+971 50 123 4567',
        'isDefault': true,
      },
    ],
  };

  static const mixCodesResponse = {
    'items': [
      {'code': 'C25/30', 'type': 'Foundations', 'pricePerM3': 450.0},
      {'code': 'C30/37', 'type': 'General Structural', 'pricePerM3': 520.0},
      {'code': 'C40/50', 'type': 'High Strength', 'pricePerM3': 590.0},
    ],
  };

  static Map<String, dynamic> deliveryTimeWindowsResponse(String date) => {
    'date': date,
    'items': const [
      {'id': 'morning', 'label': 'Morning', 'start': '06:00', 'end': '12:00'},
      {'id': 'midday', 'label': 'Midday', 'start': '12:00', 'end': '16:00'},
      {
        'id': 'afternoon',
        'label': 'Afternoon',
        'start': '16:00',
        'end': '00:00',
      },
      {
        'id': 'early-night',
        'label': 'Early Night',
        'start': '00:00',
        'end': '06:00',
      },
    ],
  };

  static const walletBalanceResponse = {
    'availableTokenM3': 854.5,
    'reservedTokenM3': 75.5,
    'totalTokenM3': 930.0,
    'estimatedValueAed': 153450.0,
  };

  static const walletTransactionsResponse = {
    'items': [
      {
        'id': 'wallet-tx-001',
        'type': 'deposit',
        'name': 'Wallet Deposit',
        'amount': 41250.0,
        'is_credit': true,
        'status': 'completed',
        'date': '2026-02-09T10:00:00Z',
      },
      {
        'id': 'wallet-tx-002',
        'type': 'reserved',
        'name': 'Order Payment Reserved',
        'subtitle': 'AF-2026-02-000234',
        'amount': 12457.5,
        'is_credit': false,
        'status': 'reserved',
        'date': '2026-02-08T14:30:00Z',
      },
    ],
    'page': 1,
    'pageSize': 20,
    'total': 2,
  };

  static const invoicesResponse = {
    'items': [
      {
        'id': 'invoice-001',
        'orderId': 'order-001',
        'totalAmount': 22785.0,
        'date': '2026-02-09T10:00:00Z',
        'types': ['vat'],
        'status': 'paid',
      },
    ],
    'page': 1,
    'pageSize': 20,
    'total': 1,
  };

  static Map<String, dynamic> createDraftOrder(NewCashOrderRequest request) {
    final mixes = mixCodesResponse['items'] as List<Map<String, Object>>;
    final mix = mixes.firstWhere(
      (item) => item['code'] == request.mixCode,
      orElse: () => {'code': request.mixCode, 'pricePerM3': 0.0},
    );
    final concrete = (mix['pricePerM3'] as num).toDouble() * request.quantity;
    final pump = request.pumpRequired ? 600.0 : 0.0;
    final technician = request.technicianRequired ? 350.0 : 0.0;
    final subtotal = concrete + pump + technician;
    final vat = subtotal * 0.05;
    final orderId = 'order-local-${DateTime.now().microsecondsSinceEpoch}';
    return {
      'orderId': orderId,
      'orderReference': 'AF-LOCAL-${orderId.substring(orderId.length - 6)}',
      'status': 'draft',
      'grade': request.mixCode,
      'location': request.projectId,
      'timeSlot': request.timeSlot,
      'volume': '${request.quantity} m³',
      'date': request.scheduledDate.toIso8601String(),
      'amount': subtotal + vat,
      'delivered': 0,
      'total': request.quantity.round(),
      'priceBreakdown': {
        'concrete': concrete,
        'concretePump': pump,
        'technicianAnd6CubeMoulds': technician,
        'paymentMethodCharge': 0.0,
        'subtotal': subtotal,
        'vat': vat,
        'total': subtotal + vat,
        'currency': 'AED',
      },
      'payment': {
        'canProceed': true,
        'requiredAmount': subtotal + vat,
        'currency': 'AED',
        'kycRequired': true,
      },
    };
  }
}
