
LN = ln -fs

all:
	@printf "Valid targets {with a prefix of 'rm' to remove}:\n\n"
	@printf "\tgem\t - gem config file\n"
	@printf "\tgit\t - git config file\n"
	@printf "\tirb\t - irb config file\n"
	@printf "\tmutt\t - all email and news related dotfiles\n"
	@printf "\tmycnf\t - MySQL config file\n"
	@printf "\ttmux\t - tmux config file\n"
	@printf "\tssh\t - ssh config file\n"
	@printf "\tvim\t - Vim and Ex config files\n"
	@printf "\tx11\t - all X related dotfiles (Xresources, spectrwm.conf)\n"
	@printf "\tzshrc\t - ZSH config file\n"

gem:
	${LN} ${PWD}/gemrc ${HOME}/.gemrc
rmgem:
	rm -f ${HOME}/.gemrc

git:
	${LN} ${PWD}/gitconfig ${HOME}/.gitconfig

irb:
	${LN} ${PWD}/irbrc ${HOME}/.irbrc
rmirb:
	rm -f ${HOME}/.irbrc

mutt:
	mkdir -p ${HOME}/.mutt/cache/bodies
	${LN} ${PWD}/mutt/binds ${HOME}/.mutt/binds
	${LN} ${PWD}/mutt/colours ${HOME}/.mutt/colours
	${LN} ${PWD}/mutt/headers ${HOME}/.mutt/headers
	${LN} ${PWD}/mutt/hooks ${HOME}/.mutt/hooks
	${LN} ${PWD}/mutt/imap ${HOME}/.mutt/imap
	${LN} ${PWD}/mutt/mailboxes ${HOME}/.mutt/mailboxes
	${LN} ${PWD}/mutt/mailcap ${HOME}/.mailcap
	${LN} ${PWD}/mutt/mailing_lists ${HOME}/.mutt/mailing_lists
	${LN} ${PWD}/mutt/muttrc ${HOME}/.muttrc
	${LN} ${PWD}/mutt/pgp ${HOME}/.mutt/pgp
	${LN} ${PWD}/mutt/sidebar ${HOME}/.mutt/sidebar
	${LN} ${PWD}/mutt/smtp ${HOME}/.mutt/smtp
	${LN} ${PWD}/mutt/sorting ${HOME}/.mutt/sorting
	chmod -R go-rwx ${HOME}/.mutt

rmmutt:
	rm -rf ${HOME}/.mutt/*
	rm -f ${HOME}/.muttrc

mycnf:
	cp -f my.cnf ${HOME}/.my.cnf

rmmycnf:
	rm -f ${HOME}/.my.cnf

tmux:
	${LN} ${PWD}/tmux.conf ${HOME}/.tmux.conf
	touch ${HOME}/.tmux.local

rmtmux:
	rm -f ${HOME}/.tmux.conf


zshrc:
	mkdir -p ${HOME}/.zsh/func
	${LN} ${PWD}/zshrc ${HOME}/.zshrc
	touch ${HOME}/.zshrc.local

rmzshrc:
	rm -f ${HOME}/.zshrc

vim:
	mkdir -p ${HOME}/.vim/autoload
	git clone git://github.com/tpope/vim-pathogen pathogen
	mv pathogen/autoload ${HOME}/.vim/pathogen
	rm -rf pathogen
	${LN} ${PWD}/vim/exrc ${HOME}/.exrc
	${LN} ${PWD}/vim/vimrc ${HOME}/.vimrc
	mkdir -p ${HOME}/.vim/bundle
	git clone -q --depth 1 git://github.com/tpope/vim-fugitive.git ${HOME}/.vim/bundle/fugitive
	git clone -q --depth 1 git://github.com/ervandew/supertab.git ${HOME}/.vim/bundle/supertab
	git clone -q --depth 1 git://github.com/scrooloose/nerdcommenter.git ${HOME}/.vim/bundle/nerdcommenter
	git clone -q --depth 1 git://github.com/scrooloose/nerdtree.git ${HOME}/.vim/bundle/nerdtree
	git clone -q --depth 1 git://github.com/kien/ctrlp.vim.git ${HOME}/.vim/bundle/ctrlp
	git clone -q --depth 1 git://github.com/altercation/vim-colors-solarized ${HOME}/.vim/bundle/solarized
	git clone -q --depth 1 git://github.com/mv/mv-vim-puppet ${HOME}/.vim/bundle/mv-vim-puppet
	git clone -q --depth 1 git://github.com/vim-syntastic/syntastic ${HOME}/.vim/bundle/syntastic
	git clone -q --depth 1 https://github.com/godlygeek/tabular ${HOME}/.vim/bundle/tabular

rmvim:
	rm -rf ${HOME}/.vim
	rm -f ${HOME}/.vimrc
	rm -f ${HOME}/.exrc

ssh:
	${LN} ${PWD}/ssh.config ${HOME}/.ssh/config

x11:
	${LN} ${PWD}/Xresources ${HOME}/.Xresources
	cp ${PWD}/spectrwm.conf ${HOME}/.spectrwm.conf

rmx11:
	rm -f ${HOME}/.Xresources
	rm -f ${HOME}/.spectrwm.conf

.PHONY: all mutt rmmutt mycnf rmmycnf tmux rmtmux ssh rmssh vim rmvim \
	x11 rmx11 zshrc rmzshrc
