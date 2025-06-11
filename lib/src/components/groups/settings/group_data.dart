import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:route_mates/data/exception.dart';
import 'package:route_mates/data/group.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/profile/group.dart';
import 'package:shimmer/shimmer.dart';

class GroupData extends StatefulWidget {
  const GroupData({super.key, required this.group});

  final AsyncSnapshot<Group?> group;

  @override
  State<GroupData> createState() => _GroupDataState();
}

class _GroupDataState extends State<GroupData> {
  final TextEditingController _controllerName = TextEditingController();
  final FocusNode _groupnameFocusNode = FocusNode();
  final TextEditingController _controllerLocation = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();

  File? _file;

  bool _removePhoto = false;
  bool _public = false;

  String? stage;
  String? errorMessage;

  final nameformKey = GlobalKey<FormState>();
  final locationformKey = GlobalKey<FormState>();

  _photoBox(uid) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: darkGrey,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
            blurRadius: 10,
          )
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          var newfile = await getPhotoFromGallery(1, 1);
          if (newfile != null) {
            setState(() {
              _file = newfile;
            });
          }
        },
        child: FutureBuilder(
          future: DB().getPhotoUrl(folder: DB().groupFolder, uid: uid),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: darkGrey,
                highlightColor: grey2,
                child: Container(
                  width: 120,
                  height: 120,
                  color: darkGrey,
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: darkBg2,
                image: _file != null
                    ? DecorationImage(
                        image: FileImage(_file!),
                        fit: BoxFit.cover,
                      )
                    : _removePhoto
                        ? DecorationImage(
                            image: AssetImage(DB().groupAsset),
                            fit: BoxFit.cover,
                          )
                        : snapshot.data! != ''
                            ? DecorationImage(
                                image:
                                    CachedNetworkImageProvider(snapshot.data!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: AssetImage(DB().groupAsset),
                                fit: BoxFit.cover,
                              ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      color: grey2,
                      size: 28,
                      shadows: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 0),
                          blurRadius: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _updateGroupButton() {
    Future<void> updateGroup() async {
      if (widget.group.data == null) {
        return;
      }
      try {
        setState(() {
          stage = 'WAITING';
          errorMessage = null;
        });

        if (!nameformKey.currentState!.validate() ||
            !locationformKey.currentState!.validate()) {
          throw "";
        }

        final groupSettings = GroupSettings(group: widget.group.data!);

        final name = _controllerName.text.trim();
        await groupSettings.setName(name);

        if (_removePhoto == true) {
          await groupSettings.removePhoto();
        } else if (_file != null) {
          await groupSettings.setPhoto(_file!);
        }

        final location = _controllerLocation.text.trim();
        groupSettings.setLocation(location);

        if (widget.group.data!.public != _public) {
          await Store().updateGroupPublic(
            newPublic: _public,
            groupId: widget.group.data!.uid,
          );
        }

        setState(() {
          stage = 'DONE';
        });

        _file = null;
      } on MyException catch (e) {
        setState(() {
          stage = 'ERROR';
          errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          stage = 'ERROR';
          errorMessage = "error";
        });
      } finally {
        _groupnameFocusNode.unfocus();
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              errorMessage = null;
              stage = null;
            });
          }
        });
      }
    }

    return StageSolidButton(
      borderRadius: 12,
      text: 'Update group',
      buttonColor: orange,
      textColor: darkBg,
      onPressFn: updateGroup,
      height: 40,
      textWeight: FontWeight.bold,
      stage: stage,
      errorMessage: errorMessage,
    );
  }

  publicSwitcher() {
    return Switch(
      inactiveTrackColor: darkGrey2,
      inactiveThumbColor: grey,
      activeColor: orange,
      value: _public,
      onChanged: (public) {
        setState(() {
          _public = public;
        });
      },
    );
  }

  @override
  void initState() {
    var group = widget.group;

    if (group.hasData) {
      _controllerName.text = group.data!.name;
      if (group.data!.location != null) {
        _controllerLocation.text = group.data!.location!;
      }
      _public = group.data!.public;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var group = widget.group;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: darkGrey3,
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Column(
                  children: [
                    if (group.hasData) _photoBox(group.data!.uid),
                    TextButtonWid(
                      onPressFn: () async {
                        if (!_removePhoto) {
                          setState(() {
                            _file = null;
                          });
                        }
                        setState(() {
                          _removePhoto = !_removePhoto;
                        });
                      },
                      text: 'Remove',
                      textColor: blueLink,
                      textWeight: FontWeight.bold,
                      textSize: 16,
                    ),
                  ],
                ),
                Form(
                  key: nameformKey,
                  child: UnderLineTextInputWid(
                    label: 'Group name *',
                    controller: _controllerName,
                    color: grey,
                    secondaryColor: blueLink,
                    validator: usernameValidator,
                    focusNode: _groupnameFocusNode,
                    keyboard: TextInputType.name,
                    alignment: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: locationformKey,
                  child: UnderLineTextInputWid(
                    label: "Location${_public ? "*" : ""}",
                    isPassoword: false,
                    validator: _public ? inputValidator : emptyInputValidator,
                    controller: _controllerLocation,
                    color: grey,
                    secondaryColor: blueLink,
                    focusNode: _locationFocusNode,
                    keyboard: TextInputType.name,
                    alignment: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          CustomText(
            text: "* Required",
            color: grey2,
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 5),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(24),
                  textStyle: TextStyle(
                    fontFamily: Fonts().secondary,
                    color: grey2,
                    fontSize: 16,
                    height: 1.3,
                  ),
                  decoration: BoxDecoration(
                      color: blueLink, borderRadius: BorderRadius.circular(8)),
                  message: PUBLIC_GROUP_TOOLTIP_MESSAGE,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: grey,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CustomText(
                        text: "Visibility: ${_public ? "Public" : "Private"}",
                        size: 16,
                        color: grey,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                publicSwitcher()
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          _updateGroupButton(),
        ],
      ),
    );
  }
}
