import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _pets = [];
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedType = 'Cat';
  final List<String> _petTypes = ['Cat', 'Dog', 'Bird', 'Rabbit', 'Other'];

  void _savePet({int? index}) {
    if (_formKey.currentState!.validate()) {
      final pet = {
        'name': _nameController.text,
        'type': _selectedType,
        'description': _descriptionController.text,
        'age': _ageController.text,
      };

      setState(() {
        if (index == null) {
          _pets.add(pet);
        } else {
          _pets[index] = pet;
        }
      });

      Navigator.pop(context);
      _clearForm();
    }
  }

  void _deletePet(int index) {
    setState(() {
      _pets.removeAt(index);
    });
    Navigator.pop(context);
  }

  void _openFormDialog({Map<String, String>? pet, int? index}) {
    if (pet != null) {
      _nameController.text = pet['name']!;
      _selectedType = pet['type']!;
      _descriptionController.text = pet['description']!;
      _ageController.text = pet['age']!;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pet == null ? 'Add Pet' : 'Edit Pet'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Pet Name'),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter pet name' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(labelText: 'Pet Type'),
                    items: _petTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter pet description'
                        : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age (Years)'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter pet age' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _savePet(index: index),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _ageController.clear();
    _selectedType = 'Cat';
  }

  void _logout() {
    // Navigate to the login screen after logout
    Navigator.pushReplacementNamed(context, '/login'); // Adjust the route name as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the AppBar color to blue
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pet App'),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: _pets.isEmpty
          ? Center(child: Text('No pets added yet!'))
          : ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return ListTile(
            title: Text(pet['name']!),
            subtitle: Text('${pet['type']} • ${pet['age']} years'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deletePet(index),
            ),
            onTap: () => _openFormDialog(pet: pet, index: index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
