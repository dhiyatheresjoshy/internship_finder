import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _collegeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  
  String _selectedDegree = 'B.Tech';
  int _graduationYear = DateTime.now().year;
  double _cgpa = 7.0;
  List<String> _selectedSkills = [];

  final List<String> _degreeOptions = [
    'B.Tech',
    'B.E',
    'BCA',
    'MCA',
    'M.Tech',
    'B.Sc',
    'M.Sc',
    'Other'
  ];

  final List<String> _skillOptions = [
    'Flutter',
    'Dart',
    'React',
    'JavaScript',
    'Python',
    'Java',
    'Node.js',
    'MongoDB',
    'Firebase',
    'SQL',
    'Machine Learning',
    'Data Science',
    'UI/UX',
    'Mobile Development',
    'REST APIs',
    'Git',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Profile'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s get to know you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Fill in your details to get personalized job recommendations',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 24),
              
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // College
              TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                  labelText: 'College/University *',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your college';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Degree
              DropdownButtonFormField<String>(
                value: _selectedDegree,
                decoration: InputDecoration(
                  labelText: 'Degree *',
                  prefixIcon: Icon(Icons.library_books),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _degreeOptions.map((degree) {
                  return DropdownMenuItem(value: degree, child: Text(degree));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDegree = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              
              // Graduation Year
              DropdownButtonFormField<int>(
                value: _graduationYear,
                decoration: InputDecoration(
                  labelText: 'Graduation Year *',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: List.generate(6, (index) {
                  int year = DateTime.now().year + index;
                  return DropdownMenuItem(value: year, child: Text('$year'));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _graduationYear = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              
              // CGPA
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CGPA: ${_cgpa.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Slider(
                    value: _cgpa,
                    min: 0,
                    max: 10,
                    divisions: 100,
                    label: _cgpa.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _cgpa = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Skills
              Text(
                'Skills *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skillOptions.map((skill) {
                  bool isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                    selectedColor: Colors.blue[100],
                    checkmarkColor: Colors.blue[700],
                  );
                }).toList(),
              ),
              if (_selectedSkills.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select at least one skill',
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
              SizedBox(height: 16),
              
              // Bio
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio (Optional)',
                  hintText: 'Tell us about yourself...',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Profile',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one skill')),
        );
        return;
      }

      final student = Student(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        college: _collegeController.text,
        degree: _selectedDegree,
        graduationYear: _graduationYear,
        cgpa: _cgpa,
        skills: _selectedSkills,
        phoneNumber: _phoneController.text.isEmpty ? null : _phoneController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
      );

      Provider.of<AppProvider>(context, listen: false).setStudent(student);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _collegeController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
