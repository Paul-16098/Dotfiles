const DB_NAME = "TWINE_TOOLS"
const TARGET_ENV_VAR = $"($DB_NAME)_TARGET"

# Set the target path for the Twine HTML file
export def 'target set' --env [target: path]: nothing -> nothing {
  load-env {$TARGET_ENV_VAR: $target}

  null
}

# Get the target path for the Twine HTML file
export def 'target get' []: nothing -> string {
  $env | %get $TARGET_ENV_VAR --optional
}

def 'get-current-hash' []: nothing -> string {
  open --raw (target get) | hash sha256
}

# Set the cached passages in the database
export def 'cache set' []: table<body: string, attr: record> -> nothing {
  let nc

  if (cache is-not-empty) {
    {cache: $nc} | stor update --table-name $DB_NAME --where-clause $'hash = "(get-current-hash)"'
  } else {
    {hash: (get-current-hash) cache: $nc} | stor insert --table-name $DB_NAME
  }

  null
}

# Get the cached passages from the database
export def 'cache get' []: nothing -> oneof<table<body: string, attr: record>, nothing> {
  stor open | query db $'SELECT cache FROM ($DB_NAME) WHERE hash = :hash' --params {hash: (get-current-hash)} | get --optional 0.cache
}

# Check if the cache is up-to-date by comparing the current hash of the Twine HTML file with the stored hash in the database
export def 'cache is-not-empty' []: nothing -> bool {
  cache get | is-not-empty
}

# Initialize the twine_tools table
export def init --env []: nothing -> nothing {
  target set (glob --no-dir "*.html" | first)

  # drop the table if it exists and create a new one
  stor open | query db $'DROP TABLE IF EXISTS ($DB_NAME);'

  # create the table with a hash column and a cache column
  stor open | query db $"CREATE TABLE ($DB_NAME) \(hash VARCHAR\(255) PRIMARY KEY, cache JSON)"

  null
}

# Get a list of passages from the Twine HTML file
export def get-passage [
  --keep-attr: list<string> = [name tags] # Attributes to keep from the passage
  --query: string = 'tw-passagedata:not([tags="Twine.image"], [tags*="encode"])' # Query to select passages from the Twine HTML
  --force-cache # Force the cache to be refreshed even if it already exists
]: [
  nothing -> table<body: string, attr: record>
] {
  if (not $force_cache) and (cache is-not-empty) {
    print --stderr $"Using cached passages for target: (target get)"
    return (cache get)
  }
  print --stderr $"Refreshing cache for target: (target get)"

  let body = open (target get) --raw | query web --query $query --as-html
  $body | par-each --keep-order {
    [
      [body attr];
      [
        ($in | query web --query $query | first | first | default --empty "" | into string) # nu-lint-ignore: default_empty_string_masks_missing
        ($in | query web --query $query --attribute $keep_attr | first)
      ]
    ]
  } | flatten | tee { cache set }
}

# Find a passage by name or body
export def find-passage [
  --name: string # Name of the passage to find
  --body: string # Body of the passage to find
]: nothing -> oneof<nothing, table<body: string, attr: record>> {
  if ($name | is-not-empty) {
    get-passage | where attr.name =~ $name
  } else if ($body | is-not-empty) {
    get-passage | where body =~ $body
  } else {
    error make --unspanned "Please provide either --name or --body to search for."
  }
}

# Update a passage by name with a new body, optionally inserting it before or after another passage
export def patch-passage [
  name: string # Name of the passage to update
  body: string # body for patch
  --after # Insert the updated passage after the specified passage
  --before # Insert the updated passage before the specified passage
  --replace # Replace the existing passage with the updated passage
  --replace-with-regex: string # Replace the existing passage with the updated passage using regex to match the body
  --replace-with-string: string # Replace the existing passage with the updated passage using string to match the body
  --no-encode-html # Do not encode HTML entities in the updated passage body
  --no-clipboard # Do not copy the updated passage body to the clipboard
]: nothing -> string {
  let raw_body: record<body: string, attr: record> = get-passage | where attr.name == $name | first

  $raw_body | update body {
    if $after {
      $in + $"<!-- patch after start -->($body)<!-- patch after end -->"
    } else if $before {
      $"<!-- patch before start -->($body)<!-- patch before end -->" + $in
    } else if $replace {
      $"<!-- patch replace start -->($body)<!-- patch replace end -->"
    } else if ($replace_with_regex | is-not-empty) {
      $in | str replace --regex $body $replace_with_regex
    } else if ($replace_with_string | is-not-empty) {
      $in | str replace $body $replace_with_string
    } else {
      error make --unspanned "Please provide either --after or --before or --replace to specify where to insert the updated passage."
    }
  } | get body
  | if not $no_encode_html { encode html } else { }
  | if not $no_clipboard { tee { clip copy } } else { }
}
