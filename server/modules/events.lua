RegisterNetEvent('hooka:createHookaLocation', function(location, entity)
    local src = source

    if not src then 
        return 
    end

    local Player = ESX.GetPlayerFromId(src)

    if not Player then 
        return 
    end

    Hookas[#Hookas + 1] = {
        id = #Hookas + 1,
        owner = {
            id = Player.identifier,
            name = Player.name
        },
        charge = 100,
        location = location,
        tobacco = false,
        isSomeoneSmoking = false,
        entity = entity
    }

    TriggerClientEvent('hooka:syncLocations', -1, Hookas)
end)

RegisterNetEvent("eff_smokes", function(hooka, entity)
    local src = source 

    if not src then 
        return 
    end

    local Player = ESX.GetPlayerFromId(src)

    if not Player then 
        return
    end

    if Hookas[hooka] then 
        -- @ Validate if is player smoking
        if Hookas[hooka].isSomeoneSmoking then 
            if Hookas[hooka].isSomeoneSmoking ~= src then 
                return Player.showNotification("Parece que hay otra persona fumando...")
            end
        end

        -- @ Validate if has tobacco
        if not Hookas[hooka].tobacco then 
            return Player.showNotification("Esta hooka no tiene tabaco...")
        end
       
        -- @ Remove charge on smoke
        Hookas[hooka].charge = Hookas[hooka].charge - 2
        
        TriggerClientEvent("c_eff_smokes", -1, entity, Hookas)
    end
end)

RegisterNetEvent('hooka:attachHose', function(hooka)
    local src = source

    if not src then 
        return 
    end

    local Player = ESX.GetPlayerFromId(src)

    if not Player then 
        return 
    end

    if Hookas[hooka] then 
        if Hookas[hooka].isSomeoneSmoking then 
            return Player.showNotification("Alguien está fumando en esta hooka") 
        end

        Hookas[hooka].isSomeoneSmoking = src
    end

    TriggerClientEvent('hooka:clientHoseAttatch', src)
end)

RegisterNetEvent('hooka:dettatchHose', function(hooka)
    local src = source

    if not src then 
        return 
    end

    local Player = ESX.GetPlayerFromId(src)

    if not Player then 
        return 
    end

    if Hookas[hooka] then 
        Hookas[hooka].isSomeoneSmoking = false

        TriggerClientEvent('hooka:syncLocations', -1, Hookas)
    end
end)

RegisterNetEvent('hooka:deleteHooka', function(hooka)
    local src = source

    if not src then 
        return 
    end

    local Player = ESX.GetPlayerFromId(src)

    if not Player then 
        return 
    end

    if Hookas[hooka] then
        if Hookas[hooka].isSomeoneSmoking ~= false then 
            Player.showNotification("Alguien está fumando, no puedes retirar la hooka...")

            return 
        end

        if Player.getJob().name == Config.AllowedJob or (Player.getGroup() ~= 'user' and Config.isAdminAllowed) or Hookas[hooka].isSomeoneSmoking == src then
            Hookas[hooka] = false

            Player.addInventoryItem(Config.Item, 1)

            TriggerClientEvent('hooka:syncLocations', -1, Hookas)
        else
            Player.showNotification("No puedes retirar la hooka")
        end
    end
end)

RegisterNetEvent('hooka:useTobacco', function(tobaccoIndex)
    local src = source

    if not src then 
        return 
    end

    local tobacco = Config.Tobacco[tobaccoIndex]

    if not tobacco then 
        return 
    end

    setHookaTobacco(src, tobacco)
end)