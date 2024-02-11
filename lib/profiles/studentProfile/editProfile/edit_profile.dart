import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/Services/profiles.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../../Models/ProfileModels/studentModel.dart';

enum SelectOptions { company, person }

class EditProfile extends StatefulWidget {
  final StudentProfile studentProfile;

  const EditProfile({super.key, required this.studentProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SelectOptions _option = SelectOptions.person;
  TextEditingController nameController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController userInstaController = TextEditingController();
  TextEditingController userLinkedinController = TextEditingController();
  TextEditingController userTwitterController = TextEditingController();
  bool isUpdated = false;
  bool isLoading = false;

  XFile? _image;
  List<MultiSelectItem<String>> multiSelectItems = [];
  List<String> selectedValues = [];
  final MultiSelectController _controller = MultiSelectController();

  List<String> items = [
    'Fashion Stylist',
    'Fashion Designer',
    'Communication Designer',
    'Social media intern',
    'Social media Manager',
    'Production Associate',
    'Fashion Consultant',
    'Video Editor',
    'Graphic Designers',
    'Textile Designer',
    'Shoot Manager',
    'Shoot Assistant',
    'Set designer',
    'Set design assistant',
    'Videographer',
    'Photographer',
  ];

  List<ValueItem<String>> selectedOptions = [];

  // final List<ValueItem<String>> disabledOptions = [
  //   ValueItem(label: 'Option 2', value: '2'),
  // ];

  List<ValueItem<String>> multiSelectOptions = [];

  String dropdownValue = "Fashion Stylist";
  int i = 0;

  @override
  void initState() {
    super.initState();
    multiSelectItems =
        items.map((item) => MultiSelectItem<String>(item, item)).toList();

    nameController.text =
        "${widget.studentProfile.firstName} ${widget.studentProfile.lastName}";
    profileController.text = widget.studentProfile.userDescription!.join(', ');
    selectedValues = widget.studentProfile.userDescription!;
    bioController.text = widget.studentProfile.userBio ?? "";
    userInstaController.text = widget.studentProfile.userInsta ?? "";
    userTwitterController.text = widget.studentProfile.userTwitter ?? "";
    userLinkedinController.text = widget.studentProfile.userLinkedin ?? "";
    // Set the initial value for _option based on the userType
    _option = widget.studentProfile.userType == "Company"
        ? SelectOptions.company
        : SelectOptions.person;

    selectedOptions = widget.studentProfile.userDescription!
        .map((item) => ValueItem(label: item, value: item))
        .toList();

    multiSelectOptions =
        items.map((item) => ValueItem(label: item, value: item)).toList();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("Selected");
        setState(() {
          isUpdated = true;
          _image = image;
        });
      }
    } catch (e) {
      // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xff0f1015),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            // physics: BouncingScrollPhysics(),
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child:
                            (widget.studentProfile.userProfilePicture != null &&
                                    widget.studentProfile.userProfilePicture!
                                        .isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      widget.studentProfile.userProfilePicture!,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    ),
                                  )
                                : _image != null
                                    ? ClipOval(
                                        child: Image.file(
                                        File(
                                          _image!.path,
                                        ),
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ))
                                    : SvgPicture.asset(
                                        "assets/devil.svg",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        type: MaterialType.circle,
                        color: Colors.white,
                        elevation: 4.0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildTextInputRow(
                label: 'Name',
                controller: nameController,
                context: context,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'I am',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey, fontSize: 16.0),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    child: RadioListTile<SelectOptions>(
                      title: Text(
                        'A company',
                        style: TextStyle(
                            color: widget.studentProfile.userType == "Person"
                                ? Color(0xffA3A3A3)
                                : Colors.black,
                            fontSize: 14), // Reduced font size
                      ),
                      visualDensity: VisualDensity(
                          horizontal: -4), // Adjusted visual density
                      value: SelectOptions.company,
                      groupValue: _option,
                      fillColor: widget.studentProfile.userType == "Person"
                          ? MaterialStateProperty.all(Color(0xffA3A3A3))
                          : MaterialStateProperty.all(Colors.black),
                      onChanged: widget.studentProfile.userType == "Person"
                          ? null
                          : (SelectOptions? value) {
                              if (value == null) return;
                              setState(() {
                                _option = value;
                              });
                            },
                    ),
                  ),
                  Flexible(
                    child: RadioListTile<SelectOptions>(
                      title: Text(
                        'A person',
                        style: TextStyle(
                            color: widget.studentProfile.userType == "Company"
                                ? Color(0xffA3A3A3)
                                : Colors.black,
                            fontSize: 14), // Reduced font size
                      ),
                      visualDensity: VisualDensity(
                          horizontal: -4), // Adjusted visual density
                      value: SelectOptions.person,
                      groupValue: _option,
                      fillColor: widget.studentProfile.userType == "Company"
                          ? MaterialStateProperty.all(Color(0xffA3A3A3))
                          : MaterialStateProperty.all(Colors.black),

                      onChanged: widget.studentProfile.userType == "Company"
                          ? null
                          : (SelectOptions? value) {
                              if (value == null) return;
                              setState(() {
                                _option = value;
                              });
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // _buildTextInputRow(
              //   label: 'Profile',
              //   controller: profileController,
              //   context: context,
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Profile",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: MultiSelectDropDown(
                      showClearIcon: false,
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      fieldBackgroundColor: Colors.transparent,
                      controller: _controller,
                      suffixIcon: Icon(IconlyLight.arrowDown2),
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      selectedItemBuilder:
                          (BuildContext context, ValueItem<dynamic> item) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              "${item.label},",
                              style: TextStyle(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        );
                      },
                      options: multiSelectOptions,
                      selectedOptions: selectedOptions,
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll, spacing: 4),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
                      selectedOptionIcon: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary,),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10.0,
              ),
              _buildTextInputRow(
                label: 'Bio',
                controller: bioController,
                context: context,
              ),
              // const SizedBox(height: 16),
              // Add your social media fields here...
              const SizedBox(
                height: 10.0,
              ),
              // MyCustomRowWidget(image: 'assets/google.svg'),
              // const SizedBox(
              //   height: 10.0,
              // ),
              buildSocialsRow(
                image: 'assets/instagram.svg',
                controller: userInstaController,
              ),

