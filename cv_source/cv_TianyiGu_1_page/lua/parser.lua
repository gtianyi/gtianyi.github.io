require("lualibs.lua")

function getJsonFromFile(file)
  local fileHandle = io.open(file)
  local jsonString = fileHandle:read('*a')
  fileHandle:close()
  local jsonData = utilities.json.tolua(jsonString)
  return jsonData
end

local function each(list, fn)
  for i = 1, #list do
    fn(list[i])
  end
end

function printEduItems(file)
  local json = getJsonFromFile(file)
  each(json, function(value)
    tex.print("\\resumeEduEntry{" .. value["school"] .. "}{" .. (value["school_location"] or "") .. "}{" .. value["degree"] .. "}{" .. value["time_period"] .. "}")
  end)
end

function printExpItems(file)
  local json = getJsonFromFile(file)
  local previousCompany = nil
  each(json, function(value)
    local role = value["role"]
    if value["team"] ~= nil and value["team"] ~= "" then
      role = role .. " $\\cdot$ " .. value["team"]
    end
    if previousCompany == value["company"] then
      tex.print("\\resumeRole{" .. role .. "}{" .. value["time_duration"] .. "}")
    else
      tex.print("\\resumeExpEntry{" .. value["company"] .. "}{" .. (value["company_location"] or "") .. "}{" .. role .. "}{" .. value["time_duration"] .. "}")
      previousCompany = value["company"]
    end

    tex.print("\\resumeItemListStart")
    each(value["details"], function(detail)
      if detail["title"] ~= nil and detail["title"] ~= "" then
        tex.print("\\resumeItem{" .. detail["title"] .. "}{" .. detail["description"] .. "}")
      else
        tex.print("\\resumePlainItem{" .. detail["description"] .. "}")
      end
    end)
    tex.print("\\resumeItemListEnd")
  end)
end

function printPubItems(file)
  local json = getJsonFromFile(file)
  each(json, function(value)
    local title = value["title"]:gsub("%.$", "")
    tex.print("\\resumeSubItem{" .. title .. "}{" .. value["authors"] .. ". " .. value["venue"] .. "}")
  end)
end

function printHeading(file)
  local value = getJsonFromFile(file)[1]
  local site = value["website"]
  tex.print("\\begin{tabular*}{\\textwidth}{@{}l@{\\extracolsep{\\fill}}r@{}}")
  tex.print("\\textbf{\\href{" .. site .. "}{\\Large " .. value["name"] .. "}} & " .. value["email"] .. " \\\\")
  tex.print("\\href{" .. site .. "}{" .. site .. "} & " .. value["phone"] .. " \\\\")
  tex.print("\\end{tabular*}")
end

function printField(file, field)
  local value = getJsonFromFile(file)[1]
  tex.print(value[field])
end

function printList(file, primary, secondary)
  local value = getJsonFromFile(file)[1]
  local parts = {}
  each(value[primary], function(item)
    parts[#parts + 1] = item[secondary]
  end)
  tex.print(table.concat(parts, ", "))
end
