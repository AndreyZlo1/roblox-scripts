-- ══════════════════════════════════════════════════════════════════
-- network = u17 instance  (shared.import("network"))
-- Захардкожен в ReplicatedFirst.Flux/client (строки 97-155)
-- НЕ является ModuleScript — создаётся через u17.new()
-- ══════════════════════════════════════════════════════════════════

-- ── Зависимости (upvalues Flux/client) ───────────────────────────
-- RemoteEvent         = RS.Events.RemoteEvent
-- UnreliableRemoteEvent = RS.Events.UnreliableRemoteEvent
-- RemoteFunction      = RS.Events.RemoteFunction
-- VerifyFunction      = RS.Events.VerifyFunction  (уничтожается после)

-- ── Поля экземпляра ───────────────────────────────────────────────
-- network._code    = VerifyFunction:InvokeServer()
--                   строка/число — сессионный токен, меняется каждый вход
--                   первый элемент каждого FireServer/InvokeServer payload
-- network._key     = HttpService:JSONDecode(PlayerGui.Key.Value)
--                   массив из 5 чисел: {k1, k2, k3, k4, k5}
--                   текущие значения: {34, 20, 40, 17, 33}
-- network._events  = {} -- таблица OnClientEvent обработчиков
-- network._functions = {} -- таблица OnClientInvoke обработчиков

-- ── u16(str, key) — шифр ─────────────────────────────────────────
-- Применяется ко ВСЕМ FireServer и InvokeServer payload
--
-- local function u16(str, key)
--     local result = ""
--     for i = 1, #str do
--         for shift = 0, 3 do
--             if i % 4 == shift then
--                 local byte = string.byte(str, i)
--                 local k    = key[shift + 1]        -- key[1..4]
--                 local enc  = (byte - 32 + k) % 95 + 32
--                 result = result .. string.char(enc)
--                 break
--             end
--         end
--     end
--     -- suffix: key[5] дополнительных байт
--     for s = 1, key[5] do
--         local b1  = string.byte(str)               -- первый байт str
--         local b2  = string.byte(tostring(s))       -- первый байт "1","2",...
--         result = result .. string.char(b1 - b2)
--     end
--     return result
-- end

-- ── Методы ────────────────────────────────────────────────────────

-- network:FireServer(action, ...)
--   payload = HttpService:JSONEncode({network._code, action, ...})
--   sends  = RemoteEvent:FireServer(u16(payload, network._key))

-- network:FireUnreliableServer(...)
--   НЕ шифруется, НЕ добавляет _code
--   sends = UnreliableRemoteEvent:FireServer(HttpService:JSONEncode({...}))

-- network:InvokeServer(action, ...)
--   payload = HttpService:JSONEncode({network._code, action, ...})
--   returns = RemoteFunction:InvokeServer(u16(payload, network._key))

-- network:ConnectEvents(map)
--   map = { [eventName] = function(...) end, ... }
--   регистрирует обработчики OnClientEvent

-- network:ConnectFunctions(map)
--   map = { [funcName] = function(...) end, ... }
--   регистрирует обработчики OnClientInvoke

-- network:Listen()
--   подключает RemoteEvent/UnreliableRemoteEvent/RemoteFunction слушатели

-- ── Пример расшифровки payload ────────────────────────────────────
-- key = {34, 20, 40, 17, 33}  (из _key_raw.txt)
-- Для декодирования (обратный u16):
--   byte_orig = (byte_enc - 32 - key[i%4+1]) % 95 + 32
-- suffix байты отбрасываются (последние key[5]=33 байта результата)
