# Introduction

AgreementKit is an easy way to ask users to agree to terms & conditions, questions, or similar text before proceeding with a task.

If you want a view controller to present an agreement, setup is easy:

1. Have your view controller conform to the `AgreementProvider` protocol.
2. Provide an `Agreement` with the desired text and style.
3. Before performing any task, use `requireConsent` like this:

```
    requireConsent(before: { 
        // do something after the consent form
    }, orCancel: {
        // cancelling
    })
```

# Getting Started
## Carthage

**AgreementKit** supports Carthage. CocoaPods is on the TODO list. 

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