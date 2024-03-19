part of 'dashboard_stats_bloc.dart';

@immutable
abstract class DashboardStatsState {}

class DashboardStatsLoading extends DashboardStatsState {}

class DashboardStatsLoaded extends DashboardStatsState {
  final Map stats;

  DashboardStatsLoaded(this.stats);
}

class DashboardStatsEmpty extends DashboardStatsState {}
