import 'package:flutter/material.dart';

class AddEditDialog extends StatefulWidget {
  final String? id;
  final String? name;
  final double? price;
  final int? quantity;
  final String? image;
  final String? description;
  final Function(Map<String, dynamic>) onSave;

  AddEditDialog({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.image,
    this.description,
    required this.onSave,
  });

  @override
  _AddEditDialogState createState() => _AddEditDialogState();
}

class _AddEditDialogState extends State<AddEditDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _nameController.text = widget.name ?? '';
      _priceController.text = widget.price?.toString() ?? '';
      _quantityController.text = widget.quantity?.toString() ?? '';
      _imageController.text = widget.image ?? '';
      _descriptionController.text = widget.description ?? '';
    }
  }

  void _saveItem() {
    final productData = {
      'Name': _nameController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'image': _imageController.text,
      'Description': _descriptionController.text,
    };

    widget.onSave(productData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.id == null ? 'Add Item' : 'Edit Item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: _quantityController, decoration: InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: _imageController, decoration: InputDecoration(labelText: 'Image URL')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(onPressed: _saveItem, child: Text(widget.id == null ? 'Add' : 'Update')),
      ],
    );
  }
}
