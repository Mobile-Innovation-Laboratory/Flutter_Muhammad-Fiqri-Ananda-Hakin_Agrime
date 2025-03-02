const express = require("express");
const router = express.Router();
const { adminAuth } = require("../middleware/authenticator.js");
const { db, auth } = require("../Utils/firebase.js");

router.post("/addcategory", adminAuth, async (req, res) => {
  const { category, catid } = req.body;
  if (!category || !catid) {
    return res.status(400).json({ message: "Please fill all the fields" });
  }
  try {
    const listCategory = await db.collection("categories").get();

    listCategory.forEach((doc) => {
      if (doc.data().category === category) {
        return res.status(400).json({ message: "Category already exist" });
      }
    });
    const categoryExist = await db
      .collection("categories")
      .where("id", "==", catid)
      .get();
    if (categoryExist.size > 0) {
      return res.status(400).json({ message: "Category ID already exist" });
    }

    await db.collection("categories").add({
      category,
      id: catid,
    });

    res.status(200).json({ message: "Category added successfully" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
