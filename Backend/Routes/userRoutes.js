const express = require("express");
const bcrypt = require("bcrypt");
const { validationResult, body } = require("express-validator");
const router = express.Router();
const { db, auth } = require("../Utils/firebase.js");
const upload = require("../middleware/upload.js");
const { authenticate } = require("../middleware/authenticator.js");

router.get("/", (req, res) => {
  res.json({ message: "User route" });
});

router.post(
  "/register",
  [
    body("email").isEmail().withMessage("Not Valid Email"),
    body("password")
      .isLength({ min: 6 })
      .withMessage("Password minimal 6 karakter"),
    body("username").notEmpty().withMessage("Nama tidak boleh kosong"),
    body("firstname").notEmpty().withMessage("Nama depan tidak boleh kosong"),
    body("lastname").notEmpty().withMessage("Nama belakang tidak boleh kosong"),
  ],
  async (req, res) => {
    const { email, password, username, firstname, lastname, location } =
      req.body;
    try {
      const hashedPassword = await bcrypt.hash(password, 10);
      const error = validationResult(req);
      if (!error.isEmpty()) {
        return res.status(400).json({ message: error.array() });
      }

      const userRecord = await auth.createUser({
        email,
        password: hashedPassword,
        username,
        firstname,
        lastname,
        isAdmin: false,
        role: "user",
        isVerified: false,
      });

      await db.collection("users").doc(userRecord.uid).set({
        email,
        username,
        password: hashedPassword,
        firstname,
        lastname,
        isAdmin: false,
        role: "user",
        isVerified: false,
        location,
        createdAt: new Date(),
      });

      return res.status(201).json({ message: "Register success" });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "Internal server error", error });
    }
  }
);

router.post(
  "/login",
  [
    body("email").isEmail().withMessage("Not Valid Email"),
    body("password")
      .isLength({ min: 6 })
      .withMessage("Password minimal 6 karakter"),
  ],
  async (req, res) => {
    const { email, password } = req.body;
    try {
      console.log(email, password);
      const error = validationResult(req);
      if (!error.isEmpty()) {
        return res.status(400).json({ message: error.array() });
      }

      const userRecord = await auth.getUserByEmail(email);

      const user = await db.collection("users").doc(userRecord.uid).get();
      if (user.empty) {
        return res.status(404).json({ message: "User not found" });
      }

      const userData = user.data();
      const isPasswordMatch = await bcrypt.compare(
        password,
        userData.hashedPassword
      );
      if (!isPasswordMatch) {
        return res.status(400).json({ message: "Password not match" });
      }
      const token = await auth.createCustomToken(userRecord.uid);
      return res.status(200).json({
        token,
        userData: {
          email: userData.email,
          username: userData.username,
          firstname: userData.firstname,
          lastname: userData.lastname,
          isAdmin: userData.isAdmin,
          role: userData.role,
          isVerified: userData.isVerified,
          location: userData.location,
          createdAt: userData.createdAt,
        },
      });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "Internal server error" });
    }
  }
);

router.post(
  "/idupload",
  authenticate,
  upload.single("idCard"),
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ message: "File not found" });
      }
      await db.collection("users").doc(req.user.uid).update({
        idCard: req.file.filename,
      });
      res.status(200).json({ success: true, message: "File uploaded" });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "Internal server error" });
    }
  }
);

module.exports = router;
