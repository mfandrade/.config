THEMES_DIR := themes/themes

# Select theme interactively and store in .selected_theme
all:
	echo "$$(ls -1 "$(THEMES_DIR)" | fzf --prompt="Select your preferred alacritty theme:" || echo ayu_light.toml)" > .selected_theme
	$(MAKE) setup

# Read selected theme from file, fallback to default if file missing or empty
THEME := $(shell test -s .selected_theme && cat .selected_theme || echo ayu_light.toml)

# If THEME ends with _light.toml, use it for lite.toml and generate dark.toml by replacing _light.toml with _dark.toml
ifeq ($(filter %_light.toml,$(THEME)),%_light.toml)
lite.toml:
	ln -sf "$(THEMES_DIR)/$(THEME)" lite.toml

dark.toml: lite.toml
	ln -sf "$(THEMES_DIR)/$(patsubst %_light.toml,%_dark.toml,$(THEME))" dark.toml

else
# Otherwise, use THEME for both lite.toml and dark.toml
lite.toml:
	ln -sf "$(THEMES_DIR)/$(THEME)" lite.toml

dark.toml:
	ln -sf "$(THEMES_DIR)/$(THEME)" dark.toml

endif

setup: lite.toml dark.toml
	cp alacritty.toml.example alacritty.toml
