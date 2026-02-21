import 'package:flutter/material.dart';
import '../models/active_tour_state.dart';
import '../models/tour.dart';
import '../theme/app_theme.dart';

class AudioPlayerBar extends StatelessWidget {
  final ActiveTourState state;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final ValueChanged<double> onSeek;

  const AudioPlayerBar({
    super.key,
    required this.state,
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onPrev,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final poi = state.currentPoi;
    final duration = poi.audioDurationSeconds;
    final position = state.audioPositionSeconds.clamp(0.0, duration);
    final isPlaying = state.playbackState == TourPlaybackState.playing;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 14),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // POI indicator row
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Center(
                        child: Text(
                          '${state.currentPoiIndex + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            poi.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${state.currentPoiIndex + 1} of ${state.tour.pois.length} stops',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    // Audio duration
                    Text(
                      poi.formattedAudioDuration,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.bgSurface,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: position,
                    min: 0,
                    max: duration > 0 ? duration : 1,
                    onChanged: onSeek,
                  ),
                ),

                // Time labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(position),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        _formatTime(duration),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded),
                      iconSize: 36,
                      color: state.hasPrev ? AppColors.textPrimary : AppColors.textMuted,
                      onPressed: state.hasPrev ? onPrev : null,
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: isPlaying ? onPause : onPlay,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      iconSize: 36,
                      color: state.hasNext ? AppColors.textPrimary : AppColors.textMuted,
                      onPressed: state.hasNext ? onNext : null,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(double seconds) {
    final s = seconds.toInt();
    final m = s ~/ 60;
    final rem = s % 60;
    return '$m:${rem.toString().padLeft(2, '0')}';
  }
}

// Mini version for the map overlay
class MiniAudioBar extends StatelessWidget {
  final ActiveTourState state;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onExpand;

  const MiniAudioBar({
    super.key,
    required this.state,
    required this.onPlay,
    required this.onPause,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = state.playbackState == TourPlaybackState.playing;
    final poi = state.currentPoi;

    return GestureDetector(
      onTap: onExpand,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Play button
            GestureDetector(
              onTap: isPlaying ? onPause : onPlay,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    poi.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Mini progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: poi.audioDurationSeconds > 0
                          ? state.audioPositionSeconds / poi.audioDurationSeconds
                          : 0,
                      backgroundColor: AppColors.bgSurface,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_less_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
