name: 📚 Documentation Update
description: Improve or fix documentation
labels: 'type: docs'
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        Help us improve the documentation!

  - type: textarea
    id: description
    attributes:
      label: 📝 What needs to be fixed?
      description: Which documentation needs improvement?
      placeholder: |
        - Typos in README
        - Missing information
        - Unclear instructions
        - Outdated content
    validations:
      required: true

  - type: textarea
    id: suggestion
    attributes:
      label: 💬 Suggested Change
      description: What should be changed or added?
      placeholder: Provide the corrected or new content
    validations:
      required: true

  - type: checkboxes
    id: checks
    attributes:
      label: ✅ Checklist
      options:
        - label: I have checked the current documentation
          required: true
