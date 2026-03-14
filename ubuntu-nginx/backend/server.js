const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const cookieParser = require("cookie-parser");

const app = express();
app.use(express.json());
app.use(cookieParser());

const PORT = 3000;
const SECRET = "mysecretkey";

/* Fake database */
const user = {
  username: "admin",
  password: bcrypt.hashSync("password123", 8)
};

/* LOGIN */
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  if (username !== user.username) {
    return res.status(401).json({ message: "Invalid username" });
  }

  const valid = bcrypt.compareSync(password, user.password);
  if (!valid) {
    return res.status(401).json({ message: "Invalid password" });
  }

  const token = jwt.sign({ username }, SECRET, { expiresIn: "1h" });

  res.cookie("token", token, { httpOnly: true });

  res.json({ message: "Login successful" });
});

/* PROTECTED ROUTE */
app.get("/dashboard", (req, res) => {
  const token = req.cookies.token;

  if (!token) return res.status(401).json({ message: "Not logged in" });

  try {
    const decoded = jwt.verify(token, SECRET);
    res.json({ message: "Welcome " + decoded.username });
  } catch (err) {
    res.status(401).json({ message: "Invalid token" });
  }
});

/* LOGOUT */
app.post("/logout", (req, res) => {
  res.clearCookie("token");
  res.json({ message: "Logged out" });
});

app.listen(PORT, () => {
  console.log("Server running on port", PORT);
});
