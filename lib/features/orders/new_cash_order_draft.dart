import 'new_cash_order_mix_code_screen.dart';
import 'order_project_summary.dart';
import '../../core/uploads/document_picker_service.dart';

/// The in-progress customer order. It is passed through the order wizard and
/// later maps directly to the order-create API payload.
class NewCashOrderDraft {
  const NewCashOrderDraft({
    this.project,
    this.mixCode,
    this.quantity = 0,
    this.scheduledDate,
    this.timeWindow,
    this.timeWindowId,
    this.intervalMinutes = 15,
    this.scheduleNotes = '',
    this.structureRef = 'Slab',
    this.structureTypeId,
    this.technicianRequired = false,
    this.temperatureControl = false,
    this.pumpRequired = false,
    this.pumpName,
    this.pumpType,
    this.pumpSizeFromM,
    this.pumpSizeUpToM,
    this.pumpQuantity = 1,
    this.cubeMould = false,
    this.numMoulds = 0,
    this.labTesting = false,
    this.otherService = false,
    this.siteAccessRequirements = const [],
    this.siteAccessNotes,
    this.siteAttachmentsCount = 0,
    this.accessPhoto,
    this.roadPermit,
  });

  final OrderProjectSummary? project;
  final MixCodeItem? mixCode;
  final int quantity;
  final DateTime? scheduledDate;
  final String? timeWindow;
  final String? timeWindowId;
  final int intervalMinutes;
  final String scheduleNotes;
  final String structureRef;
  final String? structureTypeId;
  final bool technicianRequired;
  final bool temperatureControl;
  final bool pumpRequired;
  final String? pumpName;
  final String? pumpType;
  final double? pumpSizeFromM;
  final double? pumpSizeUpToM;
  final int pumpQuantity;
  final bool cubeMould;
  final int numMoulds;
  final bool labTesting;
  final bool otherService;
  final List<String> siteAccessRequirements;
  final String? siteAccessNotes;
  final int siteAttachmentsCount;
  final SelectedDocument? accessPhoto;
  final SelectedDocument? roadPermit;

  NewCashOrderDraft copyWith({
    OrderProjectSummary? project,
    MixCodeItem? mixCode,
    int? quantity,
    DateTime? scheduledDate,
    String? timeWindow,
    String? timeWindowId,
    int? intervalMinutes,
    String? scheduleNotes,
    String? structureRef,
    String? structureTypeId,
    bool? technicianRequired,
    bool? temperatureControl,
    bool? pumpRequired,
    String? pumpName,
    String? pumpType,
    double? pumpSizeFromM,
    double? pumpSizeUpToM,
    int? pumpQuantity,
    bool? cubeMould,
    int? numMoulds,
    bool? labTesting,
    bool? otherService,
    List<String>? siteAccessRequirements,
    String? siteAccessNotes,
    int? siteAttachmentsCount,
    SelectedDocument? accessPhoto,
    SelectedDocument? roadPermit,
  }) {
    return NewCashOrderDraft(
      project: project ?? this.project,
      mixCode: mixCode ?? this.mixCode,
      quantity: quantity ?? this.quantity,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeWindow: timeWindow ?? this.timeWindow,
      timeWindowId: timeWindowId ?? this.timeWindowId,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      scheduleNotes: scheduleNotes ?? this.scheduleNotes,
      structureRef: structureRef ?? this.structureRef,
      structureTypeId: structureTypeId ?? this.structureTypeId,
      technicianRequired: technicianRequired ?? this.technicianRequired,
      temperatureControl: temperatureControl ?? this.temperatureControl,
      pumpRequired: pumpRequired ?? this.pumpRequired,
      pumpName: pumpName ?? this.pumpName,
      pumpType: pumpType ?? this.pumpType,
      pumpSizeFromM: pumpSizeFromM ?? this.pumpSizeFromM,
      pumpSizeUpToM: pumpSizeUpToM ?? this.pumpSizeUpToM,
      pumpQuantity: pumpQuantity ?? this.pumpQuantity,
      cubeMould: cubeMould ?? this.cubeMould,
      numMoulds: numMoulds ?? this.numMoulds,
      labTesting: labTesting ?? this.labTesting,
      otherService: otherService ?? this.otherService,
      siteAccessRequirements:
          siteAccessRequirements ?? this.siteAccessRequirements,
      siteAccessNotes: siteAccessNotes ?? this.siteAccessNotes,
      siteAttachmentsCount: siteAttachmentsCount ?? this.siteAttachmentsCount,
      accessPhoto: accessPhoto ?? this.accessPhoto,
      roadPermit: roadPermit ?? this.roadPermit,
    );
  }
}
