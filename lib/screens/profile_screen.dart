import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/student.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final student = provider.student!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(student: student),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Text(
                      student.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    student.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    student.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Education Info
            _ProfileSection(
              title: 'Education',
              children: [
                _ProfileItem(
                  icon: Icons.school,
                  label: 'College',
                  value: student.college,
                ),
                _ProfileItem(
                  icon: Icons.book,
                  label: 'Degree',
                  value: student.degree,
                ),
                _ProfileItem(
                  icon: Icons.calendar_today,
                  label: 'Graduation Year',
                  value: student.graduationYear.toString(),
                ),
                _ProfileItem(
                  icon: Icons.grade,
                  label: 'CGPA',
                  value: student.cgpa.toStringAsFixed(1),
                ),
              ],
            ),
            
            // Contact Info
            if (student.phoneNumber != null)
              _ProfileSection(
                title: 'Contact',
                children: [
                  _ProfileItem(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: student.phoneNumber!,
                  ),
                ],
              ),
            
            // Skills
            _ProfileSection(
              title: 'Skills',
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: student.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: Colors.blue[50],
                        labelStyle: TextStyle(color: Colors.blue[700]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            
            // Bio
            if (student.bio != null)
              _ProfileSection(
                title: 'About Me',
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      student.bio!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            
            SizedBox(height: 24),
            
            // Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Eligible Jobs',
                      value: provider.eligibleJobs.length.toString(),
                      icon: Icons.work,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Bookmarked',
                      value: provider.bookmarkedJobs.length.toString(),
                      icon: Icons.bookmark,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Reminders',
                      value: provider.reminders.length.toString(),
                      icon: Icons.notifications,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Study Plans',
                      value: provider.studyPlans.length.toString(),
                      icon: Icons.menu_book,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        SizedBox(height: 16),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  final Student student;

  const EditProfileScreen({Key? key, required this.student}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _collegeController;
  late TextEditingController _bioController;
  late String _selectedDegree;
  late int _graduationYear;
  late double _cgpa;
  late List<String> _selectedSkills;

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _emailController = TextEditingController(text: widget.student.email);
    _phoneController = TextEditingController(text: widget.student.phoneNumber ?? '');
    _collegeController = TextEditingController(text: widget.student.college);
    _bioController = TextEditingController(text: widget.student.bio ?? '');
    _selectedDegree = widget.student.degree;
    _graduationYear = widget.student.graduationYear;
    _cgpa = widget.student.cgpa;
    _selectedSkills = List.from(widget.student.skills);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                  labelText: 'College',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDegree,
                decoration: InputDecoration(
                  labelText: 'Degree',
                  prefixIcon: Icon(Icons.library_books),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _degreeOptions
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedDegree = value!),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _graduationYear,
                decoration: InputDecoration(
                  labelText: 'Graduation Year',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: List.generate(
                  6,
                  (i) => DateTime.now().year + i,
                ).map((year) => DropdownMenuItem(value: year, child: Text('$year'))).toList(),
                onChanged: (value) => setState(() => _graduationYear = value!),
              ),
              SizedBox(height: 16),
              Text('CGPA: ${_cgpa.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 16)),
              Slider(
                value: _cgpa,
                min: 0,
                max: 10,
                divisions: 100,
                label: _cgpa.toStringAsFixed(1),
                onChanged: (value) => setState(() => _cgpa = value),
              ),
              SizedBox(height: 16),
              Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.info),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save Changes',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() && _selectedSkills.isNotEmpty) {
      final updatedStudent = Student(
        id: widget.student.id,
        name: _nameController.text,
        email: _emailController.text,
        college: _collegeController.text,
        degree: _selectedDegree,
        graduationYear: _graduationYear,
        cgpa: _cgpa,
        skills: _selectedSkills,
        phoneNumber:
            _phoneController.text.isEmpty ? null : _phoneController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
      );

      Provider.of<AppProvider>(context, listen: false)
          .updateStudent(updatedStudent);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _collegeController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
