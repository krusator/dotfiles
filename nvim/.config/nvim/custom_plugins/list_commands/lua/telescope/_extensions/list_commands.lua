local list_commands = require("list_commands")

print("Registering list_commands extension")
return require("telescope").register_extension({
    exports = {
        list_commands = list_commands.list_commands,
    },
})
