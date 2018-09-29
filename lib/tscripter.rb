require 'bundler/setup'
require "tscripter/version"

module Tscripter
  class Runner
    def go
      puts(go_with_args(ARGV))
    end

    def go_with_args(*args)
      if filename = args[0]
        file_basename = File.basename(args[0], File.extname(args[0]))
        id1 = args[1]
        id2 = args[2]

        return "Please supply two ID arguments." if (id1.nil? || id2.nil?)

        transcript_text = File.new(filename).read

        edited_file_content = generate_edited_text(transcript_text, id1, id2)

        edited_file = File.new("#{file_basename}_edited_#{Time.now.to_i}.txt", "w")
        File.write(edited_file_content)
        edited_file.close

        "Transcript edit complete."
      else
        "Please supply a filename."
      end
    rescue IOError
      "ERROR: File named #{args[0]} does not exist in this directory.\nPlease supply a valid filename."
    end

    def generate_edited_text(text, id1, id2)
      edited_text = ""
      use_id1 = true

      text.split("\n").each do |line, i|
        if line[0] == "[" || line.strip == ""
          edited_text << "#{line}\n"
          next
        end

        if use_id1
          edited_text << "#{id1}: #{line}\n"
        else
          edited_text << "#{id2}: #{line}\n"
        end

        use_id1 = !use_id1
      end

      edited_text
    end

  end
end
