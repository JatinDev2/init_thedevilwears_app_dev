import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/HomeScreen/brandModel.dart';
import 'package:lookbook/HomeScreen/studentModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/Services/profiles.dart';

enum SelectOptions { company, person }

class EditBrandProfile extends StatefulWidget {
  final BrandProfile brandProfile;

  const EditBrandProfile({super.key, required this.brandProfile});

  @override
  State<EditBrandProfile> createState() => _EditBrandProfileState();
}

class _EditBrandProfileState extends State<EditBrandProfile> {
  SelectOptions _option = SelectOptions.person;
  TextEditingController nameController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController userInstaController=TextEditingController();
  TextEditingController userLinkedinController=TextEditingController();
  TextEditingController userTwitterController=TextEditingController();
  bool isUpdated=false;
  bool isLoading=false;

  XFile? _image;

  @override
  void initState() {
    super.initState();
    nameController.text =
    widget.brandProfile.brandName;
    profileController.text =
        widget.brandProfile.brandDescription!.join(', ');
    bioController.text = widget.brandProfile.brandBio ?? "";
    userInstaController.text=widget.brandProfile.brandInsta ?? "";
    userTwitterController.text=widget.brandProfile.brandTwitter ?? "";
    userLinkedinController.text=widget.brandProfile.brandLinkedIn ?? "";
    // Set the initial value for _option based on the userType
    _option = widget.brandProfile.userType == "Company"
        ? SelectOptions.company
        : SelectOptions.person;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("Selected");
        setState(() {
          isUpdated=true;
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
                        child: (widget.brandProfile.brandProfilePicture != null && widget.brandProfile.brandProfilePicture!.isNotEmpty)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            widget.brandProfile.brandProfilePicture!,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        ): _image != null? ClipOval(
                            child: Image.file(File(_image!.path,),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                        )
                            : Image.asset(
                          "assets/brand.png",
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey, fontSize: 16.0),
                  ),
                  SizedBox(width: 3,),
                  Flexible(
                    child: RadioListTile<SelectOptions>(
                      title: Text(
                        'A company',
                        style: TextStyle(color: widget.brandProfile.userType == "Person"? Color(0xffA3A3A3) : Colors.black, fontSize: 14), // Reduced font size
                      ),
                      visualDensity: VisualDensity(horizontal: -4), // Adjusted visual density
                      value: SelectOptions.company,
                      groupValue: _option,
                      fillColor: widget.brandProfile.userType == "Person" ? MaterialStateProperty.all(Color(0xffA3A3A3)) : MaterialStateProperty.all(Colors.black),
                      onChanged: widget.brandProfile.userType == "Person" ? null : (SelectOptions? value) {
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
                        style: TextStyle(color: widget.brandProfile.userType == "Company" ?  Color(0xffA3A3A3) : Colors.black, fontSize: 14), // Reduced font size
                      ),
                      visualDensity: VisualDensity(horizontal: -4), // Adjusted visual density
                      value: SelectOptions.person,
                      groupValue: _option,
                      fillColor: widget.brandProfile.userType == "Company" ? MaterialStateProperty.all(Color(0xffA3A3A3)) : MaterialStateProperty.all(Colors.black),

                      onChanged: widget.brandProfile.userType == "Company" ? null : (SelectOptions? value) {
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
              _buildTextInputRow(
                label: 'Profile',
                controller: profileController,
                context: context,
              ),
              const SizedBox(height: 16),
              const SizedBox(
                height: 10.0,
              ),
              _buildTextInputRow(
                label: 'Bio',
                controller: bioController,
                context: context,
              ),
              const SizedBox(height: 16),
              // Add your social media fields here...
              const SizedBox(
                height: 10.0,
              ),
              // MyCustomRowWidget(image: 'assets/google.svg'),
              // const SizedBox(
              //   height: 10.0,
              // ),
              buildSocialsRow(image: 'assets/instagram.svg', controller: userInstaController,),

              const SizedBox(
                height: 10.0,
              ),
              buildSocialsRow(image: 'assets/twitter.svg', controller: userTwitterController,),

              const SizedBox(
                height: 10.0,
              ),
              buildSocialsRow(image: 'assets/facebook.svg', controller: userLinkedinController,),

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
  }){
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
                borderSide: BorderSide(
                    color: Colors.grey
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(){
    return  GestureDetector(
      onTap:  () {
        setState(() {
          isLoading=true;
        });
        List<String> nameParts = nameController.text.split(' ');

        String firstName = nameParts[0];
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        print("Value is:");
        print(userInstaController.text);
        print("Indise");

        ProfileServices().updateBrandProfile(
            userDescription: profileController.text,
            userBio: bioController.text,
            userInsta: userInstaController.text,
            userLinkedin: userLinkedinController.text,
            userTwitter: userTwitterController.text,
            imageFile: isUpdated ? File(_image!.path) : File.fromUri(Uri.parse("")),
            imgUrl: isUpdated? "" : widget.brandProfile.brandProfilePicture! ,
            isUpdated: isUpdated,
            firstName: firstName,
            lastName: lastName
        ).then((value) {
          setState(() {
            isLoading=false;
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
            child:isLoading?
            const CircularProgressIndicator(
              color: Colors.white,
            ) :  Text(
              "Save Changes",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: (24/16).h,
              ),
              textAlign: TextAlign.left,
            )
        ),
      ),
    );
  }

}
