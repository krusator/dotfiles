local project_to_tmux = require("project_to_tmux")

print("Registering project_to_tmux extension")
return require("telescope").register_extension({
    exports = {
        project_to_tmux = project_to_tmux.project_to_tmux,
    },
})
