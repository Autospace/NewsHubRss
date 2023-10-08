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
    /// Scan
    internal static let scanButtonTitle = L10n.tr("Localizable", "addNewFeed.scanButtonTitle", fallback: "Scan")
    /// Add feed
    internal static let title = L10n.tr("Localizable", "addNewFeed.title", fallback: "Add feed")
    internal enum TextField {
      /// Feed URL
      internal static let placeholder = L10n.tr("Localizable", "addNewFeed.textField.placeholder", fallback: "Feed URL")
    }
  }
  internal enum Common {
    /// Localizable.strings
    ///   NewsHubRss
    /// 
    ///   Created by Aliaksei Mastounikau on 2.03.23.
    internal static let add = L10n.tr("Localizable", "common.add", fallback: "Add")
    /// Attention!
    internal static let attention = L10n.tr("Localizable", "common.attention", fallback: "Attention!")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Proceed
    internal static let proceed = L10n.tr("Localizable", "common.proceed", fallback: "Proceed")
    /// Save
    internal static let save = L10n.tr("Localizable", "common.save", fallback: "Save")
  }
  internal enum DeleteFoundFeed {
    internal enum Alert {
      /// You try to delete a feed with saved items related to it. Proceed will delete them as well. Are you sure?
      internal static let message = L10n.tr("Localizable", "deleteFoundFeed.alert.message", fallback: "You try to delete a feed with saved items related to it. Proceed will delete them as well. Are you sure?")
    }
  }
  internal enum MainPage {
    /// Main
    internal static let title = L10n.tr("Localizable", "mainPage.title", fallback: "Main")
  }
  internal enum Settings {
    internal enum Displaying {
      /// Displaying
      internal static let title = L10n.tr("Localizable", "settings.displaying.title", fallback: "Displaying")
      internal enum Theme {
        /// Theme
        internal static let title = L10n.tr("Localizable", "settings.displaying.theme.title", fallback: "Theme")
        internal enum Dark {
          /// Dark
          internal static let title = L10n.tr("Localizable", "settings.displaying.theme.dark.title", fallback: "Dark")
        }
        internal enum Light {
          /// Light
          internal static let title = L10n.tr("Localizable", "settings.displaying.theme.light.title", fallback: "Light")
        }
        internal enum System {
          /// System
          internal static let title = L10n.tr("Localizable", "settings.displaying.theme.system.title", fallback: "System")
        }
      }
    }
    internal enum SafariReader {
      /// Use reader in Safari if available
      internal static let title = L10n.tr("Localizable", "settings.safariReader.title", fallback: "Use reader in Safari if available")
    }
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
