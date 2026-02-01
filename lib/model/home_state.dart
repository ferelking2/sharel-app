import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default('') String error,
    @Default(122) int musicCount,
    @Default(0.96) double cleanPercent,
    @Default('624KB nettoyés') String cleanText,
    @Default('50.51GB utilisés') String usedText,
  }) = _HomeState;
}
