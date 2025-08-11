#!/usr/bin/env python3
"""
Build Script for Adjust Flutter SDK

This script builds JAR files from the SDK submodules and replaces existing ones.

Usage:
    python3 build.py android test
    python3 build.py android test --verbose
    python3 build.py ios test
"""

import os
import sys
import subprocess
import shutil
import argparse
from pathlib import Path


class Colors:
    """Terminal color codes for output formatting."""
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'
    
    @staticmethod
    def disable():
        """disable colors for non-terminal output"""
        Colors.RED = ''
        Colors.GREEN = ''
        Colors.YELLOW = ''
        Colors.BLUE = ''
        Colors.MAGENTA = ''
        Colors.CYAN = ''
        Colors.WHITE = ''
        Colors.BOLD = ''
        Colors.UNDERLINE = ''
        Colors.END = ''


class SDKBuilder:
    def __init__(self, platform, target, verbose=False):
        self.platform = platform.lower()
        self.target = target.lower()
        self.verbose = verbose
        
        # disable colors if not running in a terminal
        if not sys.stdout.isatty():
            Colors.disable()
        
        # get the root directory of the Flutter SDK (parent of scripts)
        self.flutter_root = Path(__file__).parent.parent.absolute()
        
        if self.platform == "android":
            self.sdk_path = self.flutter_root / "ext" / "android" / "sdk" / "Adjust"
            self.test_libs_path = self.flutter_root / "test" / "android" / "libs"
            if self.target == "test":
                self.test_targets = ["test-library", "test-options"]
            else:
                self._print_error(f"Unsupported target '{target}' for Android platform. Use 'test'")
                sys.exit(1)
        elif self.platform == "ios":
            self.sdk_path = self.flutter_root / "ext" / "ios" / "sdk"
            self.test_libs_path = self.flutter_root / "test" / "ios"
            if self.target == "test":
                self.test_targets = ["test-library"]
            else:
                self._print_error(f"Unsupported target '{target}' for iOS platform. Use 'test'")
                sys.exit(1)
        else:
            self._print_error(f"Unsupported platform '{platform}'. Supported: android, ios")
            sys.exit(1)
            
        self._print_config()

    def _print_config(self):
        """print build configuration in a table format"""
        
        # configuration data
        config_data = [
            ("Platform", self.platform, Colors.CYAN),
            ("Target", self.target, Colors.CYAN),
            ("Verbose", str(self.verbose), Colors.CYAN),
            ("Flutter SDK root", str(self.flutter_root), Colors.BLUE),
            ("SDK path", str(self.sdk_path), Colors.BLUE),
            ("Test libs path", str(self.test_libs_path), Colors.BLUE),
            ("Test targets", ", ".join(self.test_targets), Colors.CYAN)
        ]
        
        # calculate max width for each column
        max_label_width = max(len(label) for label, _, _ in config_data)
        max_value_width = max(len(str(value)) for _, value, _ in config_data)
        
        # table formatting
        border_char = "─"
        vertical_char = "│"
        
        # calculate actual table width needed
        table_width = max_label_width + max_value_width + 5  # label + colon + space + value + padding
        
        # print top border
        print(f"  ┌{border_char * table_width}┐")
        
        # print each configuration row
        for label, value, color in config_data:
            label_with_colon = f"{label}:"
            # pad the entire row content to fit within the table width
            row_content = f" {label_with_colon:<{max_label_width + 1}} {color}{value}{Colors.END}"
            # calculate padding needed (accounting for color codes that don't take visual space)
            visual_length = len(f" {label_with_colon:<{max_label_width + 1}} {value}")
            padding_needed = table_width - visual_length
            print(f"  {vertical_char}{row_content}{' ' * padding_needed}{vertical_char}")
        
        # print bottom border
        print(f"  └{border_char * table_width}┘")

    def _print_brewing(self, action, item):
        """print a brew-style action message"""
        print(f"{Colors.CYAN}==> {Colors.BOLD}{action}{Colors.END} {item}")

    def _print_copying(self, source_path, target_path):
        """print a copying message with hourglass showing full paths"""
        print(f"{Colors.YELLOW}⏳ {Colors.BOLD}Copying{Colors.END}")
        print(f"   From: {Colors.BLUE}{source_path}{Colors.END}")
        print(f"   To:   {Colors.BLUE}{target_path}{Colors.END}")

    def _print_success(self, message):
        """print a success message with green formatting"""
        print(f"{Colors.GREEN}✓{Colors.END} {message}")

    def _print_error(self, message):
        """print an error message with red formatting"""
        print(f"{Colors.RED}✗ Error:{Colors.END} {message}")

    def _print_progress(self, message):
        """print a progress message with hourglass"""
        print(f"{Colors.YELLOW}⏳{Colors.END} {message}")

    def check_prerequisites(self):
        """check if all required directories and files exist"""
        self._print_brewing("Checking", "prerequisites")
        
        checks = []
        
        # check SDK submodule
        if self.sdk_path.exists():
            checks.append(("SDK submodule", self.sdk_path, True))
        else:
            checks.append(("SDK submodule", self.sdk_path, False))
            
        if self.platform == "android":
            # check for gradlew
            gradlew_path = self.sdk_path / "gradlew"
            if gradlew_path.exists():
                checks.append(("Gradle wrapper", gradlew_path, True))
            else:
                checks.append(("Gradle wrapper", gradlew_path, False))
                
            # check for test projects
            for target in self.test_targets:
                test_project_path = self.sdk_path / "tests" / target
                if test_project_path.exists():
                    checks.append((f"{target} project", test_project_path, True))
                else:
                    checks.append((f"{target} project", test_project_path, False))
                    
        elif self.platform == "ios":
            # iOS specific checks would go here
            # check for the iOS SDK build script
            build_script_path = self.sdk_path / "scripts" / "build_frameworks.sh"
            if build_script_path.exists():
                checks.append(("iOS build script", build_script_path, True))
            else:
                checks.append(("iOS build script", build_script_path, False))
                
            # check for test library project
            test_lib_project_path = self.sdk_path / "AdjustTests" / "AdjustTestLibrary"
            if test_lib_project_path.exists():
                checks.append(("iOS test library project", test_lib_project_path, True))
            else:
                checks.append(("iOS test library project", test_lib_project_path, False))
            
        # check test libs directory
        if self.test_libs_path.exists():
            checks.append(("Test libs directory", self.test_libs_path, True))
        else:
            checks.append(("Test libs directory", self.test_libs_path, False))
            
        # print all checks
        all_passed = True
        for check_name, check_path, passed in checks:
            if passed:
                self._print_success(f"{check_name} found at {check_path}")
            else:
                self._print_error(f"{check_name} not found at {check_path}")
                all_passed = False
                
        # create test libs directory if it doesn't exist
        if not self.test_libs_path.exists():
            self._print_progress(f"Creating test libs directory")
            self.test_libs_path.mkdir(parents=True, exist_ok=True)
            self._print_success(f"Created {self.test_libs_path}")
            
        if not all_passed:
            if not self.sdk_path.exists():
                print("Please run: git submodule update --init --recursive")
            return False
            
        return True

    def run_gradle_command(self, working_dir, command):
        """run a Gradle command in the specified directory"""
        gradlew_path = self.sdk_path / "gradlew"
        full_command = [str(gradlew_path)] + command
        
        self._print_progress(f"Running: {' '.join(command)}")
        if self.verbose:
            print(f"  Full command: {' '.join(full_command)}")
            print(f"  Working directory: {working_dir}")
        
        try:
            if self.verbose:
                # show output in real-time when verbose
                result = subprocess.run(
                    full_command,
                    cwd=working_dir,
                    check=True
                )
            else:
                # suppress output when not verbose
                result = subprocess.run(
                    full_command,
                    cwd=working_dir,
                    capture_output=True,
                    text=True,
                    check=True
                )
            self._print_success("Gradle command completed")
            return True
        except subprocess.CalledProcessError as e:
            self._print_error(f"Gradle command failed with exit code {e.returncode}")
            if hasattr(e, 'stdout') and e.stdout:
                print(f"STDOUT:\n{e.stdout}")
            if hasattr(e, 'stderr') and e.stderr:
                print(f"STDERR:\n{e.stderr}")
            return False

    def build_android_target(self, target):
        """build a specific Android target JAR"""
        self._print_brewing("Building", f"Android {target}")
        
        test_project_path = self.sdk_path / "tests" / target
        
        if target == "test-library":
            # use assembleDebug and get JAR from AAR structure (like Cordova script)
            success = self.run_gradle_command(
                test_project_path,
                ["clean", "assembleDebug"]
            )
            if not success:
                return False
                
            # check if the JAR was created in AAR structure
            jar_path = test_project_path / "build" / "intermediates" / "aar_main_jar" / "debug" / "syncDebugLibJars" / "classes.jar"
            if not jar_path.exists():
                self._print_error(f"JAR not found at expected location: {jar_path}")
                return False
                
            self._print_success(f"JAR created at: {jar_path}")
            return jar_path, "adjust-test-library.jar"
            
        elif target == "test-options":
            # build the test-options project
            success = self.run_gradle_command(
                test_project_path,
                ["clean", "assembleDebug"]
            )
            if not success:
                return False
                
            # create the libs directory if it doesn't exist
            libs_dir = test_project_path / "build" / "libs"
            libs_dir.mkdir(parents=True, exist_ok=True)
            
            # copy the compiled classes JAR to a proper location
            source_jar = test_project_path / "build" / "intermediates" / "aar_main_jar" / "debug" / "syncDebugLibJars" / "classes.jar"
            target_jar = libs_dir / "test-options-debug.jar"
            
            if not source_jar.exists():
                self._print_error(f"Source JAR not found at: {source_jar}")
                return False
                
            shutil.copy2(source_jar, target_jar)
            self._print_success(f"JAR created at: {target_jar}")
            return target_jar, "adjust-test-options.jar"
            
        return False

    def build_ios_target(self, target):
        """build a specific iOS target framework"""
        self._print_brewing("Building", f"iOS {target}")
        
        if target == "test-library":
            return self._build_ios_test_library()
        else:
            self._print_error(f"Unsupported iOS target: {target}")
            return False

    def _build_ios_test_library(self):
        """build the iOS test library framework using the iOS SDK build script"""
        ios_sdk_path = self.sdk_path
        test_lib_dst = self.test_libs_path / "AdjustTestLibrary.framework"
        
        # path to the built framework in iOS SDK distribution folder
        ios_framework_src = ios_sdk_path / "sdk_distribution" / "test-static-framework" / "AdjustTestLibrary.framework"
        
        try:
            # run the iOS SDK build script to build test framework
            self._print_progress("Running iOS SDK build script for test framework")
            
            result = subprocess.run([
                "bash", "-c", 
                f"cd {ios_sdk_path} && ./scripts/build_frameworks.sh -test"
            ], capture_output=not self.verbose, text=True, check=True)
            
            self._print_success("iOS SDK build script completed")
            
            # check if the framework was built
            if not ios_framework_src.exists():
                self._print_error(f"Framework not found at expected location: {ios_framework_src}")
                return False
                
            self._print_success(f"Framework built at: {ios_framework_src}")
            return ios_framework_src, "AdjustTestLibrary.framework"
            
        except subprocess.CalledProcessError as e:
            self._print_error(f"iOS SDK build script failed with exit code {e.returncode}")
            if hasattr(e, 'stdout') and e.stdout:
                print(f"STDOUT:\n{e.stdout}")
            if hasattr(e, 'stderr') and e.stderr:
                print(f"STDERR:\n{e.stderr}")
            return False

    def copy_framework(self, source_framework_path, target_name):
        """copy a framework to the test directory"""
        target_path = self.test_libs_path / target_name
        
        try:
            # remove existing framework if it exists
            if target_path.exists():
                self._print_progress(f"Removing existing framework: {target_name}")
                shutil.rmtree(target_path)
                
            self._print_copying(source_framework_path, target_path)
            shutil.copytree(source_framework_path, target_path)
            self._print_success(f"Copied {target_name}")
            return True
        except Exception as e:
            self._print_error(f"Failed to copy framework: {e}")
            return False

    def copy_jar(self, source_jar_path, target_name):
        """copy a JAR to the test directory"""
        target_path = self.test_libs_path / target_name
        
        try:
            self._print_copying(source_jar_path, target_path)
            shutil.copy2(source_jar_path, target_path)
            self._print_success(f"Copied {target_name}")
            return True
        except Exception as e:
            self._print_error(f"Failed to copy JAR: {e}")
            return False

    def build(self):
        """main build method"""
        
        if not self.check_prerequisites():
            self._print_error("Prerequisites check failed")
            return False
            
        # build all targets for the platform
        built_artifacts = []
        for target in self.test_targets:
            if self.platform == "android":
                result = self.build_android_target(target)
            elif self.platform == "ios":
                result = self.build_ios_target(target)
            else:
                self._print_error(f"Unsupported platform {self.platform}")
                return False
                
            if not result:
                self._print_error(f"Failed to build {self.platform} {target}")
                return False
                
            built_artifacts.append(result)
            
        # copy all built artifacts
        if self.platform == "android":
            self._print_brewing("Copying", "JAR files")
            for source_jar_path, target_name in built_artifacts:
                if not self.copy_jar(source_jar_path, target_name):
                    self._print_error("Failed to copy JAR files")
                    return False
        elif self.platform == "ios":
            self._print_brewing("Copying", "framework files")
            for source_framework_path, target_name in built_artifacts:
                if not self.copy_framework(source_framework_path, target_name):
                    self._print_error("Failed to copy framework files")
                    return False
                
        print(f"{Colors.GREEN}{Colors.BOLD}🎉 All {self.target} components built and copied successfully!{Colors.END}")
        return True


def main():
    """main entry point"""
    parser = argparse.ArgumentParser(
        description="Build JAR files from SDK submodules",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 build.py android test
  python3 build.py android test --verbose
  python3 build.py ios test
        """
    )
    
    parser.add_argument(
        "platform",
        choices=["android", "ios"],
        help="Target platform (android or ios)"
    )
    
    parser.add_argument(
        "target",
        choices=["test"],
        help="Target to build (test - builds all test components)"
    )
    
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Show detailed build output (Gradle logs, etc.)"
    )
    
    if len(sys.argv) == 1:
        parser.print_help()
        return
        
    args = parser.parse_args()
    
    builder = SDKBuilder(args.platform, args.target, args.verbose)
    success = builder.build()
    
    if not success:
        sys.exit(1)


if __name__ == "__main__":
    main() 