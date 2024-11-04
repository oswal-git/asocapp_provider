import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/controllers/auth/profile/profile_controller.dart';
import 'package:asocapp/app/models/models.dart';
import 'package:asocapp/app/resources/resources.dart';
import 'package:asocapp/app/translations/language_model.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:asocapp/app/widgets/widgets.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController profileController;

  BuildContext? _context;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController =
          Provider.of<ProfileController>(context, listen: false);

      profileController.isLogin();
      profileController.setImageWidget(null);
    });
  }

  @override
  void dispose() {
    profileController.clearAsociations();
    profileController.userConnected =
        profileController.userConnectedLast.clone();

    profileController.onClose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EglAppBar(
        showBackArrow: true,
        title: 'tUserProfile'.tr,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                20.ph,
                profileController.userConnectedLast.userNameUser == '' ||
                        profileController.userConnectedLast
                                .timeNotificationsUser ==
                            0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          200.ph,
                          const Center(
                            child: CircularProgressIndicator(
                              strokeAlign: 5,
                            ),
                          ),
                        ],
                      )
                    : Form(
                        key: profileController.formKey,
                        autovalidateMode: AutovalidateMode
                            .onUserInteraction, // Habilita la validación cuando el usuario interactúa con el formulario
                        onChanged: () {},
                        child: _formUI(context, profileController),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUI(BuildContext context, ProfileController profileController) {
    _context = context;

    List<dynamic> listTimes = TimesNotification.getListTimes();
    List<dynamic> listLanguages = Language.getLanguageList();
    List<Map<String, dynamic>> optionsGetImage = [
      {
        'option': 'camera',
        'texto': 'Camara',
        'icon': Icons.camera_alt_outlined
      },
      {'option': 'gallery', 'texto': 'Galería', 'icon': Icons.browse_gallery}
    ];

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              EglHelper.showMultChoiceDialog(
                optionsGetImage,
                'tQuestions'.tr,
                context: context,
                onChanged: (value) async {
                  profileController.pickImage(value);
                  Get.back();
                },
              );

              //   else {
              //     profileController.setImageWidget('');
              //   }
            },
            child: SizedBox(
              width: 250.0,
              height: 250.0,
              child: profileController.imageWidget,
            ),
          ),
          40.ph,
          EglAsociationsDropdown(
            labelText: 'lAsociation'.tr,
            hintText: 'hSelectAsociation'.tr,
            focusNode: profileController.asociationsFocusNode,
            future: profileController.refreshAsociationsList(),
            currentValue:
                profileController.userConnected.idAsociationUser == 0
                    ? ''
                    : profileController.userConnected.idAsociationUser
                        .toString(),
            onChanged: (onChangedVal) {
              profileController.userConnected.idAsociationUser =
                  int.parse(onChangedVal);
              //   Utils.eglLogger('i', 'Asociation id: $onChangedVal');
              profileController.checkIsFormValid();
            },
            onValidate: (onValidateVal) {
              if (onValidateVal == null) {
                return 'Please Select Asociation';
              }

              return null;
            },
          ),
          20.ph,
          // const EglInputLabelText(label: "User name", fontSize: 14),
          20.ph,
          EglInputTextField(
            focusNode: profileController.userNameFocusNode,
            nextFocusNode: profileController.timeNotificationsFocusNode,
            currentValue: profileController.userConnected.userNameUser,
            iconLabel: Icons.person_pin,
            // ronudIconBorder: true,
            labelText: 'lUserName'.tr,
            hintText: 'hUserName'.tr,
            // icon: Icons.person_pin,
            onChanged: (value) {
              profileController.userConnected.userNameUser = value;
              profileController.checkIsFormValid();
            },
            onValidator: (value) {
              if (value!.isEmpty) return 'Introduzca su nombre de usuario';
              if (value.length < 4) {
                return 'El nombre de usuario ha de tener 4 carácteres como mínimo ';
              }
              return null;
            },
          ),
          20.ph,
          EglDropdownList(
            context: context,
            labelText: 'lLanguage'.tr,
            hintText: 'hChooseLanguage'.tr,
            contentPaddingLeft: 20,
            focusNode: profileController.languageUserFocusNode,
            nextFocusNode: null,
            lstData: listLanguages,
            value: profileController.userConnectedLast.languageUser,
            // == 0
            //     ? '0'
            //     : userConnectedLast.timeNotificationsUser.toString(),
            onChanged: (onChangedVal) {
              profileController.userConnected.languageUser = onChangedVal;
              profileController.checkIsFormValid();
            },
            onValidate: (onValidateVal) {
              if (onValidateVal == null) {
                return 'iSelectIdioma'.tr;
              }
              return null;
            },
            borderFocusColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            paddingTop: 0,
            paddingLeft: 0,
            paddingRight: 0,
            paddingBottom: 0,
            borderRadius: 10,
            optionValue: "id",
            optionLabel: "name",
            iconLabel: Icons.language_outlined,
          ),
          40.ph,
          EglDropdownList(
            context: context,
            labelText: 'lIntervalNotification'.tr,
            hintText: 'hIntIntervalNotification'.tr,
            contentPaddingLeft: 20,
            focusNode: profileController.timeNotificationsFocusNode,
            nextFocusNode: null,
            lstData: listTimes,
            value: profileController
                .userConnectedLast.timeNotificationsUser
                .toString(),
            // == 0
            //     ? '0'
            //     : userConnectedLast.timeNotificationsUser.toString(),
            onChanged: (onChangedVal) {
              profileController.userConnected.timeNotificationsUser =
                  int.parse(onChangedVal);

              //   Utils.eglLogger('w', 'timeNotifications: $onChangedVal');
              profileController.checkIsFormValid();
            },
            onValidate: (onValidateVal) {
              if (onValidateVal == null) {
                return 'Please Select Interval';
              }

              return null;
            },
            borderFocusColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            paddingTop: 0,
            paddingLeft: 0,
            paddingRight: 0,
            paddingBottom: 0,
            borderRadius: 10,
            optionValue: "id",
            optionLabel: "name",
            iconLabel: Icons.watch_later_outlined,
          ),
          40.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: profileController.isFormValid
                ? EglRoundButton(
                    title: 'bProfile'.tr,
                    loading: profileController.loading,
                    onPress: () async {
                      if (profileController.formKey.currentState!.validate()) {
                        if (profileController
                                    .userConnected.idAsociationUser !=
                                profileController
                                    .userConnectedLast.idAsociationUser ||
                            profileController
                                    .userConnected.userNameUser !=
                                profileController
                                    .userConnectedLast.userNameUser ||
                            profileController.userConnected
                                    .timeNotificationsUser !=
                                profileController.userConnectedLast
                                    .timeNotificationsUser ||
                            profileController.imageAvatar != null ||
                            profileController
                                    .userConnected.languageUser !=
                                profileController
                                    .userConnectedLast.languageUser) {
                          HttpResult<UserAsocResponse>? httpResult;
                          if (profileController.imageAvatar != null) {
                            httpResult =
                                await profileController.updateProfileAvatar(
                                    profileController
                                        .userConnected.idUser,
                                    profileController
                                        .userConnected.userNameUser,
                                    profileController
                                        .userConnected.idAsociationUser,
                                    profileController.userConnected
                                        .timeNotificationsUser,
                                    profileController
                                        .userConnected.languageUser,
                                    profileController.imageAvatar!,
                                    profileController
                                        .userConnected.dateUpdatedUser);
                          } else {
                            httpResult = await profileController.updateProfile(
                                profileController.userConnected.idUser,
                                profileController
                                    .userConnected.userNameUser,
                                profileController
                                    .userConnected.idAsociationUser,
                                profileController
                                    .userConnected.timeNotificationsUser,
                                profileController
                                    .userConnected.languageUser,
                                profileController
                                    .userConnected.dateUpdatedUser);
                          }

                          if (httpResult!.statusCode == 200) {
                            if (httpResult.data != null) {
                              //   Utils.eglLogger('i', 'userapp: ${httpResult.data.toString()}');
                              final UserConnected userConnected = UserConnected(
                                idUser:
                                    httpResult.data!.result!.dataUser.idUser,
                                idAsociationUser: httpResult
                                    .data!.result!.dataUser.idAsociationUser,
                                userNameUser: httpResult
                                    .data!.result!.dataUser.userNameUser,
                                emailUser:
                                    httpResult.data!.result!.dataUser.emailUser,
                                recoverPasswordUser: httpResult
                                    .data!.result!.dataUser.recoverPasswordUser,
                                tokenUser:
                                    httpResult.data!.result!.dataUser.tokenUser,
                                tokenExpUser: httpResult
                                    .data!.result!.dataUser.tokenExpUser,
                                profileUser: httpResult
                                    .data!.result!.dataUser.profileUser,
                                statusUser: httpResult
                                    .data!.result!.dataUser.statusUser,
                                nameUser:
                                    httpResult.data!.result!.dataUser.nameUser,
                                lastNameUser: httpResult
                                    .data!.result!.dataUser.lastNameUser,
                                avatarUser: httpResult
                                    .data!.result!.dataUser.avatarUser,
                                phoneUser:
                                    httpResult.data!.result!.dataUser.phoneUser,
                                dateDeletedUser: httpResult
                                    .data!.result!.dataUser.dateDeletedUser,
                                dateCreatedUser: httpResult
                                    .data!.result!.dataUser.dateCreatedUser,
                                dateUpdatedUser: httpResult
                                    .data!.result!.dataUser.dateUpdatedUser,
                                idAsocAdmin: profileController.setIdAsocAdmin(
                                  httpResult.data!.result!.dataUser.profileUser,
                                  httpResult
                                      .data!.result!.dataAsoc.idAsociation,
                                ),
                                longNameAsoc: httpResult
                                    .data!.result!.dataAsoc.longNameAsociation,
                                shortNameAsoc: httpResult
                                    .data!.result!.dataAsoc.shortNameAsociation,
                                timeNotificationsUser: httpResult.data!.result!
                                    .dataUser.timeNotificationsUser,
                                languageUser: httpResult
                                    .data!.result!.dataUser.languageUser,
                              );

                              await profileController.updateUserConnected(
                                userConnected,
                                profileController.userConnected
                                        .timeNotificationsUser !=
                                    profileController.userConnectedLast
                                        .timeNotificationsUser,
                              );

                              //   AppLocale locale = Utils.getAppLocale(httpResult.data!.result!.dataUser.languageUser);
                              String language = profileController
                                  .userConnected.languageUser;
                              String country =
                                  EglHelper.getAppCountryLocale(language);

                              var locale = Locale(language, country);
                              Get.updateLocale(locale);
                              Intl.defaultLocale = country == ''
                                  ? language
                                  : '${language}_$country';
                              // userConnectedIni = profileController.userConnected.clone();
                              profileController.userConnectedLast =
                                  profileController.userConnected.clone();
                              profileController.checkIsFormValid();
                              EglHelper.popMessage(
                                  _context!,
                                  MessageType.info,
                                  'Usuario actualizado',
                                  profileController
                                      .userConnected.userNameUser);
                              //   'EglRoundButton: userConnected: ${profileController.userConnected}');
                              //   Navigator.pushNamed(_context!, RouteName.dashboard);
                              // setState(() {});
                              return;
                            } else {
                              EglHelper.toastMessage(
                                  httpResult.error.toString());
                              return;
                            }
                          } else if (httpResult.statusCode == 404) {
                            EglHelper.popMessage(
                                //   _context!, MessageType.info, 'Actualización no realizada', 'No se han podido actualizar los datos del usuario');
                                _context!,
                                MessageType.info,
                                '${'mUnexpectedError'.tr}.',
                                '${'mNoScriptAvailable'.tr}.');
                            EglHelper.eglLogger('e', httpResult.error?.data);
                            return;
                          }
                          EglHelper.popMessage(
                              //   _context!, MessageType.info, 'Actualización no realizada', 'No se han podido actualizar los datos del usuario');
                              _context!,
                              MessageType.info,
                              '${'mNoUpdateProfile'.tr}.',
                              httpResult.error?.data);
                          return;
                        } else {
                          EglHelper.popMessage(_context!, MessageType.info,
                              'No han habido cambios', 'Nada para modificar');
                          return;
                          // Utils.eglLogger('i', 'EglRoundButton: userConnected: ${profileController.userConnected}');
                        }
                      }
                      EglHelper.popMessage(
                          context,
                          MessageType.info,
                          'Faltan campos por rellenar',
                          'No se ha podido modificar el perfil del usuario');
                      //   Helper.toastMessage(title: 'Error al modificar el perfil', content: const Text('No se ha podido modificar el perfil del usuario'));
                    },
                  )
                : const SizedBox(
                    height: 50,
                    width: double.infinity,
                  ),
          ),
        ],
      ),
    );
  }
}
