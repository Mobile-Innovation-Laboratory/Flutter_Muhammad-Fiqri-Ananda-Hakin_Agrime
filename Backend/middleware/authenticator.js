const checkData = require("../Utils/checkData.js");
const { auth } = require("../Utils/firebase.js");

const authenticate = async (req, res, next) => {
  const token = req.headers.authorization?.split("Bearer ")[1];
  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }
  try {
    const decodeToken = await auth.verifyIdToken(token);
    req.user = decodeToken;
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

const adminAuth = async (req, res, next) => {
  const token = req.headers.authorization?.split("Bearer ")[1];
  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }
  try {
    const decodeToken = await auth.verifyIdToken(token);
    const userData = await checkData(decodeToken.uid);

    if (userData.role !== "admin") {
      return res
        .status(401)
        .json({ message: "Unauthorized, You are not Administrator" });
    }
    req.user = decodeToken;
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

module.exports = { authenticate, adminAuth };
