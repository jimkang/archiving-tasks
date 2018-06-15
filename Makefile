include config.mk

HOMEDIR = $(shell pwd)
PROJECTNAME = archiving-tasks
APPDIR = /opt/$(PROJECTNAME)
SSHCMD = ssh $(USER)@$(SERVER)

sync:
	rsync -a $(HOMEDIR) $(USER)@$(SERVER):/opt/ --exclude node_modules/ 
	$(SSHCMD) "cd $(APPDIR) && chmod u+x update-repos.sh"

pushall: sync
	git push origin master

set-up-git-remote-smallcatlabs:
	$(SSHCMD) "cd /mnt/storage/archives/repos/$(REPONAME) && \
	  git init && \
	  git remote add origin ssh://bot@107.170.58.24/opt/repos/$(REPONAME).git"

# Use this to set up a remote repo on the target server
# which can then used to pull to the archiving server.
# In practicality, it's going to be easier to log in to
# that target server and just run each of these steps directly.
set-up-git-on-dir:
	mkdir -p $(GITREMOTEDIR) && \
	  cd $(GITREMOTEDIR) && \
	  git --bare init && \
	  cd $(TARGETDIR) && \
	  git init && \
	  git add . && \
	  git commit -m"Initial commit." && \
	  git remote add origin $(GITREMOTEDIR) && \
	  git push origin master


