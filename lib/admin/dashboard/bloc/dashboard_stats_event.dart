part of 'dashboard_stats_bloc.dart';

@immutable
abstract class DashboardStatsEvent {}

class DashboardLoading extends DashboardStatsEvent {}

class DashboardLoaded extends DashboardStatsEvent {
  final Map stats;

  DashboardLoaded(this.stats);
}
