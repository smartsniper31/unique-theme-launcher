name: 🐛 Bug Report
description: Report a bug or issue
labels: 'type: bug'
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        Thank you for reporting a bug! Please fill out the form below to help us understand the issue.

  - type: textarea
    id: description
    attributes:
      label: 📝 Description
      description: A clear and concise description of the bug
      placeholder: |
        What happened? What did you expect to happen?
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: 🔄 Steps to Reproduce
      description: How can we reproduce this issue?
      placeholder: |
        1. Open the app
        2. Go to [screen]
        3. Click [button]
        4. Observe the bug
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: ✅ Expected Behavior
      description: What should happen instead?
      placeholder: The app should display [expected behavior]
    validations:
      required: true

  - type: textarea
    id: logs
    attributes:
      label: 📋 Logs & Error Messages
      description: Paste any relevant error logs
      placeholder: |
        ```
        [Paste logs here]
        ```
      render: markdown

  - type: textarea
    id: environment
    attributes:
      label: 📱 Environment
      description: |
        Examples:
        - OS: Android 14
        - Device: Samsung Galaxy S23
        - Flutter: 3.13.0
        - App Version: 1.0.0
      placeholder: |
        - Flutter version: `flutter --version`
        - Device: 
        - Android/iOS version:
        - App version:
      render: markdown

  - type: textarea
    id: screenshots
    attributes:
      label: 📸 Screenshots/Videos
      description: Any screenshots or videos demonstrating the issue
      placeholder: Drag and drop screenshots here

  - type: dropdown
    id: severity
    attributes:
      label: 🔴 Severity
      options:
        - Critical (App crashes)
        - High (Feature broken)
        - Medium (Feature limited)
        - Low (Minor issue)
    validations:
      required: true

  - type: checkboxes
    id: checks
    attributes:
      label: ✅ Checklist
      options:
        - label: I have searched for similar issues
          required: true
        - label: I have provided steps to reproduce
          required: true
        - label: I have provided environment details
          required: true
