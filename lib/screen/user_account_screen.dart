import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/model/family_member.dart';
import 'package:gia_pha_mobile/model/NBModel.dart';
import 'package:gia_pha_mobile/screen/invite_family_member_screen.dart';
import 'package:gia_pha_mobile/screen/join_family_screen.dart';
import 'package:gia_pha_mobile/utils/NBImages.dart';
import 'package:gia_pha_mobile/utils/NBAppWidget.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final FamilyMember _user = FamilyMember(
    id: 'user123',
    name: 'Robert Fox',
    gender: 0,
    kinship: 'Tổ',
    dateOfBirth: DateTime(1950, 5, 10),
    isDeceased: false,
    avatarUrl: 'images/newsBlog/nb_profile.jpeg',
    spouses: ['user456'],
    children: ['user789'],
  );

  late TextEditingController _nameController;
  late TextEditingController _dobController;
  NBLanguageItemModel? result = NBLanguageItemModel(NBEnglishFlag, 'English');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _user.name);
    _dobController = TextEditingController(
        text: _user.dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(_user.dateOfBirth!)
            : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // This function is kept for language selection, but simplified as it's the only setting.
  Future<void> _selectLanguage() async {
    List<NBLanguageItemModel> languages = [
      NBLanguageItemModel(NBEnglishFlag, 'English'),
      NBLanguageItemModel(NBChineseFlag, 'Chinese'),
      NBLanguageItemModel(NBMelayuFlag, 'Melayu'),
      NBLanguageItemModel(NBFrenchFlag, 'French'),
      NBLanguageItemModel(NBSpainFlag, 'Spanish'),
    ];

    NBLanguageItemModel? selectedLanguage = await showModalBottomSheet<NBLanguageItemModel>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              leading: commonCacheImageWidget(lang.image, 30),
              title: Text(lang.name),
              onTap: () => Navigator.pop(context, lang),
            );
          }).toList(),
        );
      },
    );

    if (selectedLanguage != null) {
      setState(() {
        result = selectedLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Save user data
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Families', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text('Current Family: Dòng họ Nguyễn'), // Replace with actual data
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Switch Family not implemented yet')),
                              );
                            },
                            child: const Text('Switch Family'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InviteFamilyMemberScreen(),
                                ),
                              );
                            },
                            child: const Text('Show QR Code'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const JoinFamilyScreen(),
                                ),
                              );
                            },
                            child: const Text('Scan QR'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Avatar + basic info
              Row(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 84,
                          height: 84,
                          color: Colors.grey.shade200,
                          child: _user.avatarUrl != null && _user.avatarUrl!.isNotEmpty
                              ? Image.asset(_user.avatarUrl!, fit: BoxFit.cover, width: 84, height: 84)
                              : Icon(
                                  _user.gender == 0 ? Icons.male : _user.gender == 1 ? Icons.female : Icons.person,
                                  size: 44,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 15),
                            onPressed: () {
                              // TODO: Implement image picker
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(_user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _dobController,
                        decoration: const InputDecoration(labelText: 'Date of Birth'),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _user.dateOfBirth ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                      ),
                      DropdownButtonFormField<int>(
                        value: _user.gender,
                        decoration: const InputDecoration(labelText: 'Gender'),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Male')),
                          DropdownMenuItem(value: 1, child: Text('Female')),
                          DropdownMenuItem(value: 2, child: Text('Unknown')),
                        ],
                        onChanged: (value) {
                          // TODO: update gender
                        },
                      ),
                      DropdownButtonFormField<bool>(
                        value: _user.isDeceased,
                        decoration: const InputDecoration(labelText: 'Marital Status'),
                        items: const [
                          DropdownMenuItem(value: false, child: Text('Single')),
                          DropdownMenuItem(value: true, child: Text('Married')),
                        ],
                        onChanged: (value) {
                          // TODO: update marital status
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Relationships', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      _buildRelationshipList('Spouses', _user.spouses, showCurrentSpouseCheckbox: true),
                      _buildRelationshipList('Children', _user.children),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Settings', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Language', style: primaryTextStyle()).expand(),
                          Row(
                            children: [
                              commonCacheImageWidget(result!.image, 30),
                              8.width,
                              Text(result!.name, style: primaryTextStyle()),
                              Icon(Icons.navigate_next).paddingAll(8),
                            ],
                          ),
                        ],
                      ).onTap(() {
                        _selectLanguage();
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelationshipList(String title, List<String>? members, {bool showCurrentSpouseCheckbox = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (members == null || members.isEmpty)
          const Text('None')
        else
          ...members.map((member) => Row(
                children: [
                  Text(member),
                  if (showCurrentSpouseCheckbox) ...[
                    Spacer(),
                    Checkbox(value: false, onChanged: (value) {}),
                    Text('Current'),
                  ],
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Implement edit spouse/child
                    },
                  ),
                ],
              )),
        TextButton.icon(
          onPressed: () {
            // TODO: Implement add relationship
          },
          icon: const Icon(Icons.add),
          label: Text('Add $title'),
        ),
        const Divider(),
      ],
    );
  }
}
