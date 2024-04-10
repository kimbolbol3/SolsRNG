--getgenv().Webhook = "https://discord.com/api/webhooks/1208822291165880421/IPl0_iZqvB4nZJjLx08dq-IK0jYuz3p1XTSVu92tF7w5z1At0QdKkvtMgH4mLQ9SCIt1"

function SendMessage(url, message)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

function SendMessageEMBED(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        }
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end
local oldinventory = nil

game:GetService("Players").LocalPlayer.leaderstats.Rolls:GetPropertyChangedSignal("Value"):Connect(function()
    local roll = game:GetService("Players").LocalPlayer.leaderstats.Rolls.Value
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.AuraInventory.InventoryFrame.ItemsHolder:GetChildren()

    if oldinventory then
        if not areTablesEqual(oldinventory, inventory) then
            local numbers = {}
            for number in game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.AuraInventory.InventoryFrame.Title.Text:gmatch("%d+") do
                table.insert(numbers, tonumber(number))
            end
            local aura = inventory[numbers[1]+2].BaseFrame.AuraName.Text
            local rarity = game:GetService("ReplicatedStorage").TiersUI:FindFirstChild(inventory[numbers[1]+2].BaseFrame.AuraName.Text).Rarity.Text
            local coin = game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.Coin.Text
            local inventorylabe = ""
            for i,v in pairs(inventory) do
                if v:IsA("Frame") and v.Name ~= "ItemASDF" then
                    if i == numbers[2] then
                        inventorylabe = inventorylabe .. tostring(v.BaseFrame.AuraName.Text)
                    else
                        inventorylabe = inventorylabe .. tostring(v.BaseFrame.AuraName.Text) .. ", "
                    end
                end
                
            end
            local embed = {
                ["title"] = "Sol's aura Epic Tracker!!!!!!",
                ["description"] = "",
                ["color"] = 65280,
                ["fields"] = {
                    {
                        ["name"] = "What You Got",
                        ["value"] = `{aura} , {rarity}`,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Your Rolls",
                        ["value"] = `{roll}`,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Your Coin",
                        ["value"] = `{coin}`,
                        ["inline"] = true
                    },
                    {
                        ["name"] = `Your Inventory {numbers[1]}/{numbers[2]}`,
                        ["value"] = `{inventorylabe}`,
                    }
                },
                ["footer"] = {
                    ["text"] = ""
                }
            }
            SendMessageEMBED(getgenv().Webhook,embed)
        end
    end

    oldinventory = inventory
end)

function areTablesEqual(table1, table2)
    if #table1 > #table2 then
        return true
    end
    if #table1 ~= #table2 then
        return false
    end

    for i, v in ipairs(table1) do
        if v ~= table2[i] then
            return false
        end
    end

    return true
end