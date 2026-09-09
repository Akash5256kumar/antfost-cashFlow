import 'new_cash_order_mix_code_screen.dart';
import 'order_project_summary.dart';

/// The in-progress customer order. It is passed through the order wizard and
/// later maps directly to the order-create API payload.
class NewCashOrderDraft {
  const NewCashOrderDraft({
    this.project,
    this.mixCode,
    this.quantity = 0,
    this.scheduledDate,
    this.timeWindow,
    this.intervalMinutes = 15,
    this.scheduleNotes = '',
    this.structureRef = 'Slab',
    this.technicianRequired = false,
    this.temperatureControl = false,
    this.pumpRequired = false,
    this.pumpName,
    this.cubeMould = false,
    this.numMoulds = 0,
    this.labTesting = false,
    this.otherService = false,
    this.siteAccessRequirements = const [],
    this.siteAccessNotes,
    this.siteAttachmentsCount = 0,
  });

  final OrderProjectSummary? project;
  final MixCodeItem? mixCode;
  final int quantity;
  final DateTime? scheduledDate;
  final String? timeWindow;
  final int intervalMinutes;
  final String scheduleNotes;
  final String structureRef;
  final bool technicianRequired;
  final bool temperatureControl;
  final bool pumpRequired;
  final String? pumpName;
  final bool cubeMould;
  final int numMoulds;
  final bool labTesting;
  final bool otherService;
  final List<String> siteAccessRequirements;
  final String? siteAccessNotes;
  final int siteAttachmentsCount;

  NewCashOrderDraft copyWith({
    OrderProjectSummary? project,
    MixCodeItem? mixCode,
    int? quantity,
    DateTime? scheduledDate,
    String? timeWindow,
    int? intervalMinutes,
    String? scheduleNotes,
    String? structureRef,
    bool? technicianRequired,
    bool? temperatureControl,
    bool? pumpRequired,
    String? pumpName,
    bool? cubeMould,
    int? numMoulds,
    bool? labTesting,
    bool? otherService,
    List<String>? siteAccessRequirements,
    String? siteAccessNotes,
    int? siteAttachmentsCount,
  }) {
    return NewCashOrderDraft(
      project: project ?? this.project,
      mixCode: mixCode ?? this.mixCode,
      quantity: quantity ?? this.quantity,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeWindow: timeWindow ?? this.timeWindow,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      scheduleNotes: scheduleNotes ?? this.scheduleNotes,
      structureRef: structureRef ?? this.structureRef,
      technicianRequired: technicianRequired ?? this.technicianRequired,
      temperatureControl: temperatureControl ?? this.temperatureControl,
      pumpRequired: pumpRequired ?? this.pumpRequired,
      pumpName: pumpName ?? this.pumpName,
      cubeMould: cubeMould ?? this.cubeMould,
      numMoulds: numMoulds ?? this.numMoulds,
      labTesting: labTesting ?? this.labTesting,
      otherService: otherService ?? this.otherService,
      siteAccessRequirements:
          siteAccessRequirements ?? this.siteAccessRequirements,
      siteAccessNotes: siteAccessNotes ?? this.siteAccessNotes,
      siteAttachmentsCount: siteAttachmentsCount ?? this.siteAttachmentsCount,
    );
  }
}
