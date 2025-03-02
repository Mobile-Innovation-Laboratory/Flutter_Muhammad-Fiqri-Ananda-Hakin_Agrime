const { db, auth } = require("./firebase.js");

const checkData = async (uid) => {
  const user = await db.collection("users").doc(uid).get();
  if (!user.exists) {
    return false;
  }
  const data = user.data();
  delete data.hashedPassword;
  return data;
};

module.exports = checkData;
