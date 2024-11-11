# Matthew P. Robertson's Personal Website

A minimalist static website and blog generator using Pandoc and Bash.

## Prerequisites

- bash
- pandoc
- sed
- sort

## Directory Structure

.
├── blog/              # Directory containing blog posts
│   ├── *.md          # Markdown blog posts
│   └── *.html        # Generated HTML blog posts
├── style.css         # Main stylesheet
├── intro.html        # Main content for homepage
├── blog_template.html # Template for blog posts
├── generate_blog.sh  # Main build script
└── index.html        # Generated homepage

## How to Use

1. Write blog posts as Markdown files in the `blog/` directory
   - Each post must start with a level 1 heading (`# Title`)
   - Example: `blog/my-post.md`

2. Run the build script:
```bash
./generate_blog.sh
```

This will:
- Convert all Markdown posts to HTML using Pandoc
- Generate an index of posts sorted by date
- Create the homepage and blog index
- Clean up temporary files

## Blog Post Format

Each blog post should be written in Markdown and must:
- Start with a level 1 heading (`# Title`)
- Be placed in the `blog/` directory with a `.md` extension
- Prefix filename with "DRAFT-" for draft posts (e.g., `DRAFT-my-post.md`)
  - Draft posts will not be included in the generated site

Example:
```markdown
# My Blog Post Title

Content goes here...
```

## Templates

The site uses two main templates:
- `blog_template.html`: Template for individual blog posts
- `intro.html`: Content for the homepage

## Styling

All styling is handled by `style.css`. The site uses a simple, responsive design with:
- Max width of 800px for content
- Responsive container width (90% on mobile, 60% on desktop)
- Code block styling
- Basic typography

## Generated Files

The script generates:
- `index.html`: Homepage with latest blog posts
- `blog/index.html`: Blog index page
- Individual HTML files for each blog post

## License

MIT License

Copyright (c) 2023 Matthew P. Robertson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.