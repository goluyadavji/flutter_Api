import 'package:api_call2/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: productProvider.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toString()}'),
                  leading: Icon(Icons.account_circle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,color: Colors.green,),
                        onPressed: () => showUpdateProductDialog(
                            context, product.id, product.title, product.price),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,color: Colors.red,),
                        onPressed: () =>
                            productProvider.deleteProduct(product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProduct(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showUpdateProductDialog(
      BuildContext context, int id, String Title, double Price) {
    final titleController = TextEditingController(text: Title);
    final priceController = TextEditingController(text: Price.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,),],),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                if (title.isNotEmpty && price > 0) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .updateProduct(id, title, price);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
