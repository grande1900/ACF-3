local util     = util
local hook     = hook
local isstring = isstring
local istable  = istable
local Classes  = ACF.Classes
local Groups   = {}


local function GetDestinyData(Destiny)
	local Data = Groups[Destiny]

	if not Data then
		Data = {}

		Groups[Destiny] = Data
	end

	return Data
end

function Classes.AddClassGroup(ID, Destiny, Data)
	if not isstring(ID) then return end
	if not istable(Destiny) then return end
	if not istable(Data) then return end

	local Group = Destiny[ID]

	if not Group then
		Group = {
			ID     = ID,
			Lookup = {},
			Items  = {},
			Count  = 0,
		}

		Destiny[ID] = Group
	end

	for K, V in pairs(Data) do
		Group[K] = V
	end

	hook.Run("ACF_OnNewClassGroup", ID, Group)

	return Group
end

function Classes.AddGrouped(ID, GroupID, Destiny, Data)
	if not isstring(ID) then return end
	if not isstring(GroupID) then return end
	if not istable(Destiny) then return end
	if not istable(Data) then return end
	if not Destiny[GroupID] then return end

	local Group = Destiny[GroupID]
	local Class = Group.Lookup[ID]

	if not Class then
		local DestinyData = GetDestinyData(Destiny)

		Class = {
			ID      = ID,
			Class   = Group,
			ClassID = GroupID,
		}

		DestinyData[ID] = Group

		Group.Count              = Group.Count + 1
		Group.Lookup[ID]         = Class
		Group.Items[Group.Count] = Class
	end

	for K, V in pairs(Data) do
		Class[K] = V
	end

	hook.Run("ACF_OnNewGroupedClass", ID, Group, Class)

	return Class
end

function Classes.GetClassGroup(Destiny, Name)
	if not istable(Destiny) then return end
	if not isstring(Name) then return end

	local Data  = Groups[Destiny]
	local Class = Data and Data[Name]

	if Class then return Class end

	local Group = Destiny[Name]

	if not Group then return end

	return Group.IsScalable and Group
end

function Classes.AddGroupedFunctions(Namespace, Entries)
	if not istable(Namespace) then return end
	if not istable(Entries) then return end

	-- Getters
	function Namespace.GetGroup(ID)
		return isstring(ID) and Entries[ID] or nil
	end

	function Namespace.Get(ID, ClassID)
		local Group = isstring(ClassID) and Entries[ClassID]

		if not Group then return end

		return isstring(ID) and Group.Lookup[ID] or nil
	end

	-- Aliases
	function Namespace.AddGroupAlias(ID, Alias)
		if not isstring(ID) then return end
		if not isstring(Alias) then return end

		Entries[Alias] = Entries[ID]
	end

	function Namespace.AddAlias(ID, GroupID, Alias)
		local Group = isstring(GroupID) and Entries[GroupID]

		if not Group then return end
		if not isstring(ID) then return end
		if not isstring(Alias) then return end

		local Lookup = Group.Lookup

		Lookup[Alias] = Lookup[ID]
	end

	function Namespace.IsGroupAlias(ID)
		local Data = isstring(ID) and Entries[ID]

		return Data and Data.ID == ID or false
	end

	function Namespace.IsAlias(ID, GroupID)
		local Group = isstring(GroupID) and Entries[GroupID]

		if not Group then return false end

		local Data = isstring(ID) and Group.Lookup[ID]

		return Data and Data.ID == ID or false
	end
end

hook.Add("ACF_OnNewClassGroup", "ACF Precache Model", function(_, Group)
	if not isstring(Group.Model) then return end

	util.PrecacheModel(Group.Model)
end)

hook.Add("ACF_OnNewGroupedClass", "ACF Precache Model", function(_, _, Class)
	if not isstring(Class.Model) then return end

	util.PrecacheModel(Class.Model)
end)
