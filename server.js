const express = require("express");
const fetch = require("node-fetch");

const app = express();
app.use(express.json());

// API test
app.get("/", (req, res) => {
res.send("Server đang chạy!");
});

// ===== KẾT NỐI SERVER KHÁC =====
app.get("/get-data", async (req, res) => {
try {
// gọi server khác (ví dụ API public)
const response = await fetch("https://jsonplaceholder.typicode.com/posts");
const data = await response.json();

res.json(data);

} catch (err) {
res.status(500).send("Lỗi kết nối server khác");
}
});

// ===== NHẬN DATA TỪ WEB =====
app.post("/send", (req, res) => {
const data = req.body;
console.log("Nhận từ client:", data);

res.json({status:"OK"});
});

app.listen(3000, () => {
console.log("Server chạy tại http://localhost:3000");
});
