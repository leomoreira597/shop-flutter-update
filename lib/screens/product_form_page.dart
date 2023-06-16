import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductsFormPage extends StatefulWidget {
  const ProductsFormPage({Key? key}) : super(key: key);

  @override
  State<ProductsFormPage> createState() => _ProductsFormPageState();
}

class _ProductsFormPageState extends State<ProductsFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String uri) {
    bool isValidUri = Uri.tryParse(uri)?.hasAbsolutePath ?? false;
    bool endsWithFile = uri.toLowerCase().endsWith(".png") ||
        uri.toLowerCase().endsWith("jpg") ||
        uri.toLowerCase().endsWith("jpg");
    return isValidUri && endsWithFile;
  }

  Future<void> _submitForm() async {
    final _isValid = _formKey.currentState?.validate() ?? false;

    if (!_isValid) {
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProducts(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Ocorreu um erro!!"),
          content: const Text(
            "Ocorreu um erro para salvar o produto, tente novamente mais tarde,",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok"),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Formulario de produto",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              _submitForm();
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Nome",
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      textInputAction: TextInputAction.next,
                      onSaved: (name) => _formData['name'] = name ?? "",
                      validator: (_name) {
                        final name = _name ?? "";
                        if (name.trim().isEmpty) {
                          return "O nome é obrigatorio";
                        }
                        if (name.trim().length < 3) {
                          return "O nome precisa de no minimo 3 letras";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Preço",
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSaved: (price) => _formData['price'] = double.parse(
                        price ?? '0',
                      ),
                      validator: (_price) {
                        final priceString = _price ?? "";
                        final price = double.tryParse(priceString) ?? -1;
                        if (price <= 0) {
                          return "Informe um preço válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                      ),
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? "",
                      validator: (_description) {
                        final description = _description ?? "";
                        if (description.trim().isEmpty) {
                          return "A descrição é obrigatoria";
                        }
                        if (description.trim().length < 3) {
                          return "A descrição precisa de no minimo 3 letras";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Url da Imagem",
                            ),
                            focusNode: _imageUrlFocus,
                            onFieldSubmitted: (_) => _submitForm(),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onSaved: (imageUrl) =>
                                _formData["imageUrl"] = imageUrl ?? "",
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl ?? "";
                              if (!isValidImageUrl(imageUrl)) {
                                return "Url não é valido";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text("Informe a Url")
                              : Container(
                                  height: 100,
                                  width: 100,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child:
                                        Image.network(_imageUrlController.text),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
