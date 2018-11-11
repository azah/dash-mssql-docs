require 'nokogiri'

def get_type(htmldoc, file, log_file)
  dirname = File.dirname(file)
  if dirname.include? 'database-console-commands'
    return 'Command'
  elsif dirname.include? 'language-elements'
    return 'Function'
  else
    content = htmldoc.css('p')[0..2].collect { |x| x.content.downcase }.join("")
    if content.include?('returns')
      return 'Function'
    elsif content.include?('property')
      return 'Property'
    else
      return 'File'
    end
  end
end

def insert_file(file, log_file)
  doc = Nokogiri::HTML(ARGF.read)
  title_node = doc.css("h1").first
  if title_node
    title = title_node.content
    type = get_type(doc, file, log_file)
    if title
      insert_text = "INSERT OR IGNORE INTO searchIndex VALUES (NULL, '#{title}', '#{type}', '#{file}');"
      log_file.write insert_text + "\n\n"
      puts insert_text
    end
  end
end

def insert_diagram(file, log_file)
  name = File.basename(file, ".*")
  insert_text = "INSERT OR IGNORE INTO searchIndex VALUES (NULL, '#{name}', 'Diagram', '#{file}');"
  log_file.write insert_text + "\n\n"
  puts insert_text
end

file = ARGV.first
log_file = File.open("../../../../log.txt",  "a")

log_file.write "Reading file: " + file + "\n"
case File.extname(file).downcase
when ".html"
  insert_file(file, log_file)
when ".jpg", ".png", ".bmp"
  insert_diagram(file, log_file)
else
  log_file.write(doc_file + "\n" + "@@@"*600)
end

log_file.close

