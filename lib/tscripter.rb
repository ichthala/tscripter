require 'bundler/setup'
require "tscripter/version"

module Tscripter
  class Runner
    def go
      puts(go_with_args(ARGV))
    end

    def go_with_args(*args)
      if filename = args[0]
        file_basename = File.basename(filename, File.extname(filename))
        id1 = args[1]
        id2 = args[2]

        return "Please supply two ID arguments." if (id1.nil? || id2.nil?)

        transcript_text = File.new(filename).read

        edited_file_content = generate_edited_text(transcript_text, id1, id2)

        edited_file = File.new("#{file_basename}_edited_#{Time.now.to_i}.txt", "w")
        edited_file.write(edited_file_content)
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
      ids = [id1, id2]
      count = 0

      text.split("\n").each do |line|
        curr_id = ids[count % ids.length]

        if line[0] == "["
          if /^\[.*\].*\w+/ =~ line
            edited_text << process_line(curr_id, line)
            count += 1
          else
            edited_text << "#{line}\n"
          end
        elsif line.strip == ""
          edited_text << "#{line}\n"
        elsif line[0] == "^"
          curr_id = ids[(count % ids.length) - 1]
          edited_text << process_line(curr_id, line)
        else
          edited_text << process_line(curr_id, line)
          count += 1
        end

        # edited_text << "\n"
      end

      edited_text
    end

    private

    def process_line(id, line)
      line = remove_markup(line)
      line = add_inaudible_notation(line)
      "#{id}: #{line}\n"
    end

    def remove_markup(line)
      if line[0] == '^'
        line = line.slice(/\^\s(.*)/, 1)
      else
        line
      end
    end

    def add_inaudible_notation(line)
      line.scan(/\*[iI]\s\d{1,2}\:\d{1,2}/) do |inaud_markup|
        timestamp = inaud_markup.match(/(\d{1,2}\:\d{1,2})/)[1]
        inaudible_notation = "[inaudible #{timestamp}]"
        line = line.gsub(inaud_markup, inaudible_notation)
      end
      line
    end
  end
end
