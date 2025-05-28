// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_guid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageGuidModel _$ImageGuidModelFromJson(Map<String, dynamic> json) =>
    ImageGuidModel(
      guidIds:
          (json['guidIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ImageGuidModelToJson(ImageGuidModel instance) =>
    <String, dynamic>{
      'guidIds': instance.guidIds,
    };
