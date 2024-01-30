import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/App%20Constants/colorManager.dart';
import 'package:lookbook/App%20Constants/launchingFunctions.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Services/profiles.dart';
import 'applicationModel.dart';


class AllAplicationsScreen extends StatefulWidget {
  final String jobId;

  AllAplicationsScreen({
   required this.jobId,
});

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
                          userId: application.userId,
                          jobId: widget.jobId,
                          status: application.statusOfApplication,
                          application: application,
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
  final String userId;
  final String jobId;
  final String status;
  final applicationModel application;

  CandidateCard({
   required this.jobType,
   required this.name,
    required this.workString,
    required this.educationString,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.application,
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
        return ColorsManager.darkRed;
      case 'Shortlist':
        return ColorsManager.darkOrange;
      case 'Accept':
        return ColorsManager.darkGreen;
      default:
        return Colors.grey;
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

  void initState() {
    super.initState();
    // Set the initial selected button based on the status
    switch (widget.status) {
      case "Accepted":
        selectedButton = "Accept";
        break;
      case "Shortlisted":
        selectedButton = "Shortlist";
        break;
      case "Rejected":
        selectedButton = "Reject";
        break;
      default:
        selectedButton = ""; // No button selected
        break;
    }
  }

  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(6.0),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  elevation: 4,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.none,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: widget.application.userPfp!.isNotEmpty? Colors.white : Colors.transparent,
                    child: widget.application.userPfp != null && widget.application.userPfp.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: widget.application.userPfp!, // Actual image URL
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 25,
                        backgroundImage: imageProvider,
                      ),
                    )
                        : CircleAvatar( // Fallback to asset image
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset("assets/devil.svg", fit: BoxFit.cover, height: 80, width: 80,), // Provide the path to your asset image
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0f1015),
                      height: 20/18,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.jobType,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff8b8b8b),
                      height: 18/12,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],),
                Spacer(),
                InkWell(
                  onTap: (){
                    LaunchingFunction().launchWhatsApp(widget.application.userPhoneNumber);
                  },
                    child: SvgPicture.asset("assets/callVector.svg", color: Colors.black,)),
                SizedBox(width: 5,),
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    // Handle the action based on the value selected
                    switch (value) {
                      case 'Share':
                      // Code to share
                        break;
                      case 'Email':
                      // Code to send an email
                        break;
                      case 'Call':
                      // Code to make a call
                        LaunchingFunction().launchPhoneDialer(widget.application.userPhoneNumber);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Share',
                      child: Text('Share'),
                    ),
                     PopupMenuItem<String>(
                      value: 'Email',
                      child: Text('Email'),
                      onTap: (){
                        LaunchingFunction().launchGmail(widget.application.userGmail, "subject", "body");
                      },
                    ),
                     PopupMenuItem<String>(
                      value: 'Call',
                      child: Text('Call'),
                      onTap: (){
                        LaunchingFunction().launchPhoneDialer(widget.application.userPhoneNumber);
                      },
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                )

              ],
            ),
            SizedBox(height: 16,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Worked at",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1a1a1a),
                  height: 19/16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
             SizedBox(height: 4,),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.workString,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1a1a1a),
                  // height: 21/13,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 13,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Education",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1a1a1a),
                  height: 19/16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 4,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.educationString,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1a1a1a),
                  // height: 21/13,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 9,),
            Divider(height: 1, thickness: 1,color: ColorsManager.greyishColor,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (String buttonType in ['Reject', 'Shortlist', 'Accept'])
                  _selectableButton(buttonType),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _selectableButton(String buttonType) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          icon: Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedButton == buttonType? Colors.white : _getButtonColor(buttonType)
              )
            ),
            child: Icon(
              _getButtonIcon(buttonType),
              size: 16,
              color: selectedButton == buttonType? Colors.white : _getButtonColor(buttonType) ,
            ),
          ),
          label: Text(
            buttonType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selectedButton == buttonType? Colors.white : _getButtonColor(buttonType)
            ),
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () async{
            setState(() {
              selectedButton = buttonType;
            });
            print("widget.jobId");
            print(widget.jobId);
            print("widget.userId");
            print(widget.userId);
            String status="";
            if(buttonType=="Accept"){
              status="Accepted";
            }
            else if(buttonType=="Shortlist"){
              status="Shortlisted";
            }
            else if(buttonType=="Reject"){
              status="Rejected";
            }
            else{
              status="Pending";
            }
            await ProfileServices().updateApplicationStatus(widget.jobId, widget.userId, status,widget.application.userId);

          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: selectedButton == buttonType
                ? _getButtonColor(buttonType) // Selected color
                : Colors.white, // Unselected color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Reduced padding
          ),
        ),
      ),
    );
  }
}
