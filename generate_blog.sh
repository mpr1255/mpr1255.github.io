#!/bin/bash

# Directory containing markdown files
BLOG_DIR="blog"

# Remove any existing HTML files that correspond to current drafts
for draft in "$BLOG_DIR"/DRAFT-*.md; do
    if [ -f "$draft" ]; then
        # Extract the base name without DRAFT- prefix and .md extension
        base_name=$(basename "$draft" | sed 's/^DRAFT-//; s/\.md$//')
        html_file="$BLOG_DIR/$base_name.html"
        
        # Don't delete index.html
        if [ "$html_file" != "$BLOG_DIR/index.html" ] && [ -f "$html_file" ]; then
            echo "Removing $html_file"  # Debug output
            rm "$html_file"
        fi
    fi
done

# Clean any existing temporary files before starting
rm -f post_list.tmp sorted_post_list.tmp

# Generate HTML for each markdown file
for file in "$BLOG_DIR"/*.md; do
    # Skip files that start with DRAFT-
    [[ $(basename "$file") == DRAFT-* ]] && continue
    
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        name="${filename%.*}"
        
        # Check if the file starts with a # (h1 heading)
        if ! head -n 1 "$file" | grep -q '^# '; then
            echo "Error: $file does not start with a # (h1 heading). Please add a title."
            exit 1
        fi
        
        title=$(head -n 1 "$file" | sed 's/^# //')
        date=$(date -r "$file" +"%Y-%m-%d")
        
        pandoc "$file" -o "$BLOG_DIR/$name.html" \
            -s --metadata title="$title" \
            -c "../style.css" \
            --template="$(pwd)/blog_template.html" \
            --highlight-style=tango
        
        echo "<li><a href='blog/$name.html'>$title</a> - $date</li>" >> "post_list.tmp"
    fi
done

# Sort post list by date (newest first)
sort -r "post_list.tmp" > "sorted_post_list.tmp"

# Generate new index.html
cat > "index.html" << EOF
<!DOCTYPE HTML>
<html>
<head>
    <title>Matthew P. Robertson's Home Page</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        $(cat intro.html)
        <hr>
        <h2>Blog:</h2>
        <ul>
$(cat sorted_post_list.tmp)
        </ul>
        <p>See all <a href="blog/index.html">blog posts</a>.</p>
    </div>
</body>
</html>
EOF

# Generate blog index
cat > "$BLOG_DIR/index.html" << EOF
<!DOCTYPE HTML>
<html>
<head>
    <title>Matthew P. Robertson's Blog</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body>
    <div class="container">
        <h1>Matthew P. Robertson's Blog</h1>
        <ul>
$(sed 's|<li><a href='"'"'blog/|<li><a href='"'"'|g' sorted_post_list.tmp)
        </ul>
        <p><a href="../index.html">Back to Home</a></p>
    </div>
</body>
</html>
EOF

# Clean up temporary files
rm post_list.tmp sorted_post_list.tmp

echo "Blog generated successfully!"