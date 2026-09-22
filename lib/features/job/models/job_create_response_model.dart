import 'package:json_annotation/json_annotation.dart';

part 'job_create_response_model.g.dart';



@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class JobModel {
  @JsonKey(name: '_id', required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String jobRef;

  @JsonKey(required: true, disallowNullValue: true)
  final String ownerId;

  /// Unassigned until a team member is set, so this legitimately accepts null.
  final String? assignedTo;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime date;

  @JsonKey(required: true, disallowNullValue: true)
  final String customerName;

  @JsonKey(required: true, disallowNullValue: true)
  final String propertyAddress;

  @JsonKey(required: true, disallowNullValue: true)
  final String phoneNumber;

  @JsonKey(required: true, disallowNullValue: true)
  final String emailAddress;

  @JsonKey(required: true, disallowNullValue: true)
  final String notes;

  @JsonKey(required: true, disallowNullValue: true)
  final String status;

  @JsonKey(required: true, disallowNullValue: true)
  final int currentStep;

  @JsonKey(required: true, disallowNullValue: true)
  final RoomCapture roomCapture;

  @JsonKey(required: true, disallowNullValue: true)
  final Measurements measurements;

  @JsonKey(required: true, disallowNullValue: true)
  final List<dynamic> selectedProducts;

  @JsonKey(required: true, disallowNullValue: true)
  final AiLayout aiLayout;

  @JsonKey(required: true, disallowNullValue: true)
  final JobDesign design;

  @JsonKey(required: true, disallowNullValue: true)
  final Estimate estimate;

  @JsonKey(required: true, disallowNullValue: true)
  final Proposal proposal;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime createdAt;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime updatedAt;

  @JsonKey(name: '__v', required: true, disallowNullValue: true)
  final int v;

  const JobModel({
    required this.id,
    required this.jobRef,
    required this.ownerId,
    this.assignedTo,
    required this.date,
    required this.customerName,
    required this.propertyAddress,
    required this.phoneNumber,
    required this.emailAddress,
    required this.notes,
    required this.status,
    required this.currentStep,
    required this.roomCapture,
    required this.measurements,
    required this.selectedProducts,
    required this.aiLayout,
    required this.design,
    required this.estimate,
    required this.proposal,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobModelToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class RoomCapture {
  final String? method;

  final DateTime? capturedAt;

  const RoomCapture({this.method, this.capturedAt});

  factory RoomCapture.fromJson(Map<String, dynamic> json) =>
      _$RoomCaptureFromJson(json);

  Map<String, dynamic> toJson() => _$RoomCaptureToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class Measurements {
  final double? width;

  final double? depth;

  final double? height;

  const Measurements({this.width, this.depth, this.height});

  factory Measurements.fromJson(Map<String, dynamic> json) =>
      _$MeasurementsFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementsToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class AiLayout {
  final String? status;

  final DateTime? generatedAt;

  final dynamic layoutData;

  const AiLayout({this.status, this.generatedAt, this.layoutData});

  factory AiLayout.fromJson(Map<String, dynamic> json) =>
      _$AiLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$AiLayoutToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class JobDesign {
  @JsonKey(required: true, disallowNullValue: true)
  final LayoutImage layoutImage;

  @JsonKey(required: true, disallowNullValue: true)
  final String layoutName;

  const JobDesign({required this.layoutImage, required this.layoutName});

  factory JobDesign.fromJson(Map<String, dynamic> json) =>
      _$JobDesignFromJson(json);

  Map<String, dynamic> toJson() => _$JobDesignToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class LayoutImage {
  @JsonKey(name: 'public_id', required: true, disallowNullValue: true)
  final String publicId;

  @JsonKey(required: true, disallowNullValue: true)
  final String url;

  const LayoutImage({required this.publicId, required this.url});

  factory LayoutImage.fromJson(Map<String, dynamic> json) =>
      _$LayoutImageFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutImageToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class Estimate {
  @JsonKey(required: true, disallowNullValue: true)
  final double subTotal;

  @JsonKey(required: true, disallowNullValue: true)
  final double installationCharge;

  @JsonKey(required: true, disallowNullValue: true)
  final double deliveryCharge;

  @JsonKey(required: true, disallowNullValue: true)
  final double taxRate;

  @JsonKey(required: true, disallowNullValue: true)
  final double taxAmount;

  @JsonKey(required: true, disallowNullValue: true)
  final double total;

  const Estimate({
    required this.subTotal,
    required this.installationCharge,
    required this.deliveryCharge,
    required this.taxRate,
    required this.taxAmount,
    required this.total,
  });

  factory Estimate.fromJson(Map<String, dynamic> json) =>
      _$EstimateFromJson(json);

  Map<String, dynamic> toJson() => _$EstimateToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class Proposal {
  final DateTime? generatedAt;

  @JsonKey(required: true, disallowNullValue: true)
  final String pdfUrl;

  @JsonKey(required: true, disallowNullValue: true)
  final String terms;

  const Proposal({this.generatedAt, required this.pdfUrl, required this.terms});

  factory Proposal.fromJson(Map<String, dynamic> json) =>
      _$ProposalFromJson(json);

  Map<String, dynamic> toJson() => _$ProposalToJson(this);
}
