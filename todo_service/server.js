const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

app.use(cors());
app.use(express.json());

let todos = [];
let idCounter = 1;

app.get("/todos", (req, res) => {
  res.json(todos);
});

app.post("/todos", (req, res) => {
  const { title, description, isCompleted, dueDate } = req.body;
  const now = new Date();
  const newTodo = {
    id: idCounter++,
    title,
    description: description || "",
    isCompleted: !!isCompleted,
    createdAt: now.toISOString(),
    updatedAt: now.toISOString(),
    dueDate: dueDate ? new Date(dueDate).toISOString() : null,
  };
  todos.push(newTodo);
  io.emit("todo_added", newTodo);
  res.json(newTodo);
});

app.put("/todos/:id", (req, res) => {
  const id = parseInt(req.params.id);
  const idx = todos.findIndex(t => t.id === id);
  if (idx === -1) return res.status(404).json({ error: "not found" });
  const merged = { ...todos[idx], ...req.body, updatedAt: new Date().toISOString() };
  if (merged.dueDate) merged.dueDate = new Date(merged.dueDate).toISOString();
  todos[idx] = merged;
  io.emit("todo_updated", todos[idx]);
  res.json(todos[idx]);
});

app.delete("/todos/:id", (req, res) => {
  const id = parseInt(req.params.id);
  todos = todos.filter(t => t.id !== id);
  io.emit("todo_deleted", { id });
  res.json({ message: "Todo deleted" });
});

io.on("connection", s => {});

const PORT = 3000;
server.listen(PORT, () => console.log(`http://localhost:${PORT}`));
