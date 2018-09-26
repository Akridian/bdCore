local bdCore, c, f = select(2, ...):unpack()

local IsItemInRange, CheckInteractDistance, UnitInRange, find, sub, gsub, floor, byte, tinsert = IsItemInRange, CheckInteractDistance, UnitInRange, string.find, string.sub, string.gsub, math.floor, string.byte, table.insert

-- Unit scanning, sure if i'll use yet since can be expensive
function UnitInRadius(unit, yards)
	if (UnitIsUnit("player",unit) or UnitIsDeadOrGhost(unit)) then
		return false
	end

	local range = 1000
	if IsItemInRange(37727, unit) then range = 5 --Ruby Acorn
	elseif IsItemInRange(63427, unit) then range = 8 --Worgsaw
	elseif CheckInteractDistance(unit, 3) then range = 10 
	elseif CheckInteractDistance(unit, 2) then range = 11 
	elseif IsItemInRange(32321, unit) then range = 13 --reports 12 but actual range tested is 13
	elseif IsItemInRange(6450, unit) then range = 18 --Bandages
	elseif IsItemInRange(21519, unit) then range = 22 --Item says 20, returns true until 22.
	elseif CheckInteractDistance(unit, 1) then range = 30
	elseif UnitInRange(unit) then range = 43
	elseif IsItemInRange(116139, unit)  then range = 50
	elseif IsItemInRange(32825, unit) then range = 60
	elseif IsItemInRange(35278, unit) then range = 80 end

	if (range <= yards) then
		return true
	end

	return false
end

-- also comma values
function comma_value(amount)
	local formatted = amount
	while true do  
		formatted, k = gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end
-- not crazy about the built in split function
function split(str, del)
	local t = {}
	local index = 0;
	while (find(str, del)) do
		local s, e = find(str, del)
		t[index] = sub(str, 1, s-1)
		str = sub(str, s+#del)
		index = index + 1;
	end
	tinsert(t, str)
	return t;
end

-- lua doesn't have a good function for round
function round(num, idp)
	local mult = 10^(idp or 0)
	return floor(num * mult + 0.5) / mult
end

-- lua doesn't have a good function for finding a value in a table
function in_table ( e, t )
	for _,v in pairs(t) do
		if (v==e) then return true end
	end
	return false
end

local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

-- This function can return a substring of a UTF-8 string, properly handling
-- UTF-8 codepoints.  Rather than taking a start index and optionally an end
-- index, it takes the string, the starting character, and the number of
-- characters to select from the string.
bdCore.utf8sub = memoize(function(self, str, startChar, numChars)
	local startIndex = 1
	while startChar > 1 do
		local char = byte(str, startIndex)
		startIndex = startIndex + chsize(char)
		startChar = startChar - 1
	end

	local currentIndex = startIndex

	while numChars > 0 and currentIndex <= #str do
		local char = byte(str, currentIndex)
		currentIndex = currentIndex + chsize(char)
		numChars = numChars -1
	end
	return sub(str, startIndex, currentIndex - 1)
end)