const Product = require('../models/product');

// Obtener todos los productos
exports.getProducts = async (req, res) => {
    try {
        const productos = await Product.find();
        res.json(productos);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al obtener productos" });
    }
};

// Obtener un producto por ID
exports.getProductById = async (req, res) => {
    try {
        const producto = await Product.findById(req.params.id);
        if (!producto) {
            return res.status(404).json({ mensaje: "Producto no encontrado" });
        }
        res.json(producto);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al obtener producto" });
    }
};

// Crear un nuevo producto
exports.createProduct = async (req, res) => {
    try {
        const { nombre, descripcion, precio, stock } = req.body;
        const nuevoProducto = new Product({ nombre, descripcion, precio, stock });
        await nuevoProducto.save();
        res.status(201).json(nuevoProducto);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al crear producto" });
    }
};

// Actualizar un producto
exports.updateProduct = async (req, res) => {
    try {
        const { nombre, descripcion, precio, stock } = req.body;
        const productoActualizado = await Product.findByIdAndUpdate(
            req.params.id,
            { nombre, descripcion, precio, stock },
            { new: true }
        );
        res.json(productoActualizado);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al actualizar producto" });
    }
};

// Eliminar un producto
exports.deleteProduct = async (req, res) => {
    try {
        await Product.findByIdAndDelete(req.params.id);
        res.json({ mensaje: "Producto eliminado" });
    } catch (error) {
        res.status(500).json({ mensaje: "Error al eliminar producto" });
    }
};