# frozen_string_literal: true

require 'faker'

Project.create([
  { projectName: "Example Project",
    projectDesc: "This is an example of what a project looks like!",
    projectStartDate: Date.today,
    locationID: 1000,
    isProjectActive: true,
    markdownBody: <<-MARKDOWN
# Welcome to My Website

This is a **simple website** designed to showcase some *cool features*. Let's explore what's on this page:

## Features

1. **Easy to Use**: Just type in markdown, and it converts to HTML instantly.
2. **Live Preview**: As you type, you can see the formatted content on the right side.
3. **Rich Formatting**:

   - *Italics*
   - **Bold**
   - `Code snippets`
   - ~~Strikethrough~~
   - ==Highlighting==

## Code Example

Here's a sample code block to demonstrate syntax highlighting:

```ruby
def hello_world
  puts "Hello, world!"
end
```

## Links

You can [click here](https://example.com) to visit an example site.

## Images

Here’s an image for you to test:

![Markdown Logo](https://upload.wikimedia.org/wikipedia/commons/4/48/Markdown-mark.svg)

---

## Data Table

Here’s an example of a table:

| Feature         | Description                              | Status  |
|-----------------|------------------------------------------|---------|
| **Markdown**    | Allows for easy content creation          | Enabled |
| **Live Preview**| Instantly shows rendered markdown         | Enabled |
| **Tables**      | Supports tables in markdown format        | Enabled |
| **Code Highlighting**| Displays syntax-highlighted code blocks | Enabled |

---

Feel free to explore more about **Markdown** and how it can be used to build _dynamic_ web pages!
MARKDOWN
  }
])

Project.create!([
  {
    projectName: 'Alpha Expansion',
    projectDesc: 'Expansion of the Alpha site to accommodate new equipment.',
    projectStartDate: Date.new(2024, 11, 1),
    locationID: 1,
    isProjectActive: true,
    markdownBody: '# Alpha Expansion\nDetails about the expansion will be documented here.'
  },
  {
    projectName: 'Beta Migration',
    projectDesc: 'Migrating Beta site operations to the new facility.',
    projectStartDate: Date.new(2025, 1, 15),
    locationID: 2,
    isProjectActive: false,
    markdownBody: '## Migration Plan\nSteps to migrate Beta site operations are outlined here.'
  },
  {
    projectName: 'Gamma Renovation',
    projectDesc: 'Complete renovation of the Gamma project area.',
    projectStartDate: Date.new(2025, 5, 20),
    locationID: 3,
    isProjectActive: true,
    markdownBody: nil
  },
  {
    projectName: 'Delta Research',
    projectDesc: 'Initiating new research projects under the Delta initiative.',
    projectStartDate: Date.new(2024, 12, 5),
    locationID: 4,
    isProjectActive: true,
    markdownBody: '# Delta Research\nResearch objectives and timelines.'
  },
  {
    projectName: 'Epsilon Closure',
    projectDesc: 'Formal closure of the Epsilon facility.',
    projectStartDate: Date.new(2025, 3, 30),
    locationID: 5,
    isProjectActive: false,
    markdownBody: nil
  }
])

100.times do
    User.create!(
        email: Faker::Internet.unique.email,
        full_name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.unique.subscriber_number(length: 10), # Phone number
        ring_date: Faker::Date.between(from: '1990-01-01', to: Date.today),   # Date within range
        grad_date: Faker::Date.between(from: '1990-01-01', to: Date.today),   # Date within range
        birthday: Faker::Date.between(from: '1990-01-01', to: '2000-01-01'),                  # Birthday within range
        uid: Faker::Number.unique.number(digits: 10),
        avatar_url: Faker::Avatar.image,
        user_type: ['user', 'admin'].sample,                                                # Randomly assigns either 'user' or 'admin'
        class_year: Faker::Number.between(from: 1900, to: Date.today.year + 4),             # Random class year
        shirt_size: ['S', 'M', 'L', 'XL'].sample,                                           # Random shirt size
        dietary_restriction: ['None', 'Vegetarian', 'Vegan', 'Gluten-Free', 'Halal'].sample, # Random dietary restriction
        account_complete: true,
        linkedin_url: Faker::Internet.url
    )
end
