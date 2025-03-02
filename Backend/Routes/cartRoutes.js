const express = require("express");
const router = express.Router();
const { db, auth } = require("../Utils/firebase.js");
const { authenticate } = require("../middleware/authenticator.js");

router.post("/addcart", authenticate, async (req, res) => {
  const { itemId, quantity, userId, image, price, itemName } = req.body;
  try {
    const existingItem = await db
      .collection("order")
      .where("items.itemId", "==", itemId)
      .where("userId", "==", userId)
      .where("status", "==", "pending")
      .get();
    parsedQuantity = parseInt(quantity);
    parsedPrice = parseInt(price);
    totalPrice = parsedPrice * parsedQuantity;

    if (existingItem.size > 0) {
      await Promise.all(
        existingItem.docs.map(async (doc) => {
          const id = doc.id;
          const data = doc.data();
          const newQuantity = data.items.quantity + parsedQuantity;

          await db
            .collection("order")
            .doc(id)
            .update({
              "items.quantity": newQuantity,
              totalPrice: data.totalPrice + totalPrice,
            });
        })
      );
      return res.status(201).json({ message: "Item Updated to cart" });
    } else {
      const cart = await db.collection("order").add({
        items: {
          itemId,
          quantity: parsedQuantity,
          price: parsedPrice,
          image,
          item_name: itemName,
        },
        status: "pending",
        totalPrice,
        userId,
      });
      return res.status(201).json({ message: "Item added to cart" });
    }
  } catch (e) {
    console.log(e);
  }
});

router.patch("/updatecart/:id", authenticate, async (req, res) => {
  const { id } = req.params;
  const { quantity } = req.body;
  try {
    const cart = await db.collection("order").doc(id).get();
    if (!cart.exists) {
      return res.status(404).json({ message: "Cart not found" });
    }
    const parsedQuantity = parseInt(quantity);
    const data = cart.data();
    const totalPrice = data.items.price * parsedQuantity;
    if (parsedQuantity < 1) {
      return res.status(400).json({ message: "Quantity must be more than 0" });
    }
    await db.collection("order").doc(id).update({
      "items.quantity": parsedQuantity,
      totalPrice,
    });
    return res.status(200).json({ message: "Cart updated" });
  } catch (e) {
    console.log(e);
  }
});

module.exports = router;
