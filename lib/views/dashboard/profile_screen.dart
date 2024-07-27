import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/future/profile_futures.dart';
import 'package:woundwise/models/profile_model.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/profile/add_practitioner_screen.dart';
import 'package:woundwise/views/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: ProfileFutures.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 3));
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          final profile = snapshot.data as ProfileModel;
          return Column(
            children: [
              _ProfileWidget(reload: reload, profile: profile),
              const Spacer(),
              _EditProfileButton(profile: profile, reload: reload),
              const SizedBox(height: 10),
            ],
          );
        }
      },
    );
  }
}

class _ProfileWidget extends StatelessWidget {
  const _ProfileWidget({required this.reload, required this.profile});
  final Function() reload;
  final ProfileModel profile;

  Future<AccountType> checkAccountType() async {
    final userData = await StorageServices.getUserData();
    if (userData.accountType != null) {
      return userData.accountType!;
    } else {
      throw 'Account type not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        reload();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _ProfilePicture(profileImageUrl: profile.profileImageUrl),
            const SizedBox(height: 20),
            Text(
              profile.name ?? 'Unknown',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (profile.departments != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  profile.departments ?? "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            FutureBuilder<AccountType>(
                future: checkAccountType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else {
                    final accountType = snapshot.data as AccountType;
                    if (accountType == AccountType.organization) {
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Add Medical Practitioner',
                          style: TextStyle(),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddPractitionerScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(height: 0, width: 0);
                    }
                  }
                }),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard(
                      title: 'Patients',
                      icon: Icons.person,
                      value: '${profile.patientCounts ?? 0}+'),
                  _buildInfoCard(
                    title: 'Location',
                    icon: Icons.location_on,
                    value: '${profile.location}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile.about ?? "No information available",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: Colors.blue.shade700,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture({required this.profileImageUrl});
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: (profileImageUrl != null)
            ? CachedNetworkImage(
                imageUrl: profileImageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildDemoPicture(),
                errorWidget: (context, url, error) => _buildDemoPicture(),
              )
            : _buildDemoPicture(),
      ),
    );
  }

  Widget _buildDemoPicture() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.profile, required this.reload});
  final ProfileModel profile;
  final Function() reload;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(profile: profile),
                ),
              ).then((value) {
                if (value == true) reload();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Edit profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
