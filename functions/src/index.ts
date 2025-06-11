import admin = require("firebase-admin");
admin.initializeApp();

import {
  invitePerson,
  acceptFriendship,
  declineFriendship,
  removeFriendship,
} from "../friends/onCall";

exports.invitePerson = invitePerson;
exports.acceptFriendship = acceptFriendship;
exports.declineFriendship = declineFriendship;
exports.removeFriendship = removeFriendship;

import {addNewVehicle, editVehicle, removeVehicle} from "../profile/on_call";

exports.addNewVehicle = addNewVehicle;
exports.editVehicle = editVehicle;
exports.removeVehicle = removeVehicle;

import {
  removeUserFromFirestore,
  removeVehiclePhotoOnDelete,
  notifyUserOnInvitation,
} from "../profile/triggered";

exports.removeUserFromFirestore = removeUserFromFirestore;
exports.removeVehiclePhotoOnDelete = removeVehiclePhotoOnDelete;
exports.notifyUserOnInvitation = notifyUserOnInvitation;

import {generateGroupCode, removeGroupPhotoOnDelete} from "../groups/triggered";

exports.generateGroupCode = generateGroupCode;
exports.removeGroupPhotoOnDelete = removeGroupPhotoOnDelete;

import {sendAlertToGroup} from "../groups/notifications";

exports.sendAlertToGroup = sendAlertToGroup;

import {
  createNewGroup,
  joinViaKey,
  leaveGroup,
  inviteToGroup,
  acceptGroupInvitation,
  declineGroupInvitation,
  removeGroupMember,
  removeGroup,
  joinGroup,
} from "../groups/onCall";

exports.createNewGroup = createNewGroup;
exports.joinViaKey = joinViaKey;
exports.leaveGroup = leaveGroup;
exports.inviteToGroup = inviteToGroup;
exports.acceptGroupInvitation = acceptGroupInvitation;
exports.declineGroupInvitation = declineGroupInvitation;
exports.removeGroupMember = removeGroupMember;
exports.removeGroup = removeGroup;
exports.joinGroup = joinGroup;

import {createNewKeys, getAllKeys, checkKey} from "../keys/onCall";

exports.createNewKeys = createNewKeys;
exports.getAllKeys = getAllKeys;
exports.checkKey = checkKey;

import {adminRemoveGroup} from "../remoteAccess/group_access";

exports.adminRemoveGroup = adminRemoveGroup;

import {adminRemoveVehicle} from "../remoteAccess/profile_access";

exports.adminRemoveVehicle = adminRemoveVehicle;

import {adminRemoveFriendship} from "../remoteAccess/friendships_access";

exports.adminRemoveFriendship = adminRemoveFriendship;
