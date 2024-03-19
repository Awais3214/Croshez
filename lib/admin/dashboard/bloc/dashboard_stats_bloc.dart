import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_stats_event.dart';
part 'dashboard_stats_state.dart';

class DashboardStatsBloc
    extends Bloc<DashboardStatsEvent, DashboardStatsState> {
  DashboardStatsBloc() : super(DashboardStatsLoading()) {
    on<DashboardLoading>((event, emit) {});

    on<DashboardLoaded>((event, emit) {
      emit(DashboardStatsLoaded(event.stats));
    });

    // on<DashboardLoaded>((event, emit) {
    //   emit(DashboardStatsLoaded(event.stats));
    // });
  }
}
