function Para(p)
  local lines = {}
  for i, el in ipairs(p.content) do
    if el.text then
      if string.find(el.text, "INCLUDE") then
        -- remove [!INCLUDE
        p.content[i].text = ""

        if p.content[i+1] and p.content[i+1].target then
          -- expand target file
          local file = fix_path(p.content[i+1].target:gsub("%.html", ".md"):sub(4))
          for line in io.lines(file) do
            lines[#lines + 1] = line
          end
          p.content[i+1] = create_element(table.concat(lines))
        end

        -- remove trailing ]
        if p.content[i+2] and p.content[i+2].text then
          if p.content[i+2].text:find("]") then
            p.content[i+2].text = ""
          end
        end
      end
    end
  end
  return p
end

function fix_path(file)
  if file_exists(file) then return file end
  if file_exists("../" .. file) then return "../" .. file end
  if file_exists("../../" .. file) then return "../../" .. file end
  return file
end

function Link(el)
  el.target = string.gsub(el.target, "%.md", ".html")
  return el
end

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function create_element(str)
  return pandoc.RawInline("html", str)
end
