local HttpService = game:GetService("HttpService")

local File = {}

-- Creates all missing folders in a path.
function File.EnsureFolder(Path)
    local Current = ""

    for Folder in string.gmatch(Path, "[^/]+") do
        Current = (Current == "") and Folder or (Current .. "/" .. Folder)

        if not isfolder(Current) then
            makefolder(Current)
        end
    end
end

-- Saves a table as JSON.
function File.Save(Path, Data)
    local Folder = Path:match("(.+)/[^/]+$")
    if Folder then
        File.EnsureFolder(Folder)
    end

    writefile(Path, HttpService:JSONEncode(Data))
end

-- Loads a JSON file into a table.
-- If the file doesn't exist, it creates it using Default.
function File.Load(Path, Default)
    if not isfile(Path) then
        if Default ~= nil then
            File.Save(Path, Default)
            return Default
        end

        return nil
    end

    return HttpService:JSONDecode(readfile(Path))
end

-- Deletes a file.
function File.Delete(Path)
    if isfile(Path) then
        delfile(Path)
    end
end

-- Returns true if the file exists.
function File.Exists(Path)
    return isfile(Path)
end

return File
