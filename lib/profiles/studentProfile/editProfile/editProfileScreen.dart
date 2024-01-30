import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String userType = 'A person';
  String profileType = 'Student';
  String lookingFor = 'Looking for a job';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff0f1015),
            height: 20 / 16,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(),
            NameInput(),
            RadioButtonSection(
              title: 'I am',
              value: userType,
              onChanged: (String? newValue) {
                setState(() {
                  userType = newValue!;
                });
              },
            ),
            ProfileDropdown(
              selectedValue: profileType,
              onChanged: (String? newValue) {
                setState(() {
                  profileType = newValue!;
                });
              },
            ),
            BioInput(),
            RadioButtonSection(
              title: 'I am',
              value: lookingFor,
              onChanged: (String? newValue) {
                setState(() {
                  lookingFor = newValue!;
                });
              },
            ),
            SocialLinksSection(),
            SaveButton(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 64, // Adjust radius to fit your design
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with your image path
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                // Handle profile picture change
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextFormField(
        initialValue: 'Srishti Doshi', // Replace with the actual name
        decoration: InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class RadioButtonSection extends StatelessWidget {
  final String title;
  final String value;
  final ValueChanged<String?> onChanged;

  RadioButtonSection({required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          trailing: Radio<String>(
            value: 'A company',
            groupValue: value,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          trailing: Radio<String>(
            value: 'A person',
            groupValue: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class ProfileDropdown extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  ProfileDropdown({required this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: <String>['Student', 'Professional', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Profile',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class BioInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        initialValue: 'Hello, I am a Lorem ipsum dolor sit amet...', // Replace with the actual bio
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          labelText: 'Bio',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle save action
        },
        child: Text('Save Changes'),
      ),
    );
  }
}

class SocialLinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.linked_camera),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.radio),
            onPressed: () {},
          ),
          // Add more icons as needed
        ],
      ),
    );
  }
}
