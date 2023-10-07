package.path = package.path .. ";/etc/pdns/ech-injector/modules/?.lua"
local json = require "json.json"
local mmdb = require "mmdb.mmdb.init"

local config = json.decode(io.open("/etc/pdns/ech-injector/config.json", "r"):read("a"))
local maxmind_database = assert(mmdb.read(config["modules"]["maxmind"]))

function postresolve(dq)
    if dq.qtype == pdns.HTTPS then
        local records = dq:getRecords()
        for _, v in pairs(records) do
            local content = v:getContent()
            if not string.find(content, "ech", nil, true) then
                local ipv4hint = string.match(content, "ipv4hint=([^ ]+)")
                if ipv4hint then
                    for ipv4 in string.gmatch(ipv4hint, "[^,]+") do
                        local ipv4ech = config["ech"][tostring(maxmind_database:search_ipv4(ipv4).autonomous_system_number)]
                        if ipv4ech then
                            v:changeContent(content .. " ech=" .. ipv4ech)
                            dq:setRecords(records)
                            return true
                        end
                    end
                end

                local ipv6hint = string.match(content, "ipv6hint=([^ ]+)")
                if ipv6hint then
                    for ipv6 in string.gmatch(ipv6hint, "[^,]+") do
                        local ipv6ech = config["ech"][tostring(maxmind_database:search_ipv6(ipv6).autonomous_system_number)]
                        if ipv6ech then
                            v:changeContent(content .. " ech=" .. ipv6ech)
                            dq:setRecords(records)
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end
