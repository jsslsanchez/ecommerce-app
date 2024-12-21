// lib/pages/user_profile_page.dart
import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/category_model.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/utils/icon_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_e_commerce/utils/toast_service.dart';
import 'package:project_e_commerce/pages/sensor_page.dart';
import 'package:image_picker/image_picker.dart'; // Importa el paquete para seleccionar imágenes
import 'dart:io'; // Para manejar archivos locales

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _userName = 'Nombre de Usuario'; // Estado para el nombre del usuario
  bool _isEditing = false; // Estado para alternar entre edición y visualización
  final TextEditingController _controller = TextEditingController();
  final ProductManager _productManager =
      ProductManager(); // Instancia de ProductManager
  File? _profileImage; // Variable para almacenar la imagen de perfil
  final ImagePicker _picker = ImagePicker(); // Instancia de ImagePicker

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Cargar el nombre almacenado al iniciar la app
    _loadProducts(); // Cargar productos al iniciar
    _loadProfileImage();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await _productManager.loadCategories();
    setState(() {}); // Actualiza la UI para reflejar los cambios
  }

// Cargar la imagen
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Ajusta la calidad de la imagen
    );

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
      _saveProfileImagePath(pickedImage.path); // Guarda la ruta de la imagen
    }
  }

  Future<void> _saveProfileImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', imagePath); // Guarda la ruta
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImage');

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath); // Carga la imagen si la ruta existe
      });
    }
  }

  // Cargar el nombre del usuario desde SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Nombre de Usuario';
      _controller.text =
          _userName; // Inicializar el controlador con el nombre cargado
    });
  }

  // Guardar el nombre del usuario en SharedPreferences
  Future<void> _saveUserName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName); // Guardar el nombre
  }

  Future<void> _loadProducts() async {
    await _productManager.loadProducts(); // Cargar productos
    setState(() {}); // Actualizar el estado para reflejar los cambios
  }

  void _showProductOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opciones de Productos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Agregar Producto'),
                onTap: () {
                  Navigator.pop(context);
                  _addProduct(); // Llamar al método para agregar producto
                },
              ),
              ListTile(
                title: const Text('Ver Productos'),
                onTap: () {
                  Navigator.pop(context);
                  _viewProducts(); // Llamar al método para ver productos
                },
              ),
              // Agrega más opciones como eliminar y modificar según sea necesario
            ],
          ),
        );
      },
    );
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        double price = 0.0;
        int quantity = 1;
        String image = '';
        int? selectedCategoryIndex;

        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                onChanged: (value) => quantity = int.tryParse(value) ?? 1,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Imagen URL'),
                onChanged: (value) => image = value,
              ),
              DropdownButton<int>(
                hint: const Text('Seleccionar Categoría'),
                value: selectedCategoryIndex,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedCategoryIndex = newValue;
                  });
                },
                items: _productManager
                    .getCategories()
                    .asMap()
                    .entries
                    .map<DropdownMenuItem<int>>((entry) {
                  int index = entry.key;
                  CategoryModel category = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(category.name),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (selectedCategoryIndex != null) {
                  _productManager.addProduct(
                      name, price, quantity, image, selectedCategoryIndex!);
                  ToastService.showToast(
                      "Producto agregado con éxito"); // Usar la clase ToastService
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, selecciona una categoría.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _viewProducts() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Productos'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _productManager.getProducts().length,
              itemBuilder: (context, index) {
                final product = _productManager.getProducts()[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(
                      'Precio: \$${product['price']} - Cantidad: ${product['quantity']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _productManager.deleteProduct(index);
                      Navigator.pop(
                          context); // Cerrar el diálogo después de eliminar
                      _viewProducts(); // Volver a mostrar la lista actualizada
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            Expanded(
              child: _buildSettingsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage, // Llama a _pickImage cuando se toque la imagen
          child: CircleAvatar(
            radius: 40,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!) as ImageProvider
                : const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/456/456212.png'),
            child: _profileImage == null
                ? const Icon(Icons.add_a_photo, color: Colors.white)
                : null, // Muestra un icono si no hay imagen
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _isEditing
                  ? Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Editar nombre',
                        ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'usuario@ejemplo.com',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                  setState(() {
                    if (_isEditing) {
                      _userName = _controller.text;
                      _saveUserName(_userName); // Guardar el nombre editado
                    }
                    _isEditing = !_isEditing; // Alternar el modo de edición
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      children: [
        _buildListTile(Icons.list, 'Pedidos', () {}),
        _buildListTile(Icons.payment, 'Forma de pago', () {}),
        _buildListTile(Icons.location_on, 'Direcciones', () {}),
        _buildListTile(Icons.local_offer, 'Ofertas', () {}),
        _buildListTile(Icons.person_pin_rounded, 'Datos personales', () {}),
        _buildListTile(Icons.category, 'Categorías', _showCategoryOptions),
        _buildListTile(Icons.shopping_cart, 'Productos', _showProductOptions),
        _buildListTile(Icons.adb, 'Sensores', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SensorPage()),
          );
        }),
        _buildListTile(Icons.help, 'Ayuda', () {}),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right), // Flecha indicativa
      onTap: onTap,
    );
  }

  void _showCategoryOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opciones de Categorías'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Agregar Categoría'),
                onTap: () {
                  Navigator.pop(context);
                  _addCategory(); // Llamar al método para agregar categoría
                },
              ),
              ListTile(
                title: const Text('Ver Categorías'),
                onTap: () {
                  Navigator.pop(context);
                  _viewCategories(); // Llamar al método para ver categorías
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String icon = ''; // Variable para almacenar el ícono seleccionado

        return AlertDialog(
          title: const Text('Agregar Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => name = value,
              ),
              Row(
                children: [
                  // Muestra el ícono seleccionado si hay uno
                  icon.isNotEmpty
                      ? Icon(IconData(int.parse(icon),
                          fontFamily: 'MaterialIcons'))
                      : const Icon(Icons.circle), // Ícono por defecto
                  const SizedBox(width: 10),
                  TextButton(
                    child: const Text('Seleccionar Ícono'),
                    onPressed: () {
                      selectIcon((selectedIcon) {
                        setState(() {
                          icon = selectedIcon; // Guarda el ícono seleccionado
                        });
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (name.isNotEmpty && icon.isNotEmpty) {
                  _productManager.addCategory(name, icon);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateCategory(int index) {
    final currentCategory = _productManager.getCategory(index);
    if (currentCategory != null) {
      showDialog(
        context: context,
        builder: (context) {
          String name = currentCategory.name;
          String icon = currentCategory.icon;

          return AlertDialog(
            title: const Text('Actualizar Categoría'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                ),
                GestureDetector(
                  onTap: () {
                    selectIcon((selectedIcon) {
                      setState(() {
                        icon = selectedIcon; // Actualiza el ícono seleccionado
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        IconList().iconMap[icon], // Muestra el ícono actual
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(icon.isEmpty ? 'Seleccionar ícono' : icon),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Actualizar'),
                onPressed: () {
                  _productManager.updateCategory(index, name, icon);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _viewCategories() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Categorías'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _productManager.getCategories().length,
              itemBuilder: (context, index) {
                final category = _productManager.getCategories()[index];
                return ListTile(
                  title: Text(category.name),
                  leading: Icon(
                    IconList().iconMap[
                        category.icon], // Obtiene el ícono de la categoría
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pop(context);
                          _updateCategory(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _productManager.deleteCategory(index);
                          ToastService.showToast(
                              "Categoría eliminada"); // Usar la clase ToastService
                          Navigator.pop(context);
                          _viewCategories(); // Refresca la vista
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void selectIcon(Function(String) onIconSelected) {
    final iconList = IconList().iconMap; // Obtener el mapa de íconos
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return SizedBox(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
            itemCount: iconList.length,
            itemBuilder: (context, i) {
              var key = iconList.keys.elementAt(i);
              return GestureDetector(
                child: Icon(
                  iconList[key],
                  size: 30.0,
                  color: Theme.of(context).dividerColor,
                ),
                onTap: () {
                  onIconSelected(
                      key); // Llama al callback con el ícono seleccionado
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
