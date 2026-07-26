# Removing a Substring from Filenames in Bash

This note explains a small Bash script that renames files in a directory by removing a given substring from each filename.

## Example

If you run:

```bash
./rename_remove_substring.sh ./photos "_backup"
```

and a file is named:

```text
photo_backup.jpg
```

it will be renamed to:

```text
photo.jpg
```

## Script

```bash
#!/bin/bash
set -euo pipefail

DIR="${1:?Usage: $0 <directory> <substring>}"
SUBSTR="${2:?Usage: $0 <directory> <substring>}"

if [[ ! -d "$DIR" ]]; then
    echo "Error: '$DIR' is not a directory" >&2
    exit 1
fi

for file in "$DIR"/*; do
    [[ -f "$file" ]] || continue

    base="$(basename "$file")"
    new_base="${base//$SUBSTR/}"

    if [[ "$base" != "$new_base" ]]; then
        new_path="$DIR/$new_base"

        if [[ -e "$new_path" ]]; then
            echo "Skipping '$base': target '$new_base' already exists" >&2
            continue
        fi

        mv -- "$file" "$new_path"
        echo "Renamed: '$base' -> '$new_base'"
    fi
done
```

## What Each Part Does

### 1. Shebang

```bash
#!/bin/bash
```

This tells Linux to run the script with Bash.

### 2. Safer Bash settings

```bash
set -euo pipefail
```

This makes the script more reliable:

- `-e`: stop immediately if any command fails
- `-u`: treat unset variables as errors
- `-o pipefail`: make pipelines fail if any part fails

### 3. Arguments

```bash
DIR="${1:?Usage: $0 <directory> <substring>}"
SUBSTR="${2:?Usage: $0 <directory> <substring>}"
```

The script expects two arguments:

1. the directory to process
2. the substring to remove

If either argument is missing, it exits with a useful message.

### 4. Validate the directory

```bash
if [[ ! -d "$DIR" ]]; then
    echo "Error: '$DIR' is not a directory" >&2
    exit 1
fi
```

This checks that the provided path exists and is a directory.

### 5. Loop through files

```bash
for file in "$DIR"/*; do
```

This iterates over everything inside the target folder.

### 6. Skip non-files

```bash
[[ -f "$file" ]] || continue
```

This ensures the script only works with regular files and ignores folders.

### 7. Extract the filename

```bash
base="$(basename "$file")"
```

`basename` removes the directory part and leaves only the filename.

### 8. Remove the substring

```bash
new_base="${base//$SUBSTR/}"
```

This uses Bash parameter expansion to replace all occurrences of `SUBSTR` with an empty string.

### 9. Avoid overwriting existing files

```bash
if [[ -e "$new_path" ]]; then
    echo "Skipping '$base': target '$new_base' already exists" >&2
    continue
fi
```

This prevents accidental overwriting of existing files.

### 10. Rename the file

```bash
mv -- "$file" "$new_path"
```

This renames the file safely. The `--` ensures that names beginning with `-` are not misread as options.

## Summary

The script:

- checks that the target path is a valid directory
- loops through each file inside it
- removes the requested substring from the file name
- renames the file only when it is safe to do so

