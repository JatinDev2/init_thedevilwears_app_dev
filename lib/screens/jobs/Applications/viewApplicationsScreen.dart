import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

import '../../../Services/profiles.dart';
import 'applicationModel.dart';


class AllAplicationsScreen extends StatefulWidget {
  final String jobId;

  AllAplicationsScreen({
   required this.jobId,
});

  // const AllAplicationsScreen({super.key});

  @override
  State<AllAplicationsScreen> createState() => _AllAplicationsScreenState();
}

class _AllAplicationsScreenState extends State<AllAplicationsScreen> {
  List filters=["All","Shortlisted","Accepted","Rejected","Pending"];
  String selectedFilter="All";
  int _selectedChipIndex=0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Applications for listing",
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
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              height: 50.0, // Set a fixed height for the container
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filters[index]),
                      selected: _selectedChipIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedChipIndex = selected ? index : 0;
                          selectedFilter = filters[_selectedChipIndex]; // Update the selected filter
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: _selectedChipIndex == index
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyText1?.color,
                      ),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  );
                },
              ),
            ),
            // FutureBuilder to build the UI based on the fetched applications
            Expanded(
              child: StreamBuilder<List<applicationModel>>(
                stream: ProfileServices().fetchApplicationsStream(widget.jobId), // Adjust the name of your service and stream method
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No applications found'));
                  } else {
                    // Filter the list of applications based on the selected filter
                    List<applicationModel> filteredApplications = snapshot.data!
                        .where((application) {
                      switch (selectedFilter) {
                        case "All":
                          return true;
                        case "Shortlisted":
                          return application.statusOfApplication == "Shortlisted";
                        case "Accepted":
                          return application.statusOfApplication == "Accepted";
                        case "Rejected":
                          return application.statusOfApplication == "Rejected";
                        case "Pending":
                          return application.statusOfApplication == "Pending";
                        default:
                          return true;
                      }
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredApplications.length,
                      itemBuilder: (context, index) {
                        // Build a widget for each application
                        applicationModel application = filteredApplications[index];
                        return CandidateCard(
                          name: application.appliedBy,
                          jobType: application.jobProfile,
                          workString: application.workedAt,
                          educationString: application.education,

                        );
                      },
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );

  }
}



class CandidateCard extends StatefulWidget {
  final String name;
  final String educationString;
  final String workString;
  final String jobType;

  CandidateCard({
   required this.jobType,
   required this.name,
    required this.workString,
    required this.educationString,
});

  @override
  State<CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<CandidateCard> {
  String selectedButton="";

  Color _getButtonColor(String buttonType) {
    // Define colors for different buttons
    switch (buttonType) {
      case 'Reject':
        return Colors.red;
      case 'Shortlist':
        return Colors.orange;
      case 'Accept':
        return Colors.green;
      default:
        return Colors.white; // Default color
    }
  }

  IconData _getButtonIcon(String buttonType) {
    // Define icons for different buttons
    switch (buttonType) {
      case 'Reject':
        return Icons.close;
      case 'Shortlist':
        return Icons.add;
      case 'Accept':
        return Icons.check;
      default:
        return Icons.help; // Default icon
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                // Replace with your network image or asset
                backgroundImage: AssetImage('assets/avatar.jpg'),
              ),
              title: Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(widget.jobType),
              trailing: Icon(Icons.phone, color: Colors.grey),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Worked at', style: TextStyle(color: Colors.grey)),
            ),
            Text(widget.workString),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text('Education', style: TextStyle(color: Colors.grey)),
            ),
            Text(widget.educationString),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SelectableButton(
                  //   text: 'Reject',
                  //   isSelected: selectedButton == 'Reject',
                  //   onSelect: () {
                  //     Future.delayed(Duration.zero, () {
                  //       setState(() {
                  //         selectedButton = 'Reject';
                  //       });
                  //     });
                  //   },
                  // ),
                  // SelectableButton(
                  //   text: 'Shortlist',
                  //   isSelected: selectedButton == 'Shortlist',
                  //   onSelect: () {
                  //     Future.delayed(Duration.zero, () {
                  //       setState(() {
                  //         selectedButton = 'Shortlist';
                  //       });
                  //     });
                  //   },
                  // ),
                  // SelectableButton(
                  //   text: 'Accept',
                  //   isSelected: selectedButton == 'Accept',
                  //   onSelect: () {
                  //     Future.delayed(Duration.zero, () {
                  //       setState(() {
                  //         selectedButton = 'Accept';
                  //       });
                  //     });
                  //   },
                  // ),
                  for (String buttonType in ['Reject', 'Shortlist', 'Accept'])
                    _selectableButton(buttonType),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _selectableButton(String buttonType) {
    return ElevatedButton.icon(
      icon: Icon(
        _getButtonIcon(buttonType),
        color: Colors.white,
      ),
      label: Text(buttonType),
      onPressed: () {
        setState(() {
          selectedButton = buttonType;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedButton == buttonType
            ? _getButtonColor(buttonType) // Selected color
            : Colors.white, // Unselected color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

}

class SelectableButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onSelect;

  const SelectableButton({
    // Key key,
    required this.text,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? Colors.green : Colors.grey[300],
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: onSelect(),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
