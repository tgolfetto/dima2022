import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/custom_button.dart';
import '../../common/custom_text_field.dart';
import '../../common/title_text.dart';
import 'category_grid.dart';
import 'selfie_card_widget.dart';

class UserInputForm extends StatefulWidget {
  static const pageIndex = 8;
  const UserInputForm({super.key});

  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  late UserViewModel userViewModel;

  var _isInit = true;
  var _isLoading = false;
  var results;

  // controllers for the text fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _sizeController;
  late final TextEditingController _shoeSizeController;

  late final CategoryGrid categoryGrid;

  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _sizeFocusNode = FocusNode();
  final shoeSizeFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int completedFields = 0;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _sizeController = TextEditingController();
    _shoeSizeController = TextEditingController();
    categoryGrid = CategoryGrid();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserViewModel>(context).getUser().then((_) {
        setState(() {
          userViewModel = Provider.of<UserViewModel>(context, listen: false);

          _nameController.text = userViewModel.name;
          _emailController.text = userViewModel.email;
          _phoneController.text = userViewModel.phone;
          _addressController.text = userViewModel.address;
          _sizeController.text = userViewModel.size;
          _shoeSizeController.text = userViewModel.shoeSizeString;
          categoryGrid.initCategories = userViewModel.favoriteCategories;

          _isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _sizeController.dispose();
    _shoeSizeController.dispose();

    super.dispose();
  }

  // void _incrementCompletedFields(String value) {
  //   setState(() {
  //     if (value.isNotEmpty) completedFields++;
  //     if (value.isEmpty) completedFields--;
  //   });
  // }

  Future<void> saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      categoryGrid.categories.map((e) => userViewModel.addFavoriteCategory(e));

      await userViewModel.saveChanges();
    } catch (error) {
      //we have to await the dialog clousure before to continue with finallu
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('An error occurred'),
          content: Text(
            'Something went wrong \n Details:\n${error.toString()}',
          ),
          actions: [
            CustomButton(
              transparent: false,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalFields = 8;

    // Create a PageController instance
    final PageController pageController = PageController();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isKeyboardActive = MediaQuery.of(context).viewInsets.bottom > 0;
        final bottomPadding = isKeyboardActive
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom * 1.5;

        return _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(bottomPadding)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Form(
                        key: _formKey,
                        child: PageView(
                          pageSnapping: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // disable
                          controller: pageController, // Set the PageController
                          onPageChanged: (int page) {
                            setState(() {
                              var _currentPage = page;
                            });
                          },
                          children: [
                            // First card
                            Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    CardHeader(
                                      formKey: _formKey,
                                      pageController: pageController,
                                      backButton: false,
                                      nextButton: true,
                                      textTitle: 'Your Profile',
                                      textSubtitle: 'Step 1 of 3',
                                      nextButtonText: 'Next',
                                      backIcon: Icons.arrow_back_ios,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            CustomTextField(
                                              hintText: 'Name',
                                              prefixIcon: Icons.person,
                                              controller: _nameController,
                                              onSaved: (value) {
                                                setState(() {
                                                  userViewModel.name =
                                                      value ?? '';
                                                });
                                              },
                                              validateString:
                                                  'Please provide a correct name.',
                                              focusNextNode: _emailFocusNode,
                                            ),
                                            const Gutter(),
                                            CustomTextField(
                                              hintText: 'Email',
                                              prefixIcon: Icons.email,
                                              controller: _emailController,
                                              onSaved: (value) {
                                                setState(() {
                                                  userViewModel.email =
                                                      value ?? '';
                                                });
                                              },
                                              validateString:
                                                  'Please provide a correct email.',
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              focusNode: _emailFocusNode,
                                              focusNextNode: _phoneFocusNode,
                                            ),
                                            const Gutter(),
                                            CustomTextField(
                                              hintText: 'Phone',
                                              prefixIcon: Icons.phone,
                                              controller: _phoneController,
                                              onSaved: (value) {
                                                setState(() {
                                                  userViewModel.phone =
                                                      value ?? '';
                                                });
                                              },
                                              validateString:
                                                  'Please provide a correct phone number.',
                                              keyboardType:
                                                  TextInputType.number,
                                              focusNode: _phoneFocusNode,
                                              focusNextNode: _addressFocusNode,
                                            ),
                                            const Gutter(),
                                            CustomTextField(
                                              hintText: 'Address',
                                              prefixIcon: Icons.location_on,
                                              controller: _addressController,
                                              onSaved: (value) {
                                                setState(() {
                                                  userViewModel.address =
                                                      value ?? '';
                                                });
                                              },
                                              validateString:
                                                  'Please provide a correct address.',
                                              keyboardType: TextInputType.text,
                                              focusNode: _addressFocusNode,
                                              focusNextNode: _sizeFocusNode,
                                            ),
                                            const Gutter(),
                                            CustomTextField(
                                              hintText: 'Size',
                                              prefixIcon: Icons.format_size,
                                              controller: _sizeController,
                                              onSaved: (value) {
                                                setState(() {
                                                  userViewModel.size =
                                                      value ?? '';
                                                });
                                              },
                                              validateString:
                                                  'Please provide a correct size.',
                                              focusNode: _sizeFocusNode,
                                            ),
                                            const Gutter(),
                                            CustomTextField(
                                              hintText: 'Shoe size',
                                              prefixIcon: Icons.sort,
                                              controller: _shoeSizeController,
                                              onSaved: (value) {
                                                setState(() {
                                                  userViewModel.shoeSize =
                                                      int.parse(value ?? '0');
                                                });
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter a size.';
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return 'Please enter a valid number.';
                                                }
                                                if (double.parse(value) <= 0) {
                                                  return 'Please enter a number greater than zero.';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Second card
                            Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    CardHeader(
                                      formKey: _formKey,
                                      pageController: pageController,
                                      backButton: true,
                                      nextButton: true,
                                      textTitle: "Add a profile picture",
                                      textSubtitle: 'Step 2 of 3',
                                      nextButtonText: 'Next',
                                      backIcon: Icons.arrow_back_ios,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: SingleChildScrollView(
                                        child: SelfieCard(
                                          userImageUrl:
                                              userViewModel.profileImageUrl,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Third card
                            Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    CardHeader(
                                      formKey: _formKey,
                                      pageController: pageController,
                                      backButton: true,
                                      nextButton: true,
                                      textTitle: "Your categories are",
                                      textSubtitle: 'Step 3 of 3',
                                      nextButtonText: 'Done',
                                      submit: () {
                                        saveForm();
                                      },
                                      nextIcon: Icons.done,
                                      backIcon: Icons.arrow_back_ios,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: categoryGrid,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class CardHeader extends StatelessWidget {
  const CardHeader(
      {Key? key,
      required GlobalKey<FormState> formKey,
      required PageController pageController,
      required this.nextButton,
      required this.backButton,
      this.submit,
      required this.textTitle,
      required this.textSubtitle,
      this.prevButtonText,
      this.nextButtonText,
      this.backIcon,
      this.nextIcon})
      : _formKey = formKey,
        _pageController = pageController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final PageController _pageController;

  final String textTitle;
  final String textSubtitle;
  final bool backButton;
  final bool nextButton;
  final VoidCallback? submit;
  final IconData? backIcon;
  final IconData? nextIcon;
  final String? prevButtonText;
  final String? nextButtonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            backButton
                ? CustomButton(
                    transparent: true,
                    onPressed: () {
                      // Move to the next page
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    },
                    text: prevButtonText != null ? prevButtonText! : null,
                    icon: backIcon,
                  )
                : const SizedBox(
                    width: 1,
                  ),
            if (nextButton)
              CustomButton(
                transparent: false,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the current values of the form fields
                    _formKey.currentState!.save();

                    if (submit != null) {
                      submit!();
                    } else {
                      // Move to the next page
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                },
                text: nextButtonText != null ? nextButtonText! : null,
                icon: nextIcon,
              ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(30),
        ),
        TitleText(
          text: textTitle,
          fontSize: 34,
          color: Colors.black87,
        ),
        Text(textSubtitle),
        const Gutter(),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
      ],
    );
  }
}
