const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.disableUserOnCreate = functions.auth.user().onCreate(async (user) => {
  try {
    await admin.auth().updateUser(user.uid, {disabled: true});
    console.log(`Successfully disabled user: ${user.uid}`);
  } catch (error) {
    console.log(`Error disabling user: ${error}`);
  }
});
