# Internship Finder App 🚀

A Flutter application that automatically finds internship/job opportunities based on student eligibility, sends reminders, and provides personalized study plans.

## Features ✨

- **Smart Job Matching**: Automatically filters jobs based on your CGPA, skills, and degree
- **Profile Management**: Complete student profile with education details and skills
- **Job Browsing**: Browse and filter available internships and full-time positions
- **Bookmarks**: Save interesting opportunities for later
- **Reminders**: Set reminders for applications, tests, and interviews
- **Study Plans**: Automatically generate personalized study plans for job preparation
- **Dashboard**: Overview of eligible jobs, reminders, and progress

## Setup Instructions 📋

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Step-by-Step Setup

#### 1. **Install Flutter** (if not already installed)

**For Windows:**
```bash
# Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin
```

**For Mac/Linux:**
```bash
# Install using Homebrew
brew install flutter

# OR download and extract manually
# Add to PATH in ~/.zshrc or ~/.bashrc:
export PATH="$PATH:/path/to/flutter/bin"
```

**Verify Installation:**
```bash
flutter doctor
```

#### 2. **Create Your Project**

Open terminal/command prompt and run:

```bash
# Create new Flutter project
flutter create internship_finder

# Navigate into project
cd internship_finder
```

#### 3. **Replace Files**

Delete the existing `lib` folder and `pubspec.yaml` file, then:

1. Copy the provided `pubspec.yaml` to your project root
2. Copy the entire `lib` folder structure to your project

Your project structure should look like this:
```
internship_finder/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── student.dart
│   │   ├── job.dart
│   │   ├── reminder.dart
│   │   └── study_plan.dart
│   ├── providers/
│   │   └── app_provider.dart
│   ├── screens/
│   │   ├── profile_setup_screen.dart
│   │   ├── home_screen.dart
│   │   ├── jobs_screen.dart
│   │   ├── job_details_screen.dart
│   │   ├── bookmarks_screen.dart
│   │   ├── reminders_screen.dart
│   │   ├── study_plan_screen.dart
│   │   └── profile_screen.dart
│   └── widgets/
│       ├── job_card.dart
│       └── reminder_card.dart
└── pubspec.yaml
```

#### 4. **Install Dependencies**

```bash
flutter pub get
```

This will install all required packages:
- provider (state management)
- intl (date formatting)
- google_fonts (typography)
- shared_preferences (local storage - for future use)

#### 5. **Run the App**

**On Emulator:**
```bash
# Start Android emulator first, then:
flutter run
```

**On Physical Device:**
```bash
# Enable USB debugging on your phone
# Connect phone via USB
flutter devices  # to see connected devices
flutter run
```

**On Web (for testing):**
```bash
flutter run -d chrome
```

## How to Use the App 📱

### First Time Setup
1. **Launch the app** - You'll see a splash screen
2. **Create your profile:**
   - Enter your name, email, and contact details
   - Select your college and degree
   - Set your graduation year
   - Adjust CGPA slider
   - Select your skills (at least one)
   - Add a bio (optional)
   - Click "Create Profile"

### Using the App

#### Home Dashboard
- View statistics (eligible jobs, bookmarks, reminders)
- See overdue reminders
- Browse recommended jobs
- Quick access to all features

#### Jobs Tab
- Browse all eligible jobs
- Filter by job type (All/Internship/Full-time)
- Filter by minimum CGPA
- Click on any job to see details

#### Job Details
- View complete job information
- Set reminders for applications/tests
- Create study plans automatically
- Bookmark jobs
- Apply (opens application link)

#### Bookmarks Tab
- View all saved jobs
- Quick access to bookmarked opportunities

#### Reminders Tab
- Three sections: Upcoming, Overdue, Completed
- Mark reminders as complete
- Delete reminders
- Color-coded for urgency

#### Study Plans
- Automatically generated based on job requirements
- Daily breakdown of topics to study
- Track progress with checkboxes
- View completion percentage

#### Profile Tab
- View your complete profile
- See statistics
- Edit profile information
- Update skills and qualifications

## App Architecture 🏗️

### State Management
- **Provider**: Centralized state management
- All app data managed through `AppProvider`

### Models
- `Student`: User profile data
- `Job`: Job/internship listings
- `Reminder`: Application reminders
- `StudyPlan`: Personalized study schedules

### Key Features Implementation

**Job Matching Algorithm:**
- Compares student CGPA with minimum requirement
- Matches student skills with required skills
- Checks degree eligibility
- Filters inactive or expired jobs

**Study Plan Generation:**
- Analyzes deadline
- Distributes topics evenly across available days
- Creates daily learning schedule
- Tracks completion progress

## Sample Data 📊

The app comes with 6 sample jobs:
1. Google - Software Development Intern
2. Microsoft - Frontend Developer
3. Amazon - Data Science Intern
4. Flipkart - Mobile App Developer
5. Zomato - Backend Developer Intern
6. Swiggy - Full Stack Developer

All sample jobs have realistic requirements and deadlines.

## Customization 🎨

### Adding More Jobs
In `lib/providers/app_provider.dart`, add to `initializeSampleData()`:

```dart
Job(
  id: '7',
  title: 'Your Job Title',
  company: 'Company Name',
  description: 'Job description...',
  location: 'City, Country',
  type: 'Internship', // or 'Full-time'
  minCgpa: 7.0,
  requiredSkills: ['Skill1', 'Skill2'],
  eligibleDegrees: ['B.Tech', 'B.E'],
  deadline: DateTime.now().add(Duration(days: 30)),
  salary: '₹50,000/month',
  applyLink: 'https://example.com/apply',
),
```

### Changing Colors
In `lib/main.dart`, modify the theme:

```dart
theme: ThemeData(
  primarySwatch: Colors.purple, // Change primary color
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple, // Change to your color
  ),
),
```

### Adding More Skills
In `profile_setup_screen.dart` and `profile_screen.dart`, add to `_skillOptions`:

```dart
final List<String> _skillOptions = [
  'Flutter',
  'Your New Skill',
  // ... existing skills
];
```

## Future Enhancements 🔮

Ready for Firebase integration:
1. **Authentication**: User login/signup
2. **Cloud Firestore**: Store jobs and user data
3. **Push Notifications**: Real-time reminder alerts
4. **Cloud Functions**: Automatic job matching
5. **Analytics**: Track user engagement

## Troubleshooting 🔧

**Issue: "Packages not found"**
```bash
flutter pub get
flutter clean
flutter pub get
```

**Issue: "Build failed"**
```bash
flutter clean
flutter pub get
flutter run
```

**Issue: "Provider error"**
Make sure you've wrapped the app with `ChangeNotifierProvider` in `main.dart`

**Issue: "Null check operator used on null value"**
Ensure you've created a profile before accessing main features

## Learning Resources 📚

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

## Credits 👨‍💻

Built with Flutter & ❤️

## License 📄

This project is created for educational purposes.

---

**Need Help?** Check the Flutter documentation or the code comments for detailed explanations.

**Ready to Deploy?** Follow the [Flutter deployment guide](https://docs.flutter.dev/deployment) for Android/iOS.
