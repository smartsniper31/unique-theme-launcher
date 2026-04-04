name: Pull Request
description: Submit changes to the project
draft: false

body:
  - type: markdown
    attributes:
      value: |
        ## Pull Request Template
        
        Thank you for contributing! Please fill out the form below to help us review your changes.

  - type: textarea
    id: description
    attributes:
      label: 📝 Description
      description: Brief explanation of what this PR changes
      placeholder: |
        This PR adds support for...
        Fixes issue #123
      validations:
        required: true

  - type: dropdown
    id: change_type
    attributes:
      label: 🏷️ Type of Change
      options:
        - '🐛 Bug fix (non-breaking)'
        - '✨ New feature (non-breaking)'
        - '📚 Documentation update'
        - '🔄 Refactoring (no functional changes)'
        - '⚡ Performance improvement'
        - '🎨 UI/UX improvement'
        - '🧪 Adding or updating tests'
      validations:
        required: true

  - type: textarea
    id: related_issues
    attributes:
      label: 🔗 Related Issues
      description: Link to related issues
      placeholder: |
        Closes #123
        Related to #456
      render: markdown

  - type: textarea
    id: changes
    attributes:
      label: 📋 Changes Made
      description: List the specific changes in this PR
      placeholder: |
        - Change 1
        - Change 2
        - Change 3
      validations:
        required: true

  - type: textarea
    id: testing
    attributes:
      label: 🧪 Testing
      description: How did you test these changes?
      placeholder: |
        - Tested on Android 14 emulator
        - Ran `flutter test`
        - Manual testing on [scenario]
      validations:
        required: true

  - type: textarea
    id: screenshots
    attributes:
      label: 📸 Screenshots (if applicable)
      description: Add screenshots for UI changes
      placeholder: Drag and drop images here

  - type: checkboxes
    id: checklist
    attributes:
      label: ✅ Checklist
      options:
        - label: My code follows the code style of this project
          required: true
        - label: I have performed a self-review
          required: true
        - label: I have commented code, especially hard-to-understand areas
          required: true
        - label: I have made corresponding changes to documentation
          required: true
        - label: My changes generate no new warnings
          required: true
        - label: I have added tests that prove my fix/feature works
          required: true
        - label: New and existing tests pass locally
          required: true
        - label: I have not introduced breaking changes
          required: true

  - type: textarea
    id: additional
    attributes:
      label: 📌 Additional Notes
      description: Any additional information for reviewers
      placeholder: Optional additional context
