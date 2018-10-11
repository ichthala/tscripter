# Tscripter

This gem edits transcript files, given that they are in the expected format.

Current features:
- Prepends alternating IDs to spoken lines
- Detect spoken lines that start with stage directions
- Implement notation for consecutive lines by the same speaker
- If a line starts with `^`, then the speaker is the same as the previous line
- The pattern `*i 00:00` (where 00:00 is any timestamp) is replaced with `inaudible [00:00]`

Planned features:
- Accept multiple filenames
- Accept wildcard filenames

Expected format:
- File must be .txt
- Speakers of each line must alternate
- Lines that start with square brackets (stage directions) will be skipped
- Whitespace lines are skipped

## Sample input and output

Input:
```
Hello there.

Hello to you too.

I can't read books anymore.
[uncomfortable silence]
This is fun, don't you agree?
I mean, I would never...
[pause]
^ disagree with you.
But what if *i 45:09
[turns away] You can't really mean that!
```

Output:
```
A: Hello there.

B: Hello to you too.

A: I can't read books anymore.
[uncomfortable silence]
B: This is fun, don't you agree?
A: I mean, I would never...
[pause]
A: disagree with you.
B: But what if [inaudible 45:09]
A: [turns away] You can't really mean that!
```

## Installation

    $ gem install tscripter

## Usage

    $ tscripter filename.txt AAA BBB

AAA and BBB are the IDs to prepend.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ichthala/tscripter.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

