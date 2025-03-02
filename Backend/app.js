const express = require("express");
const userRoute = require("./Routes/userRoutes.js");
const productRoute = require("./Routes/productRoutes.js");
const adminRoute = require("./Routes/adminRoutes.js");
const cartRoute = require("./Routes/cartRoutes.js");
const bodyParser = require("body-parser");
const singInWithTokenDev = require("./developmentThings/testAuth.js");
const path = require("path");
const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.use("/api/users", userRoute);

app.use("/api/product", productRoute);
app.use("/api/admin", adminRoute);
app.use("/api/cart", cartRoute);
app.get("/", (req, res) => {
  res.json({ message: "Welcome to the API" });
});

app.post("/dev", (req, res) => {
  const { customToken } = req.body;
  singInWithTokenDev(customToken);
  return res.json({ message: "Check your console" });
});
app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
