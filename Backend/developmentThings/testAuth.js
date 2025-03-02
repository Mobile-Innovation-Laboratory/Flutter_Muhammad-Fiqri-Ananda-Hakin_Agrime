const { initializeApp } = require("firebase/app");
const {
  getAuth,
  singInWithCustomToken,
  signInWithCustomToken,
} = require("firebase/auth");

const firebaseConfig = {
  apiKey: "AIzaSyDdxsdsfzegdFKi7_Cuo2GxAYf10OxLsLE",
  authDomain: "agrime-f4e39.firebaseapp.com",
  projectId: "agrime-f4e39",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

async function singInWithTokenDev(customToken) {
  try {
    const userCredential = await signInWithCustomToken(auth, customToken);
    const idToken = await userCredential.user.getIdToken();
    console.log(idToken);
  } catch (error) {
    console.log(error);
  }
}

module.exports = singInWithTokenDev;
