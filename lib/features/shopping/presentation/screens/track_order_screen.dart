import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/services/url_launcher_service.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_event.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_state.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_view_model.dart';
import 'package:flower_app/features/shopping/presentation/widgets/buyer_live_map_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

const double _carImageHeight = 160;
const double _contactButtonSize = 40;
const double _contactIconSize = 25;
const String _estimatedTimePattern = 'HH:mm';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TrackOrderViewModel>()..add(StartListeningEvent(orderId)),
      child: _TrackOrderView(orderId: orderId),
    );
  }
}

class _TrackOrderView extends StatelessWidget {
  const _TrackOrderView({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(AppStrings.trackOrderTitle),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TrackOrderViewModel, TrackOrderState>(
            listenWhen: (prev, curr) =>
                prev.confirmDeliveryState != curr.confirmDeliveryState,
            listener: (context, state) {
              final confirm = state.confirmDeliveryState;
              if (confirm.isLoading) return;
              if (confirm.msg != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(confirm.msg!),
                    backgroundColor: AppColors.red,
                  ),
                );
                return;
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutesName.orderSuccess,
                (route) => false,
              );
            },
          ),
        ],
        child: BlocBuilder<TrackOrderViewModel, TrackOrderState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.pink),
              );
            }
            return _TrackOrderBody(orderId: orderId, state: state);
          },
        ),
      ),
    );
  }
}


class _TrackOrderBody extends StatelessWidget {
  const _TrackOrderBody({required this.orderId, required this.state});

  final String orderId;
  final TrackOrderState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EstimatedArrivalCard(),
          const SizedBox(height: 16),
          _DriverCard(
            driverName: state.driverName,
            driverPhone: state.driverPhone,
          ),
          const SizedBox(height: 16),
          Center(
            child: Image.asset(Assets.assetsImagesCar, height: _carImageHeight),
          ),
          const SizedBox(height: 24),
          _OrderTimeline(stepsCompleted: state.stepsCompleted),
          const SizedBox(height: 24),
          _BottomSection(orderId: orderId, state: state),
        ],
      ),
    );
  }
}

class _EstimatedArrivalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.estimatedArrival,
            style: TextStyles.bodyRegular12.copyWith(color: AppColors.gray),
          ),
          const SizedBox(height: 4),
          Text(
            _estimatedTime(),
            style: TextStyles.bodyRegular16.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _estimatedTime() {
    final now = DateTime.now().add(const Duration(minutes: 30));
    return DateFormat(_estimatedTimePattern).format(now);
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driverName, required this.driverPhone});

  final String driverName;
  final String driverPhone;

  @override
  Widget build(BuildContext context) {
    final urlLauncher = getIt<UrlLauncherService>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.pink.withAlpha(30),
            child: SvgPicture.asset(
              Assets.assetsIconsDeliveryBoy,
              width: 28,
              height: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName.isEmpty
                      ? AppStrings.driverPlaceholder
                      : driverName,
                  style: TextStyles.bodyRegular16.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.deliveryHeroText,
                  style: TextStyles.bodyRegular12.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _ContactIconButton(
                assetPath: Assets.assetsIconsPhoneCall,
                semanticsLabel: AppStrings.callLabel,
                onTap: () => urlLauncher.call(driverPhone),
              ),
              const SizedBox(width: 8),
              _ContactIconButton(
                assetPath: Assets.assetsIconsWhatsapp,
                semanticsLabel: AppStrings.whatsappLabel,
                onTap: () => urlLauncher.whatsApp(driverPhone),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactIconButton extends StatelessWidget {
  const _ContactIconButton({
    required this.assetPath,
    required this.semanticsLabel,
    required this.onTap,
  });

  final String assetPath;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: _contactButtonSize,
          height: _contactButtonSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              width: _contactIconSize,
              height: _contactIconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.stepsCompleted});

  final int stepsCompleted;

  List<String> get _steps => [
    AppStrings.receivedYourOrder,
    AppStrings.preparingYourOrder,
    AppStrings.outForDelivery,
    AppStrings.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final stepNumber = i + 1;
        final isDone = stepNumber <= stepsCompleted;
        final isLast = i == steps.length - 1;
        return _TimelineItem(label: steps[i], isDone: isDone, isLast: isLast);
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.label,
    required this.isDone,
    required this.isLast,
  });

  final String label;
  final bool isDone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? AppColors.pink : Colors.transparent,
                    border: isDone
                        ? null
                        : Border.all(color: AppColors.gray, width: 2),
                  ),
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDone ? AppColors.pink : AppColors.gray,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              label,
              style: TextStyles.bodyRegular14.copyWith(
                color: isDone ? AppColors.black : AppColors.gray,
                fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({required this.orderId, required this.state});

  final String orderId;
  final TrackOrderState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.stepsCompleted >= 4)
          state.userConfirmed
              ? Center(
                  child: Text(
                    AppStrings.orderConfirmed,
                    style: TextStyles.bodyRegular16.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _confirmDelivery(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(AppStrings.orderDelivered),
                  ),
                ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: state.stepsCompleted == 3 ? () => _openMap(context) : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: state.stepsCompleted == 3
                    ? AppColors.pink
                    : AppColors.gray,
              ),
              foregroundColor: state.stepsCompleted == 3
                  ? AppColors.pink
                  : AppColors.gray,
            ),
            child: Text(AppStrings.showMap),
          ),
        ),
      ],
    );
  }

  void _openMap(BuildContext context) {
    final mapHeight = MediaQuery.sizeOf(context).height * 0.85;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: mapHeight,
        child: BuyerLiveMapSheet(orderId: orderId),
      ),
    );
  }

  void _confirmDelivery(BuildContext context) {
    AppDialog.show(
      context: context,
      title: AppStrings.confirmDeliveryTitle,
      description: AppStrings.confirmDeliveryDescription,
      confirmText: AppStrings.yes,
      cancelText: AppStrings.no,
      onConfirm: () {
        context.read<TrackOrderViewModel>().add(ConfirmDeliveryEvent(orderId));
      },
    );
  }
}
