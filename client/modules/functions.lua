-- @ Hooka
function createHookaObject()
    local obj =  CreateObject(4037417364, GetEntityCoords(PlayerPedId()), false, 0, false)

    NetworkRegisterEntityAsNetworked(obj)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
    NetworkSetNetworkIdDynamic(NetworkGetNetworkIdFromEntity(obj), false) 

    return obj
end

function createHookaOnHand() 
    local obj = createHookaObject()

    AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.00, 0.355, 220.0, 470.0, 0.0, true, true, false, true, 1, true)

    return obj
end

function deleteHookaObject(obj)
    DeleteEntity(obj)
end

function currentHookaToFloor(currentHooka) 
    awaitProgress()

    deleteHookaObject(currentHooka)

    local obj = createHookaObject()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local floorCoords = vector3(playerCoords.x, playerCoords.y, playerCoords.z - 0.7)

    SetEntityCoords(obj, floorCoords)
    FreezeEntityPosition(obj, true)
    
    TriggerServerEvent('hooka:createHookaLocation', playerCoords, obj)

    return obj
end

function deleteNearHookaObject()
    local playerCoords = GetEntityCoords(PlayerPedId())
end

-- @ Screen text
function screenText(text)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(1, 1)
end

function hookaText(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.40 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

-- @ Hose
function attatchHose() 
    local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	local model = GetHashKey('v_corp_lngestoolfd')
	
    RequestModel(model)

	while not HasModelLoaded(model) do
		Wait(100)
	end

	local obj = CreateObject(model,  coords.x + 0.5, coords.y + 0.1, coords.z + 0.4, true, false, true)

	AttachEntityToEntity(obj, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)	

    local anim = "amb@world_human_clipboard@male@base"
    
    RequestAnimDict(anim)
    
    while not HasAnimDictLoaded(anim) do
        Wait(0)
    end
	
    local boneIndex = GetPedBoneIndex(playerPed, 0x67F2)

    TaskPlayAnim(playerPed, anim, "base", 2.0, 2.0, -1, 49, 0, false, false, false)

    return obj
end

function deleteHoseObject(obj, hookaId)
    DeleteEntity(obj)

    -- @ Restore hose variables
    HoseObject = nil

    -- @ Cancel animation
    ClearPedTasks(player)

    -- @ Global remove smoking state
    TriggerServerEvent("hooka:dettatchHose", hookaId)
end

-- @ Display circle
function awaitProgress() 
    if lib ~= nil then
        lib:progressCircle({
            duration = 2000,
            position = 'middle',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true
            },
        }) 
    end
end