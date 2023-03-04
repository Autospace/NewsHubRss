// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AddNewFeed {
    /// Add
    internal static let buttonTitle = L10n.tr("Localizable", "addNewFeed.buttonTitle", fallback: "Add")
    /// Insert feed link into the field below
    internal static let instruction = L10n.tr("Localizable", "addNewFeed.instruction", fallback: "Insert feed link into the field below")
    /// Add feed
    internal static let title = L10n.tr("Localizable", "addNewFeed.title", fallback: "Add feed")
    internal enum TextField {
      /// Feed URL
      internal static let placeholder = L10n.tr("Localizable", "addNewFeed.textField.placeholder", fallback: "Feed URL")
    }
  }
  internal enum MainPage {
    /// Localizable.strings
    ///   NewsHubRss
    /// 
    ///   Created by Aliaksei Mastounikau on 2.03.23.
    internal static let title = L10n.tr("Localizable", "mainPage.title", fallback: "Main")
  }
  internal enum SettingsPage {
    /// Settings
    internal static let title = L10n.tr("Localizable", "settingsPage.title", fallback: "Settings")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
