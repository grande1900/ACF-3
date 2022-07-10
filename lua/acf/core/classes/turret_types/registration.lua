local Classes = ACF.Classes
local Turrets = Classes.TurretTypes
local Entries = {}


function Turrets.Register(ID, Base)
	return Classes.AddObject(ID, Base, Entries)
end

Classes.AddSimpleFunctions(Turrets, Entries)
