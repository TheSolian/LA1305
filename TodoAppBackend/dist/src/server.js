"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cors_1 = __importDefault(require("cors"));
const express_1 = __importDefault(require("express"));
const client_1 = require("../prisma/client");
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
app.get('/tasks', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const tasks = yield client_1.prisma.task.findMany();
    res.json(tasks);
}));
app.post('/save-task', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id, title, description, isCompleted } = req.body;
    const task = yield client_1.prisma.task.upsert({
        where: { id },
        update: { title, description, isCompleted },
        create: { id, title, description, isCompleted },
    });
    res.json(task);
}));
app.delete('/delete-task/:id', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    try {
        const task = yield client_1.prisma.task.delete({
            where: { id },
        });
        if (task) {
            res.json({ success: true });
        }
    }
    catch (error) {
        res.json({ success: false });
    }
}));
app.listen(8000, () => console.log('Server is running on port 8000'));
