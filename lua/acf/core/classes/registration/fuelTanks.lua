local Classes = ACF.Classes

Classes.FuelTanks = Classes.FuelTanks or {}

local FuelTanks = Classes.FuelTanks
local Entries   = {}


function FuelTanks.RegisterGroup(ID, Data)
	local Group = Classes.AddClassGroup(ID, Entries, Data)

	if not Group.LimitConVar then
		Group.LimitConVar = {
			Name   = "_acf_fueltank",
			Amount = 32,
			Text   = "Maximum amount of ACF fuel tanks a player can create."
		}
	end

	Classes.AddSboxLimit(Group.LimitConVar)

	return Group
end

function FuelTanks.Register(ID, ClassID, Data)
	local Class = Classes.AddGrouped(ID, ClassID, Entries, Data)

	if Class.IsExplosive == nil then
		Class.IsExplosive = true
	end

	return Class
end

Classes.AddGroupedFunctions(FuelTanks, Entries)

do -- Discontinued functions
	function ACF_DefineFuelTank(ID)
		print("Attempted to register fuel tank type " .. ID .. " with a discontinued function. Use ACF.RegisterFuelTankClass instead.")
	end

	function ACF_DefineFuelTankSize(ID)
		print("Attempted to register fuel tank " .. ID .. " with a discontinued function. Use ACF.RegisterFuelTank instead.")
	end
end
