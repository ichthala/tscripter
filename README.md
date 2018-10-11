# Tscripter

This gem edits transcript files. Files must be plaintext (.txt).

## Current features:
- Prepend alternating IDs to spoken lines
- If a line starts with `^`, then the speaker is the same as the previous line
  - Example:
  ```
  You've changed, Heathcliff...
  [looks to the moon]
  ^ ...and I don't know who you are anymore.
  That's not true!
  ```
  becomes...
  ```
  Cathy: You've changed, Heathcliff...
  [looks to the moon]
  Cathy: ...and I don't know who you are anymore.
  Heathcliff: That's not true!
  ```

- Replace pattern `*i MM:SS` (where MM:SS is any timestamp) with `inaudible [MM:SS]`
  - Example:
  ```
  But what if *i 10:05 to the end?
  ```
  becomes...
  ```
  Heathcliff: But what if [inaudible 10:05] to the end?
  ```
  - Note: Currently only supports MM:SS timestamps, not HH:MM:SS

- Lines that contain _only_ stage directions (text inside [square brackets]) are left intact

- Lines that contain _only_ whitespace are left intact

## Sample input and output

Input:
```
Hello there.

Hello to you too.

Lovely night on the moors.
[uncomfortable silence]
This is splendid, don't you agree?
I mean, I would never...
[pause]
^ disagree with you.
But what if *i 45:09 tomorrow?
[turns away] You can't mean that!
```

Output:
```
Heathcliff: Hello there.

Cathy: Hello to you too.

Heathcliff: Lovely night on the moors.
[uncomfortable silence]
Cathy: This is splendid, don't you agree?
Heathcliff: I mean, I would never...
[pause]
Heathcliff: disagree with you.
Cathy: But what if [inaudible 45:09] tomorrow?
Heathcliff: [turns away] You can't mean that!
```

## Planned features:
- Accept multiple filenames
- Accept wildcard filenames
- Support HH:MM:SS timestamps

## Installation

    $ gem install tscripter

## Usage

    $ tscripter filename.txt Heathcliff Cathy

AAA and BBB are the IDs to prepend.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ichthala/tscripter.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

