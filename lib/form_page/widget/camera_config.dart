// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:camera_picker/src/picker_store.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:warehouse/form_page/widget/image_preview.dart';

export 'package:cross_file/cross_file.dart';

const _defaultPreviewHeight = 120.0;
const _defaultPreviewWidth = 80.0;

class CameraPicker extends HookWidget {
  final Function(dynamic error, dynamic stack)? onError;
  final ResolutionPreset resolutionPreset;
  final int? maxPicture;
  final int minPicture;
  final bool showCancelButton;
  final bool showTorchButton;
  final bool showSwitchCameraButton;
  final Color iconColor;
  final double previewHeight;
  final double previewWidth;
  final FutureOr<bool> Function(XFile file)? onDelete;
  final List<XFile>? initialFiles;
  final WidgetBuilder? noCameraBuilder;

  const CameraPicker({
    super.key,
    this.initialFiles,
    this.previewHeight = _defaultPreviewHeight,
    this.previewWidth = _defaultPreviewWidth,
    this.noCameraBuilder,
    this.showSwitchCameraButton = true,
    this.onDelete,
    this.resolutionPreset = ResolutionPreset.high,
    this.iconColor = Colors.white,
    this.showTorchButton = true,
    this.showCancelButton = true,
    this.onError,
    this.maxPicture,
    this.minPicture = 0,
  });

  @override
  Widget build(BuildContext context) {
    final store = useMemoized(() => PickerStore(
          filesData: List.from(initialFiles ?? []),
          minPicture: minPicture,
          maxPicture: maxPicture,
        ));
    final availableCamerasFuture = useMemoized(() => availableCameras());
    final cameras = useState<List<CameraDescription>?>(null);
    final flashMode = useState(FlashMode.off);

    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ColoredBox(
          color: Colors.black,
          child: FutureBuilder<List<CameraDescription>>(
            builder: (context, snapshot) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (snapshot.connectionState == ConnectionState.done) {
                  cameras.value ??= snapshot.data ?? [];
                }
              });

              if (snapshot.connectionState == ConnectionState.waiting ||
                  cameras.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cameras.value!.isEmpty) {
                return noCameraBuilder?.call(context) ??
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No camera available',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back'),
                          ),
                        ],
                      ),
                    );
              }

              return HookBuilder(builder: (context) {
                final cameraControllerState = useState(CameraController(
                  cameras.value!.firstWhereOrNull((element) =>
                          element.lensDirection == CameraLensDirection.back) ??
                      cameras.value!.first,
                  resolutionPreset,
                  enableAudio: false,
                ));
                final isBackCamera = useState(true);
                final cameraController = cameraControllerState.value;
                final initializeCamera = useMemoized(
                    () => cameraController.initialize(), [cameraController]);

                return WillPopScope(
                  onWillPop: () async {
                    cameraController.dispose();
                    return true;
                  },
                  child: FutureBuilder(
                    future: initializeCamera,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width *
                            (4 / 3), // 4:3 aspect ratio
                        child: CameraPreview(
                          cameraController,
                          key: Key(cameraController.description.name),
                          child: SafeArea(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (showTorchButton && isBackCamera.value)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        flashMode.value =
                                            flashMode.value == FlashMode.off
                                                ? FlashMode.torch
                                                : FlashMode.off;

                                        cameraController
                                            .setFlashMode(flashMode.value);
                                      },
                                      icon: Icon(
                                        flashMode.value == FlashMode.off
                                            ? Icons.flashlight_off_outlined
                                            : Icons.flashlight_on,
                                      ),
                                      color: iconColor,
                                    ),
                                  ),
                                if (showSwitchCameraButton &&
                                    cameras.value!.length > 1)
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        if (isBackCamera.value) {
                                          cameraControllerState.value =
                                              CameraController(
                                            cameras.value!.firstWhereOrNull(
                                                  (element) =>
                                                      element.lensDirection ==
                                                      CameraLensDirection.front,
                                                ) ??
                                                cameras.value!.last,
                                            resolutionPreset,
                                            enableAudio: false,
                                          );
                                        } else {
                                          cameraControllerState.value =
                                              CameraController(
                                            cameras.value!.firstWhereOrNull(
                                                  (element) =>
                                                      element.lensDirection ==
                                                      CameraLensDirection.back,
                                                ) ??
                                                cameras.value!.first,
                                            resolutionPreset,
                                            enableAudio: false,
                                          );
                                        }
                                        isBackCamera.value =
                                            !isBackCamera.value;
                                      },
                                      icon: Icon(isBackCamera.value
                                          ? Icons.camera_front_outlined
                                          : Icons.camera_rear_outlined),
                                      color: iconColor,
                                    ),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      HookBuilder(builder: (context) {
                                        useListenable(store);
                                        return ImagesPreview(
                                          files: store.filesData,
                                          iconColor: iconColor,
                                          borderColor: iconColor,
                                          previewWidth: previewWidth,
                                          previewHeight: previewHeight,
                                          onDelete: (index) async {
                                            if (onDelete == null ||
                                                await onDelete!(
                                                    store.filesData[index])) {
                                              store.removeFile(
                                                  store.filesData[index]);
                                            }
                                          },
                                        );
                                      }),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (showCancelButton)
                                            IconButton(
                                              onPressed: () {
                                                cameraController.dispose();
                                                Navigator.of(context).pop();
                                              },
                                              tooltip: MaterialLocalizations.of(
                                                      context)
                                                  .cancelButtonLabel,
                                              color: iconColor,
                                              enableFeedback: true,
                                              icon: const Icon(Icons.close),
                                            ),
                                          IconButton(
                                            onPressed: () async {
                                              try {
                                                await cameraController
                                                    .setFlashMode(
                                                        flashMode.value);
                                                final file =
                                                    await cameraController
                                                        .takePicture();
                                                store.addFile(file);
                                              } catch (ex, stack) {
                                                onError?.call(ex, stack);
                                              }
                                            },
                                            enableFeedback: true,
                                            color: iconColor,
                                            iconSize: 40,
                                            icon: const Icon(
                                              Icons.photo_camera_outlined,
                                            ),
                                          ),
                                          HookBuilder(builder: (context) {
                                            useListenable(store);
                                            return IconButton(
                                              onPressed: store.canContinue
                                                  ? () {
                                                      cameraController
                                                          .dispose();
                                                      Navigator.of(context)
                                                          .pop(store.filesData);
                                                    }
                                                  : null,
                                              enableFeedback: true,
                                              tooltip: MaterialLocalizations.of(
                                                      context)
                                                  .okButtonLabel,
                                              icon: const Icon(Icons.check),
                                              disabledColor: Colors.grey[600],
                                              color: iconColor,
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
            },
            future: availableCamerasFuture,
          ),
        ),
      ),
    );
  }
}
