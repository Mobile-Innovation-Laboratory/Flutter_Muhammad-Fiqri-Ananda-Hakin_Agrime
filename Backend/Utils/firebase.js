const admin = require("firebase-admin");
const serviceAccount = require("../Utils/agrime-f4e39-firebase-adminsdk-fbsvc-b9fbda465e.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://agrime-f4e39.firebaseio.com",
});
const db = admin.firestore();
const auth = admin.auth();

module.exports = { db, auth };
