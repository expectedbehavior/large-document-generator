require 'rubygems'
require 'nokogiri'

MIN_BYTES = 30 * 1000000 # how many megabytes?
SVG_LOGO = '<svg width="49" height="36" viewBox="0 0 49 36" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><path d="M54.078 37.57l2.09 3.154-5.343 2.874-6.955-1.175-.58 2.998-5.08 5.017 6.15 4.375H33.777l-.075-12.494-12.38 2.272 7.668-9.474-15.11-13.78L46.013 31.36l-.377.245.377-.246-.135.696.276.092 1.083-7.55 8.067 1.014 2.182 8.403-3.408 3.556zm-32.756 7.018l7.915 6.502-1.12-7.75-6.795 1.248zm32.665-24.74l7.656 4.748v1.81l-14.406-1.81 6.75-4.748zm2.18 20.876l-.986 4.145-1.48-2.82 2.47-1.327z" id="a"/></defs><g transform="translate(-13 -19)" fill="none" fill-rule="evenodd"><use fill="#000" xlink:href="#a"/><use xlink:href="#a"/><use xlink:href="#a"/></g></svg>'
PNG_EBOOK = '<img width="100" src="https://docraptor-production-cdn.s3.amazonaws.com/tutorials/ebook.png">'
PNG_BROCHURE = '<img width="100"  src="https://docraptor-production-cdn.s3.amazonaws.com/tutorials/brochure.png">'

def l(text, indent)
  " " * indent + text + "\n"
end

def generate_table(indent = 0)
  table = l("<table id='table#{indent}'>", indent)
  for row_count in 1..5 do
    table += l("<tr>", indent + 1)

    for cell_count in 1..(rand(1..5)) do
      table += l("<td>", indent + 2)
      content = rand(1..12)
      case content
      when 1
        table += l(SVG_LOGO, indent + 3)
      when 3
        table += generate_css(indent)
      when 4
        table += l(dummy_image, indent)
      when 5
        table += l(PNG_EBOOK, indent + 3)
      when 6
        table += l(PNG_BROCHURE, indent + 3)
      when 7..8
        table += text = (0...150).map { ('a'..'z').to_a[rand(26)] }.join(" ")
      when 9..12
        if indent < 5
          table += generate_table(indent + 3)
        end
      end
      table += l("</td>", indent + 2)
    end
    table += l("</tr>", indent + 1)
  end
  table += l("</table>", indent)
end

def generate_css(indent)
  width = rand(1..100)
  ids = (0.step(indent, 2).map { |i| "#table#{i}"}).join(" ")
  l("<style>#{ids} { width: #{width}% }</style>", indent + 3)
end

def dummy_image
  text = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  "<img src='https://dummyimage.com/#{rand(50..200)}x#{rand(50..200)}/000/fff.jpg&text=#{text}'>"
end

def generate_document
  document = '<link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Poppins:wght@400;500&display=swap" rel="stylesheet">'
  until document.bytesize > MIN_BYTES
    document += generate_table
  end
  document
end

File.write("document.html", generate_document)
