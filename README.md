# Flutter Machine Test - Vikncodes

A comprehensive Flutter application demonstrating modern mobile development practices with authentication, dashboard, sales management, and user profile features.

## 🚀 Features

### 🔐 Authentication System
- **Secure Login**: JWT-based authentication with secure token storage
- **Session Management**: Persistent login state across app restarts
- **Input Validation**: Form validation with error handling
- **Auto-logout**: Session expiration handling

### 📊 Dashboard
- **Revenue Analytics**: Interactive charts with FL Chart
- **Quick Stats**: Booking and invoice overview cards
- **Date Navigation**: Interactive date selector for data filtering
- **Real-time Data**: Dynamic user profile integration

### 💰 Sales Management
- **Sales List**: Paginated sales data with search functionality
- **Advanced Filtering**: Multi-criteria filtering system
- **Search**: Real-time search with debounced input
- **Loading States**: Shimmer effects for better UX

### 👤 User Profile
- **Profile Display**: Dynamic user information from API
- **KYC Status**: Verification status display
- **Ride Statistics**: User ride history and ratings
- **Responsive Design**: Adaptive layout for all screen sizes

### 🎨 UI/UX Features
- **Modern Design**: Dark theme with gradient backgrounds
- **Custom Components**: Reusable widget library
- **Responsive Layout**: Adaptive design for all devices
- **Smooth Animations**: Loading states and transitions
- **SVG Icons**: Scalable vector graphics throughout

## 🛠️ Technical Architecture

### State Management
- **Provider Pattern**: Clean and efficient state management
- **Multiple Providers**: Auth, User, Sales, and Filter providers
- **Reactive UI**: Automatic UI updates on state changes

### API Integration
- **RESTful APIs**: Integration with Vikncodes APIs
- **Secure Communication**: JWT token authentication
- **Error Handling**: Comprehensive error management
- **Retry Logic**: Exponential backoff for failed requests

### Security Features
- **Token Storage**: Secure local storage using SharedPreferences
- **HTTPS Only**: All API communications encrypted
- **Input Validation**: Protection against injection attacks
- **Session Management**: Automatic logout on token expiry

### Performance Optimizations
- **Lazy Loading**: Efficient list rendering
- **Image Caching**: Network image optimization
- **Memory Management**: Proper widget disposal
- **Selective Rebuilds**: Optimized Provider usage

## 📱 Screens

1. **Login Screen**: Authentication with form validation
2. **Dashboard**: Main navigation with analytics
3. **Sales List**: Paginated sales data with search
4. **Filter Screen**: Advanced filtering options
5. **Profile Screen**: User information and settings

## 🔧 Dependencies

- `provider: ^6.1.5+1` - State management
- `http: ^1.6.0` - HTTP requests
- `shared_preferences: ^2.5.3` - Local storage
- `google_fonts: ^6.3.2` - Typography
- `fl_chart: ^0.65.0` - Data visualization
- `flutter_svg: ^2.2.3` - SVG icons
- `shimmer: ^3.0.0` - Loading animations

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android/iOS development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sanjayvkp/machine_test_vkn.git
   cd machine_test_vkn
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   ```

## 📋 API Endpoints

### Authentication
- **Login**: `POST https://api.accounts.vikncodes.com/api/v1/users/login`
- **Payload**: `{username, password, is_mobile: true}`
- **Response**: JWT token and user ID

### Sales Data
- **Sales List**: `POST https://api.viknbooks.com/api/v10/sales/sale-list-page/`
- **Pagination**: Page-based with configurable items per page

### User Profile
- **Profile Data**: `GET https://api.viknbooks.com/api/v10/users/user-view/{userID}/`

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── api_service.dart      # API communication
│   ├── app_colors.dart       # Theme constants
│   └── secure_storage.dart   # Session management
├── models/
│   └── sale_item.dart        # Data models
├── providers/
│   ├── auth_provider.dart    # Authentication state
│   ├── sales_provider.dart   # Sales data state
│   ├── user_provider.dart    # User profile state
│   └── filter_provider.dart  # Filter state
├── screens/
│   ├── login_screen.dart     # Authentication UI
│   ├── main_screen.dart      # Navigation container
│   ├── dashboard_tab.dart    # Main dashboard
│   ├── sale_list_screen.dart # Sales listing
│   ├── profile_tab.dart      # User profile
│   └── filter_screen.dart    # Filter functionality
└── widgets/                  # Reusable UI components
```

## 🧪 Testing

The application follows comprehensive testing practices:
- **Unit Tests**: Provider logic and API service testing
- **Widget Tests**: UI component validation
- **Integration Tests**: End-to-end flow testing

## 🎯 Features Demonstrated

- **Modern Flutter Architecture**: Clean, scalable code structure
- **State Management**: Provider pattern implementation
- **API Integration**: RESTful API communication
- **Authentication**: Secure JWT-based auth system
- **Responsive Design**: Adaptive UI for all screen sizes
- **Performance**: Optimized rendering and memory usage
- **Error Handling**: Comprehensive error management
- **Security**: Best practices for mobile app security

## 📱 Platform Support

- **Android**: Fully supported with Material Design
- **iOS**: Compatible with Cupertino design patterns
- **Web**: Responsive web application support
- **Desktop**: Windows, macOS, and Linux support

## 🔐 Security Considerations

- JWT token-based authentication
- Secure local storage for sensitive data
- HTTPS-only API communications
- Input validation and sanitization
- Session timeout handling

## 📊 Performance Metrics

- **Startup Time**: Optimized app initialization
- **Memory Usage**: Efficient memory management
- **Network Requests**: Optimized API calls with caching
- **UI Performance**: Smooth 60fps animations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

Created by Sanjayvkp as a demonstration of Flutter development capabilities.

---

**Built with ❤️ using Flutter**
