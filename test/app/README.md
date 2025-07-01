# Adjust Flutter Test App

A comprehensive test application for the Adjust Flutter SDK, designed to validate SDK functionality through automated testing.

## Features

- **Automated Test Execution**: Connects to test framework for automated SDK testing
- **Modern UI**: Clean, modern interface following Adjust design guidelines
- **Cross-Platform**: Supports both Android and iOS testing scenarios
- **Real-time Command Processing**: Executes test commands in real-time from test server

## Getting Started

1. **Prerequisites**: Make sure Flutter is installed and configured
2. **Install Dependencies**: Run `flutter pub get` in this directory
3. **Configure Test Server**: Update IP addresses in `main.dart` if needed
4. **Run the App**: Use `flutter run` to start the test application

## Test Configuration

The app connects to a test server for automated command execution:
- **Android**: Uses HTTPS connection on port 8443
- **iOS**: Uses HTTP connection on port 8080
- **WebSocket**: Control connection on port 1987

## Architecture

- `main.dart`: Main app entry point with modern UI
- `command.dart`: Command parsing and representation
- `command_executor.dart`: SDK method execution engine
- Test framework integration via `test_lib` package

## Usage

1. Launch the app
2. Tap "Start Test Session" to begin automated testing
3. The app will connect to the test server and execute commands automatically
4. Monitor console output for test execution details
