name: ✨ Feature Request
description: Suggest a new feature or enhancement
labels: 'type: feature'
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        Thank you for suggesting a feature! Please fill out the form below.

  - type: textarea
    id: description
    attributes:
      label: 📝 Description
      description: A clear description of what you want to add
      placeholder: |
        Tell us about the feature idea. What problem does it solve?
    validations:
      required: true

  - type: textarea
    id: motivation
    attributes:
      label: 💡 Motivation
      description: Why would this feature be useful?
      placeholder: |
        - Use case 1
        - Use case 2
        - Benefits
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: 🎯 Proposed Solution
      description: How would you implement this? (optional)
      placeholder: Describe the suggested solution

  - type: textarea
    id: alternatives
    attributes:
      label: 🤔 Alternatives Considered
      description: Other ways to solve this problem
      placeholder: |
        - Alternative 1
        - Alternative 2

  - type: checkboxes
    id: checks
    attributes:
      label: ✅ Checklist
      options:
        - label: I have searched for similar feature requests
          required: true
        - label: This feature aligns with project goals
          required: false
