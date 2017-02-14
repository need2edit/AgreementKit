# Introduction

AgreementKit is an easy way to ask users to agree to terms & conditions, questions, or similar text before proceeding with a task.

If you want a view controller to present an agreement, setup is easy:

1. Have your view controller conform to the `AgreementProvider` protocol.

    ```
    extension ViewController: AgreementProvider { 
        var agreementToPresent: Agreement! { ... } // primary first agreement
        var affirmativeConsentAgreement: Agreement? { ... } // optional second agreement
    }
    ```

2. Provide an `Agreement` with the desired text and style.

    ```
    return Agreement(title: "Terms & Conditions", message: "This is a primary agreement. The alert style usually only has 1-2 lines of body text.", style: .alert, requiresAffirmativeConsent: affirmativeConsent, continueLabel: "I'm Sure", cancelLabel: "Nope!")
    ```

3. Before performing any task, call `requireConsent` from your view controller like this:

    ```
    requireConsent { 
            // do something after the consent form
    }
    ```

# Getting Started

# Installation
## Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

$ brew update
$ brew install carthage

To integrate AgreementKit into your Xcode project using Carthage, specify it in your Cartfile:
github "need2edit/AgreementKit"
Run carthage update to build the framework and drag the built AgreementKit.framework into your Xcode project.

# Working with Agreements
## Alert

The `.alert` style leverages `UIAlertController` to show an agreement. The cancel and agree buttons are provided as `UIAlertAction`s.

## Text Boxes

The `.textbox` style provides the agreement as a `UITextView` that fills a `UIViewController`. The cancel and agree buttons are provided as `UIBarButtonItem` items in either the toolbar or navigation bar.  This position is controlled by the `NavigationPosition` option.

The cancel and agree buttons are provided as `UIBarButtonItem` items in either the toolbar or navigation bar.  This position is controlled by the `NavigationPosition` option.

## Multipart

The `.multipart` style provides the agreement as a `UITableViewController` that allows for sections with three types:

- text: A general text block. Takes a title and a message body, with a title and a body.
- link: A URL with a display label. Tapping on a link loads it in a `SFViewController`.
- callToAction: A centered URL with a display label. Tapping on a link loads it in a `SFViewController`.

# Affirmative Consent

The `.textbox` and `.multipart` styles support affirmative consent. When enabled, an additional alert will appear asking the user to confirm. Providing an additional agreement for affirmative consent in the `AgreementProvider` delegate.
