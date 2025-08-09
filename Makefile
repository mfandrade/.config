.PHONY: home prereqs asdf configdir asdf_plugins fish_setup fonts

DRYRUN ?= 0
DOTFILES ?= $(HOME)/src/dotfiles
CONFIG_BACKUP ?= $(HOME)/dirs/Backups/config_backup
DO = $(if $(filter 1,$(DRYRUN)),echo,)

install: home prereqs $(DOTFILES) asdf configdir asdf_plugins fish_setup fonts
	@echo "🚀 Ambiente configurado com sucesso!"

.PHONY: fish_setup

fish_setup:
	@echo "🐟 Verificando se Oh My Fish está instalado..."
	@if ! fish -c "type -q omf"; then \
		echo "📦 Instalando Oh My Fish..."; \
		curl -sL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish; \
	else \
		echo "✅ Oh My Fish já está instalado."; \
	fi
	@echo "🎨 Instalando tema bobthefish (se necessário)..."
	@fish -c "omf list | grep -q bobthefish || omf install bobthefish"

fonts:
	@echo "🔍 Verificando se fontes já estão instaladas..."
	@if ! ls $(HOME)/.local/share/fonts | grep -q "UbuntuMono.*Nerd.*.ttf"; then \
		echo "⬇️ Baixando UbuntuMono Nerd Font..."; \
		curl -L -o /tmp/UbuntuMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuMono.zip; \
		unzip -o /tmp/UbuntuMono.zip -d $(HOME)/.local/share/fonts; \
	else \
		echo "✅ UbuntuMono Nerd Font já instalada."; \
	fi
	@if ! ls $(HOME)/.local/share/fonts | grep -q "JetBrainsMono.*Nerd.*.ttf"; then \
		echo "⬇️ Baixando JetBrainsMono Nerd Font..."; \
		curl -L -o /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip; \
		unzip -o /tmp/JetBrainsMono.zip -d $(HOME)/.local/share/fonts; \
	else \
		echo "✅ JetBrainsMono Nerd Font já instalada."; \
	fi
	@echo "🔄 Atualizando cache de fontes..."
	@fc-cache -fv

# Lista de plugins e versões (formato: plugin/version ou plugin)
PLUGINS := bat difftastic fd fzf hurl jq lazygit lua/5.1.5 neovim nodejs ripgrep rust tmux

.PHONY: asdf_plugins
asdf_plugins: asdf
	@for entry in $(PLUGINS); do \
		plugin=$$(echo $$entry | cut -d'/' -f1); \
		version=$$(echo $$entry | cut -d'/' -f2); \
		[ "$$version" = "$$plugin" ] && version=latest; \
		\
		echo "🔍 Verificando plugin: $$plugin (versão: $$version)"; \
		if ! asdf plugin list | grep -q "^$$plugin$$"; then \
			echo "➕ Adicionando plugin $$plugin"; \
			asdf plugin add "$$plugin"; \
		fi; \
		\
		current=$$(asdf current "$$plugin" 2>/dev/null | awk '{print $$2}'); \
		if [ "$$current" != "$$version" ]; then \
			if ! asdf list "$$plugin" | grep -q "^	$$version$$"; then \
				echo "⬇️ Instalando $$plugin $$version"; \
				asdf install "$$plugin" "$$version"; \
			fi; \
			echo "📌 Definindo $$plugin $$version como global"; \
			asdf set --home "$$plugin" "$$version"; \
		else \
			echo "✅ $$plugin já está na versão desejada ($$version)"; \
		fi; \
	done


configdir: $(DOTFILES)
	@echo "📦 Fazendo backup de $(HOME)/.config para $(CONFIG_BACKUP)..."
	@if [ -d "$(HOME)/.config" ] && [ ! -L "$(HOME)/.config" ]; then \
		mv $(HOME)/.config $(CONFIG_BACKUP); \
	else \
		echo "ℹ️ Nenhum diretório .config original encontrado ou já é um symlink."; \
	fi
	@echo "🔗 Criando link simbólico de $(DOTFILES)/.config para $(HOME)/.config..."
	@rm -rf $(HOME)/.config
	@ln -sf $(DOTFILES)/.config $(HOME)/.config

