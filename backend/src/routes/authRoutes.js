const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

const router = express.Router();

// Ruta para registrar un usuario
router.post('/register', async (req, res) => {
    try {
        const { nombre, correo, password } = req.body;

        console.log("Intentando registrar usuario:", correo);

        // Verificar si el usuario ya existe
        const existeUsuario = await User.findOne({ correo });
        if (existeUsuario) {
            console.log("El usuario ya existe");
            return res.status(400).json({ mensaje: "El usuario ya existe" });
        }

        // Hashear la contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        // Crear nuevo usuario
        const nuevoUsuario = new User({ nombre, correo, password: hashedPassword, rol: 'usuario' });
        await nuevoUsuario.save();

        console.log("Usuario registrado exitosamente:", nuevoUsuario);

        res.status(201).json({ mensaje: "Usuario registrado exitosamente" });

    } catch (error) {
        console.error("Error en el servidor:", error);
        res.status(500).json({ mensaje: "Error en el servidor" });
    }
});

// Ruta para iniciar sesión
router.post('/login', async (req, res) => {
    const { correo, password } = req.body;

    try {
        console.log("Intentando iniciar sesión con:", correo);
        
        const usuario = await User.findOne({ correo });
        if (!usuario) {
            console.log("Usuario no encontrado");
            return res.status(400).json({ mensaje: "Usuario no encontrado" });
        }

        const esValido = await bcrypt.compare(password, usuario.password);
        if (!esValido) {
            console.log("Contraseña incorrecta");
            return res.status(400).json({ mensaje: "Credenciales incorrectas" });
        }

        // Se usa process.env.JWT_SECRET en lugar de 'secreto'
        const token = jwt.sign({ id: usuario._id, rol: usuario.rol }, process.env.JWT_SECRET ||"a3f4b1c7e8d9f2a4b5c6d7e8f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8g9", { expiresIn: '1h' });

        console.log("Inicio de sesión exitoso, token generado:", token);
        res.json({ token });

    } catch (error) {
        console.error("Error en el servidor:", error);
        res.status(500).json({ mensaje: "Error en el servidor" });
    }
});

module.exports = router;