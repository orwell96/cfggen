-- Generate random words from a context-free grammar
--[[
Usage: cfggen.lua <rules file> [count] [seed]
Each newline a separate rule
The start nonterminal is always <init>
Lines starting with # are comments
Rule pattern:
(spaces before/after operators optional)
nonterminal = terminal <nonterminal> terminal | otherterminal <othernonterminal>
OR
weight * nonterminal = terminal <nonterminal> terminal
(where weight is a positive integer)

<e> is the empty string
]]--


function string.split(str, delim, include_empty, max_splits, sep_is_pattern)
	delim = delim or ","
	max_splits = max_splits or -1
	local items = {}
	local pos, len, seplen = 1, #str, #delim
	local plain = not sep_is_pattern
	max_splits = max_splits + 1
	repeat
		local np, npe = string.find(str, delim, pos, plain)
		np, npe = (np or (len+1)), (npe or (len+1))
		if (not np) or (max_splits == 1) then
			np = len + 1
			npe = np
		end
		local s = string.sub(str, pos, np - 1)
		if include_empty or (s ~= "") then
			max_splits = max_splits - 1
			items[#items + 1] = s
		end
		pos = npe + 1
	until (max_splits == 0) or (pos > (len + 1))
	return items
end

local rules={}

local rf, err=io.open(arg[1], "r")

local seed=tonumber(arg[3])
if seed then
	math.randomseed(seed)
else
	math.randomseed(os.time())
end

local repeatcnt=tonumber(arg[2])
if not repeatcnt then
	repeatcnt=1
end

if not rf then
	error("Unable to open rules file: "..(err or "<unknown>"))
end

local function addrule(nt, rule)
	if not rules[nt] then
		rules[nt]={}
	end
	table.insert(rules[nt], rule)
end

local line=rf:read("*l")
while line do
	if not string.match(line, "^#") and line~="" then
		local wei, nt, repl = string.match(line, "^%s*(%d+)%s*%*%s*([^%s=]+)%s*=(.*)$")
		if not wei then
			wei = 1
			nt, repl = string.match(line, "%s*([^%s=]+)%s*=(.*)$")
		end
		if tonumber(wei) and nt and repl then
			local opt=string.split(repl, "|")
			for _, optn in ipairs(opt) do
				for i=1, tonumber(wei) do
					addrule(nt, string.match(optn, "^%s*(.-)%s*$"))
				end
			end
		else
			print("-!- Wrongly formatted line: "..line)
		end
	end
	line=rf:read("*l")
end

local subj="<init>"
local done=true

local function replace(nterm)
	if nterm=="e" then return "" end
	local lookup=rules[nterm]
	if not lookup then
		return "<"..nterm..">"
	end
	local replc = lookup[math.random(#lookup)]
	local modistr, n = string.gsub(replc, "<(.-)>", replace)
	return modistr
end

for i=1, repeatcnt do
	print(replace("init"))
end