restoreconfig: configdir
	@echo "♻️ Restaurando arquivos ausentes de $(CONFIG_BACKUP) para $(HOME)/.config..."
	@for item in $$(ls -A $(CONFIG_BACKUP)); do \
		if [ ! -e "$(HOME)/.config/$$item" ]; then \
			echo "↩️ Restaurando $$item para $(HOME)/.config"; \
			cp -r --update=none $(CONFIG_BACKUP)/$$item $(DOTFILES)/.config/; \
		else \
			echo "✅ $$item já gerenciado. Ignorando."; \
		fi \
	done
	@echo "✅ Configuração vinculada com sucesso!"


asdf:
	@echo "🔍 Verificando versão atual do asdf..."
	@LATEST=$$(curl -sI https://github.com/asdf-vm/asdf/releases/latest | awk 'BEGIN{FS="/"} /^[Ll]ocation:/{print $$NF}' | tr -d '\r\n'); \
	CURRENT=$$(asdf version 2>/dev/null | awk '{print $$1}' | tr -d '\r\n'); \
	if [ -z "$$CURRENT" ] || [ "$$CURRENT" != "$$LATEST" ]; then \
		echo "📦 Instalando ou atualizando asdf para versão $$LATEST..."; \
		rm /tmp/asdf.tgz 2>/dev/null && curl -sL "https://github.com/asdf-vm/asdf/releases/download/$$LATEST/asdf-$$LATEST-linux-amd64.tar.gz" -o /tmp/asdf.tgz && \
		tar -xzf /tmp/asdf.tgz -C /tmp; \
		mkdir -p $(HOME)/bin; \
		mv /tmp/asdf $(HOME)/bin/asdf; \
		rm /tmp/asdf.tgz; \
		echo "✅ asdf atualizado para $$LATEST em $(HOME)/bin/asdf"; \
	else \
		echo "✅ asdf já está na versão mais recente ($$CURRENT). Nada a fazer."; \
	fi


$(DOTFILES): prereqs
		@if [ -d "$(DOTFILES)/.git" ]; then \
		echo "🔄 Repositório DOTFILES já existe. Atualizando com git pull..."; \
		cd $(DOTFILES) && git pull --all; \
	elif [ -d "$(DOTFILES)" ]; then \
		echo "⚠️ Diretório $(DOTFILES) existe mas não é um repositório Git. Abortando."; \
		exit 1; \
	else \
		echo "📥 Clonando repositório DOTFILES em $(DOTFILES)..."; \
		git clone --recurse-submodules https://github.com/mfandrade/dotfiles.git $(DOTFILES); \
		pushd $(DOTFILES); git submodule update --init --recursive; popd; \
	fi

	@echo "🔗 Criando link simbólico de $@/.config/bin para $(HOME)/bin..."
	@ln -sf $@/.config/bin $(HOME)/bin
	@echo "✅ Link simbólico criado com sucesso!"


prereqs:
	@echo "🔍 Verificando e instalando pré-requisitos..."
	@if ! command -v git >/dev/null 2>&1; then \
		echo "📦 Instalando git..."; \
		$(DO) sudo apt update && sudo apt install -y git; \
	else \
		echo "✅ git já está instalado."; \
	fi
	@if ! command -v curl >/dev/null 2>&1; then \
		echo "📦 Instalando curl..."; \
		$(DO) sudo apt update && sudo apt install -y curl; \
	else \
		echo "✅ curl já está instalado."; \
	fi
	@if ! command -v unzip >/dev/null 2>&1; then \
		echo "📦 Instalando unzip..."; \
		$(DO) sudo apt update && sudo apt install -y unzip; \
	else \
		echo "✅ unzip já está instalado."; \
	fi
	@if ! command -v bash >/dev/null 2>&1; then \
		echo "📦 Instalando bash..."; \
			$(DO) sudo apt update && sudo apt install -y bash bash_completion; \
			echo '. <(asdf completion bash)' >> $(HOME)/.bashrc; \
	else \
		echo "✅ bash já está instalado."; \
	fi
	@if ! command -v fish >/dev/null 2>&1; then \
		echo "📦 Instalando fish..."; \
		$(DO) sudo apt update && sudo apt install -y fish; \
		echo 'asdf completion fish > $(HOME)/.config/fish/completions/asdf.fish'; \
	else \
		echo "✅ fish já está instalado."; \
	fi
	@echo "✅ Pré-requisitos verificados."


home:
	@echo "📁 Usando diretório de dotfiles: $(DOTFILES)"
	@echo "📁 Criando pasta ~/dirs se necessário..."
	$(DO) mkdir -p $(HOME)/dirs

	@echo "🚚 Movendo diretórios padrão para ~/dirs..."
	@for dir in Desktop Documents Pictures Music Videos Public; do \
		if [ -d "$(HOME)/$$dir" ]; then \
			$(DO) mv "$(HOME)/$$dir" "$(HOME)/dirs/$$dir"; \
		else \
			echo "🔍 Diretório $$dir não encontrado."; \
		fi; \
	done

	@echo "🔄 Renomeando Templates → Software, Downloads → Inbox e Pictures → Images..."
	@if [ -d "$(HOME)/Templates" ]; then \
		$(DO) mv "$(HOME)/Templates" "$(HOME)/dirs/Software"; \
	fi
	@if [ -d "$(HOME)/Downloads" ]; then \
		$(DO) mv "$(HOME)/Downloads" "$(HOME)/dirs/Inbox"; \
	fi
	@if [ -d "$(HOME)/Pictures" ]; then \
		$(DO) mv "$(HOME)/Pictures" "$(HOME)/dirs/Images"; \
	fi

	@echo "📁 Criando diretórios VMs e Backups se necessário..."
	$(DO) mkdir -p $(HOME)/dirs/VMs
	$(DO) mkdir -p $(HOME)/dirs/Backups

	@for dir in Desktop Documents Pictures Music Videos Public Software Inbox VMs Backups; do \
		if [ ! -L "$(HOME)/.$$dir" ]; then \
			$(DO) ln -sf "$(HOME)/dirs/$$dir" "$(HOME)/.$$dir"; \
		else \
			echo "🔗 Link simbólico .$$dir já existe. Ignorando."; \
		fi; \
	done

	@if [ ! -L "$(HOME)/Inbox" ]; then \
		$(DO) ln -sf "$(HOME)/dirs/Inbox" "$(HOME)/Inbox"; \
	else \
		echo "🔗 Link simbólico Inbox já existe. Ignorando."; \
	fi

	@echo "📝 Atualizando XDG user-dirs..."
	$(DO) mkdir -p $(HOME)/.config
	$(DO) echo 'XDG_DESKTOP_DIR="$$HOME/dirs/Desktop"'		>  $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_DOWNLOAD_DIR="$$HOME/dirs/Inbox"'	   >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_TEMPLATES_DIR="$$HOME/dirs/Software"'  >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_PUBLICSHARE_DIR="$$HOME/dirs/Public"'  >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_DOCUMENTS_DIR="$$HOME/dirs/Documents"' >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_MUSIC_DIR="$$HOME/dirs/Music"'		   >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_PICTURES_DIR="$$HOME/dirs/Pictures"'   >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_VIDEOS_DIR="$$HOME/dirs/Videos"'	   >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_VMS_DIR="$$HOME/dirs/VMs"'			   >> $(HOME)/.config/user-dirs.dirs
	$(DO) echo 'XDG_BACKUPS_DIR="$$HOME/dirs/Backups"'	   >> $(HOME)/.config/user-dirs.dirs

	$(DO) xdg-user-dirs-update

	@echo "✅ $(if $(filter 1,$(DRYRUN)),Dry run concluído!,Organização concluída!)"

# vim: fdm=indent noet ts=4 sts=4 sw=4
