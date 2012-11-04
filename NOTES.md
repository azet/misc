# rubinius system wide install debian /usr/local/bin

	sudo apt-get install ruby-dev libreadline-gplv2-dev zlib1g-dev libssl-dev 

	sudo ./configure --prefix=/opt

	sudo rake install

	PATH+="/opt/rubinius/2.0/bin"

done, use `rbx`.