              const SizedBox(
                height: 10.0,
              ),
              buildSocialsRow(
                image: 'assets/twitter.svg',
                controller: userTwitterController,
              ),

              const SizedBox(
                height: 10.0,
              ),
              buildSocialsRow(
                image: 'assets/facebook.svg',
                controller: userLinkedinController,
              ),

              // const SizedBox(
              //   height: 10.0,
              // ),
              // MyCustomRowWidget(image: 'assets/phone.svg'),

              const SizedBox(
                height: 50.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSaveButton(),
                ],
              ),
              // AnimatedContainer(
              //   duration: const Duration(milliseconds: 0),
              //   height: isOpen ? 238.0 : 0,
              //   // You can also add curve for the animation
              //   curve: Curves.bounceInOut,
              //   child: Container(
              //     // Content of the container, if any
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInputRow({
    required String label,
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
          ),
        ),
        // const SizedBox(width: 8),
        Expanded(
          flex: 4, // Give the text field more space
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true, // Reduces the text field height
              contentPadding: EdgeInsets.zero,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSocialsRow({
    required String image,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            SvgPicture.asset(image),
          ],
        ),
        const SizedBox(width: 50),
        Expanded(
          child: TextField(
            maxLines: 1,
            controller: controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        List<String> nameParts = nameController.text.split(' ');

        String firstName = nameParts[0];
        String lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        List<String> finalSelectedOptions=[];
        for(int i=0; i<selectedOptions.length;i++){
          finalSelectedOptions.add(selectedOptions[i].label);
        }

        print("Value is:");
        print(userInstaController.text);
        print("Indise");

        ProfileServices()
            .updateUserProfile(
                userDescription: finalSelectedOptions,
                userBio: bioController.text,
                userInsta: userInstaController.text,
                userLinkedin: userLinkedinController.text,
                userTwitter: userTwitterController.text,
                imageFile: isUpdated
                    ? File(_image!.path)
                    : File.fromUri(Uri.parse("")),
                imgUrl:
                    isUpdated ? "" : widget.studentProfile.userProfilePicture!,
                isUpdated: isUpdated,
                firstName: firstName,
                lastName: lastName)
            .then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        });
      },
      child: Container(
        height: 56.h,
        width: 182.w,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5.0.r),
        ),
        child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: (24 / 16).h,
                    ),
                    textAlign: TextAlign.left,
                  )),
      ),
    );
  }
}
