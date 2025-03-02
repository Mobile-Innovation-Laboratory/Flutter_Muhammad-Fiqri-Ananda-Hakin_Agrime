const express = require("express");
const router = express.Router();
const { db, auth } = require("../Utils/firebase.js");
const admin = require("firebase-admin");

const upload = require("../middleware/upload.js");
const { authenticate } = require("../middleware/authenticator.js");
const checkData = require("../Utils/checkData.js");

// Product Routes
router.post(
  "/addproduct",
  authenticate,
  upload.single("photoproduct"),
  async (req, res) => {
    const { name, price, stock, description, categoryId } = req.body;
    const image = req.file;
    const user = req.user.uid;
    try {
      const parsedPrice = parseInt(price);
      const parsedStock = parseInt(stock);
      const userData = await checkData(user);
      if (userData.role !== "petani") {
        return res.status(401).json({ message: "Unauthorized" });
      }
      if (!image) {
        return res.status(400).json({ message: "Image required" });
      }

      await db.collection("products").add({
        name,
        price: parsedPrice,
        stock: parsedStock,
        description,
        image: image.filename,
        store: userData.username,
        categories: [{ id: categoryId }],
        createdAt: new Date(),
      });

      return res.status(201).json({ message: "Product added" });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "Internal server error" });
    }
  }
);

router.delete("/deleteproduct/:id", authenticate, async (req, res) => {
  const { id } = req.params;
  const user = req.user.uid;
  try {
    const product = await db.collection("products").doc(id).get();
    if (!product.exists) {
      return res.status(404).json({ message: "Product not found" });
    }
    const userData = await checkData(user);
    if (
      userData.role !== "petani" &&
      userData.username !== product.data().store
    ) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    await db.collection("products").doc(id).delete();
    return res.status(200).json({ message: "Product deleted" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

router.patch(
  "/updateproduct/:id",
  authenticate,
  upload.single("photoproduct"),
  async (req, res) => {
    const { id } = req.params;
    const user = req.user.uid;
    const { name, price, stock, description, category, categoryId } = req.body;

    try {
      const product = await db.collection("products").doc(id).get();
      if (!product.exists) {
        return res.status(404).json({ message: "Product not found" });
      }
      const userData = await checkData(user);
      if (
        userData.role !== "petani" &&
        userData.username !== product.data().store
      ) {
        return res.status(401).json({ message: "Unauthorized" });
      }

      const updatedData = {
        name: name,
        description: description,
      };

      Object.keys(updatedData).forEach((key) => {
        if (!updatedData[key] === undefined || updatedData[key] === "") {
          delete updatedData[key];
        }
      });

      await db.collection("products").doc(id).update(updatedData);
      return res.status(200).json({ message: "Product updated" });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "Internal server error" });
    }
  }
);

// Category routes
router.patch("/addcategorytoproduct/:id", authenticate, async (req, res) => {
  const { category, catid } = req.body;
  const { id } = req.params;
  try {
    await db
      .collection("products")
      .doc(id)
      .update({
        categories: admin.firestore.FieldValue.arrayUnion({
          id: catid,
          category,
        }),
      });
    return res.status(200).json({ message: "Category added" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

router.patch("/removecategory/:id", authenticate, async (req, res) => {
  const { category, catid } = req.body;
  const { id } = req.params;
  try {
    await db
      .collection("products")
      .doc(id)
      .update({
        categories: admin.firestore.FieldValue.arrayRemove({
          id: catid,
          category,
        }),
      });
    return res.status(200).json({ message: "Category removed" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
