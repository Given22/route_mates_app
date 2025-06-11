import 'package:cloud_functions/cloud_functions.dart';

class FBFunctions {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  HttpsCallable invitePerson =
      FirebaseFunctions.instance.httpsCallable('invitePerson');

  HttpsCallable acceptFriendship =
      FirebaseFunctions.instance.httpsCallable('acceptFriendship');

  HttpsCallable declineFriendship =
      FirebaseFunctions.instance.httpsCallable('declineFriendship');

  HttpsCallable removeFriendship =
      FirebaseFunctions.instance.httpsCallable('removeFriendship');

  HttpsCallable addNewVehicle =
      FirebaseFunctions.instance.httpsCallable('addNewVehicle');

  HttpsCallable editVehicle =
      FirebaseFunctions.instance.httpsCallable('editVehicle');

  HttpsCallable removeVehicle =
      FirebaseFunctions.instance.httpsCallable('removeVehicle');

  HttpsCallable createNewGroup =
      FirebaseFunctions.instance.httpsCallable('createNewGroup');

  HttpsCallable joinViaKey =
      FirebaseFunctions.instance.httpsCallable('joinViaKey');

  HttpsCallable leaveGroup =
      FirebaseFunctions.instance.httpsCallable('leaveGroup');

  HttpsCallable inviteToGroup =
      FirebaseFunctions.instance.httpsCallable('inviteToGroup');

  HttpsCallable acceptGroupInvitation =
      FirebaseFunctions.instance.httpsCallable('acceptGroupInvitation');

  HttpsCallable declineGroupInvitation =
      FirebaseFunctions.instance.httpsCallable('declineGroupInvitation');

  HttpsCallable removeGroupMember =
      FirebaseFunctions.instance.httpsCallable('removeGroupMember');

  HttpsCallable removeGroup =
      FirebaseFunctions.instance.httpsCallable('removeGroup');

  HttpsCallable joinGroup =
      FirebaseFunctions.instance.httpsCallable('joinGroup');

  HttpsCallable checkKey = FirebaseFunctions.instance.httpsCallable('checkKey');

  HttpsCallable alertGroup = FirebaseFunctions.instance.httpsCallable('sendAlertToGroup');
}
