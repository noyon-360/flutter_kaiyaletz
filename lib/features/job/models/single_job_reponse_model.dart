import 'package:json_annotation/json_annotation.dart';

import 'job_create_response_model.dart';

part 'single_job_reponse_model.g.dart';

/// Shape of the `data` object for `GET /jobs/:id`.
@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class SingleJobResponseModel {
  @JsonKey(name: '_id', required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String jobRef;

  final String? ownerId;

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

  final String? notes;

  @JsonKey(required: true, disallowNullValue: true)
  final String status;

  @JsonKey(required: true, disallowNullValue: true)
  final int currentStep;

  final RoomCapture? roomCapture;

  final Measurements? measurements;

  final List<dynamic>? selectedProducts;

  final AiLayout? aiLayout;

  final JobDesign? design;

  final Estimate? estimate;

  final Proposal? proposal;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime createdAt;

  final DateTime? updatedAt;

  @JsonKey(name: '__v')
  final int? v;

  const SingleJobResponseModel({
    required this.id,
    required this.jobRef,
    this.ownerId,
    this.assignedTo,
    required this.date,
    required this.customerName,
    required this.propertyAddress,
    required this.phoneNumber,
    required this.emailAddress,
    this.notes,
    required this.status,
    required this.currentStep,
    this.roomCapture,
    this.measurements,
    this.selectedProducts,
    this.aiLayout,
    this.design,
    this.estimate,
    this.proposal,
    required this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SingleJobResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SingleJobResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SingleJobResponseModelToJson(this);
}
