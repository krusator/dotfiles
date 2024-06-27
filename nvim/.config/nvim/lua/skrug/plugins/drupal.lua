return {
    "jdrupal-dev/drupal.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("drupal").setup({
            services_cmp_trigger_character = "@",
            get_drush_executable = function(current_dir)
                return "drush"
            end
        })
    end
}
