# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

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
   - Blockquotes:

     > "This is a blockquote to highlight important text."

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
