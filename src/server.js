require('dotenv').config(); // Cargar variables de entorno
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const userRoutes = require('./routes/userRoutes');
const productRoutes = require('./routes/productsRoutes');
const authRoutes = require('./routes/authRoutes');


const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

// Conectar a la base de datos
connectDB();

// Rutas
app.use('/usuarios', userRoutes);
app.use('/productos', productRoutes);
app.use('/auth', authRoutes);

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});