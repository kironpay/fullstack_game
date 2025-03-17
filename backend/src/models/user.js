const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    nombre: String,
    correo: String,
    password: String,
    rol: String
});

module.exports = mongoose.model('Usuario', userSchema);