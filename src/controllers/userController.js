const User = require('../models/user');

exports.getUsers = async (req, res) => {
    try {
        const usuarios = await User.find();
        res.json(usuarios);
    } catch (error) {
        res.status(500).json({ mensaje: "Error en el servidor" });
    }
};

exports.createUser = async (req, res) => {
    try {
        const { nombre, correo} = req.body;
        const nuevoUsuario = new User({ nombre, correo});
        await nuevoUsuario.save();
        res.status(201).json(nuevoUsuario);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al crear usuario" });
    }
};

exports.updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, correo } = req.body;
        const usuarioActualizado = await User.findByIdAndUpdate(id, { nombre, correo }, { new: true });
        res.json(usuarioActualizado);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al actualizar usuario" });
    }
};

exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        await User.findByIdAndDelete(id);
        res.json({ mensaje: "Usuario eliminado" });
    } catch (error) {
        res.status(500).json({ mensaje: "Error al eliminar usuario" });
    }
};