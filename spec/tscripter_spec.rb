require 'spec_helper'

describe Tscripter do
  it 'has a version number' do
    expect(Tscripter::VERSION).not_to be nil
  end
end

describe Tscripter::Runner do
  let(:runner) { Tscripter::Runner.new }

  describe "#go_with_args" do
    it 'returns the expected error description' do
      expect(runner.go_with_args()).to eq("Please supply a filename.")
    end

    context 'when no ID arguments are given' do
      it 'returns the expected error description' do
        expect(runner.go_with_args('filename.txt')).to eq(
          "Please supply two ID arguments."
        )
      end
    end

    context 'when only one ID argument is given' do
      it 'returns the expected error description' do
        expect(runner.go_with_args('filename.txt', '1')).to eq(
          "Please supply two ID arguments."
        )
      end
    end

    context 'when two ID arguments are given' do
      context 'and file does not exist' do
        it 'returns the expected error description' do
          expect(File).to receive(:new).and_raise(IOError)
          expect(runner.go_with_args('filename.txt', '1', '2')).to eq(
            "ERROR: File named filename.txt does not exist in this directory.\nPlease supply a valid filename."
          )
        end

        it 'does not create a new file' do
        end
      end
    end
  end

  describe "#generate_edited_text" do
    let(:valid_content) {
      <<-STR.gsub(/^\s*/, "")
        Hello there.
        Hi!
        Nice to see you today.
        You too.
      STR
    }

    it 'prepends alternating ID numbers to lines' do
      expect(runner.generate_edited_text(valid_content, "1", "2")).to eq(
        <<-STR.gsub(/^\s*/, "")
          1: Hello there.
          2: Hi!
          1: Nice to see you today.
          2: You too.
        STR
      )
    end

    context 'when file has lines that start with square brackets' do
      let(:content_with_notation) {
        <<-STR.gsub(/^\s*/, "")
          Hello there.
          [quietly]
          Hi!
          Nice to see you today.
          You too.
          [end of transcipt]
        STR
      }

      it 'leaves square bracket lines undisturbed' do
        expect(runner.generate_edited_text(content_with_notation, "1", "2")).to eq(
          <<-STR.gsub(/^\s*/, "")
            1: Hello there.
            [quietly]
            2: Hi!
            1: Nice to see you today.
            2: You too.
            [end of transcipt]
          STR
        )
      end
    end

    context 'when file has lines that are only whitespace' do
      let(:content_with_blank_lines) {
        <<-STR
Hello there.

Hi!
Nice to see you today.
You too.


STR
      }

      it 'leaves white space lines undisturbed, except file end' do
        expect(runner.generate_edited_text(content_with_blank_lines, "1", "2")).to eq(
<<-STR
1: Hello there.

2: Hi!
1: Nice to see you today.
2: You too.
STR
        )
      end
    end
  end
end

