# What is endless bash history?

### pestophagous/endless_bash_history is a twist on Eli Bendersky's original idea

Eli Bendersky is the inventor of this idea. He explains the rationale better
than I can:
http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash

This 'pestophagous' implementation adds two additional columns to every bash
command that gets stored in the history.

Additional columns are:
  * hostname
  * current working directory
  * active git branch (if any)

You'll know every bash command you've ever run. *And* you'll know which
directory you were in when you ran it!

This is a sampling of what it looks like:

```text
2025-12-22 08:03:47 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0/app/qml} {(featurebranch/latest_a)} | grep -ri ping
2025-12-22 08:06:42 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0/app/qml} {(featurebranch/latest_a)} | lapp -d -n
2025-12-22 08:08:56 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0/app/qml} {(featurebranch/latest_a)} | git log --follow -- somefile.qml
2025-12-22 08:10:23 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0/app/qml} {(featurebranch/latest_a)} | git add -p
2025-12-22 08:10:45 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0/app/qml} {(featurebranch/latest_a)} | git commit -m "some commit message"
2025-12-22 08:10:53 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0/app/qml} {(featurebranch/latest_a)} | git push origin featurebranch/latest_a
2025-12-22 08:16:15 host:ModelT34 {/opt/repositories/some_project/repo_LOCAL_0} {(featurebranch/latest_a)} | cdg
2025-12-22 08:16:17 host:ModelT34 {/opt/repositories/some_project/repo} {((HEAD detached at hostlocal/featurebranch/latest_a))} | cd ../repo
2025-12-22 08:16:19 host:ModelT34 {/opt/repositories/some_project/repo} {((HEAD detached at hostlocal/featurebranch/latest_a))} | git status

...
... much more history ...
...

2026-04-24 17:44:12 host:ubuntubox {/home/user/m/jr/2016-04-17} | ls
2026-04-24 17:44:14 host:ubuntubox {/home/user/m/jr/2016-04-17/test_area} | cd test_area/
2026-04-24 17:44:14 host:ubuntubox {/home/user/m/jr/2016-04-17/test_area} | ls
2026-04-24 17:44:17 host:ubuntubox {/home/user/m/jr/2016-04-17/test_area/test-app-1} | cd test-app-1/
2026-04-24 17:44:17 host:ubuntubox {/home/user/m/jr/2016-04-17/test_area/test-app-1} | ls
2026-04-24 17:59:19 host:ubuntubox {/home/user/m/jr/2016-04-17/test_area/test-app-1} | echo $JAVA_HOME
2026-05-02 18:45:38 host:ip-192-168-48-243.ec2.internal {/Users/someone} | /Applications/DiffMerge.app/Extras/diffmerge.sh ~/.bash_history ~/.emacs.d/lisp/doremi.el
2026-05-02 18:48:53 host:ip-192-168-48-243.ec2.internal {/Users/someone/.emacs.d/lisp} | cd .emacs.d/lisp/
2026-05-02 18:49:20 host:ip-192-168-48-243.ec2.internal {/Users/someone/.emacs.d/lisp} | ls .git/hooks/
2026-05-04 10:41:32 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr} | brew install maven
2026-05-04 10:42:04 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr} | brew install redis
2026-05-04 10:44:02 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr} | brew info redis
2026-05-04 10:44:28 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr} | brew info redis > info_redis.txt
2026-05-04 10:44:30 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr} | cat info_redis.txt
2026-05-04 13:22:59 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr/fivefour/circle-api} | mvn jetty:run
2026-05-04 13:24:06 host:ip-192-168-48-243.ec2.internal {/Users/someone/gr/fivefour/circle-api} | (mvn jetty:run 2>&1 ) | tee ~/output.txt

...
... much more history ...
...

2026-10-01 22:54:51 host:qemuguest4 {/home/ubuntu} | echo /home/ubuntu/Qt5.12.0/5.12.0/gcc_64/lib/
2026-10-01 22:55:06 host:qemuguest4 {/home/ubuntu} | export LD_LIBRARY_PATH="/home/ubuntu/Qt5.12.0/5.12.0/gcc_64/lib:$LD_LIBRARY_PATH"
2026-10-01 22:55:09 host:qemuguest4 {/home/ubuntu/thesharewithhost} | cd thesharewithhost/
2026-10-01 22:55:10 host:qemuguest4 {/home/ubuntu/thesharewithhost} | ./bookmark
2026-10-01 22:55:47 host:someone-laptop {/home/someone/MY_QEMU_SHARE_MOUNT} | cp /home/someone/acme/acme/config/data/config.pbtxt acme/config/data/
2026-10-01 22:56:10 host:qemuguest4 {/home/ubuntu/thesharewithhost} | ./mytestapp
2026-10-01 22:56:23 host:someone-laptop {/home/someone/acme} | cdv
2026-10-01 22:56:36 host:someone-laptop {/home/someone/acme} | bazel-bin/acme/executables/apps/mytestapp/mytestapp
```

Knowing the hostname is helpful if you install this history-gathering feature on
multiple hosts.

### Multi-host Caveat

CAVEAT: This project (as of Dec 2025) does not contain any scripts/tools for
merging endless histories of multiple machines. Such scripts/tools exist (in my
private collection), but they are very sloppy and not yet ready for
sharing. You'll have better success rolling your own at this time.

# INSTALL Steps:

```bash
git clone https://github.com/pestophagous/endless_bash_history.git ebh_root
cd ebh_root/
source bin/install.sh
```

At this point, you should find that `$HOME/.persistent_history` exists (in your
home directory).

From now on, you can grep through `$HOME/.persistent_history` any time you need
to remember a bash command you ran. It will be automatically appended to, thanks
to a snippet or two of code added to your `.bashrc` file. (Look at
[this repo's "for_bashrc"](data/for_bashrc) to see what gets added.)

# "Next steps" / Advanced / Proceed-using-your-own-bash-skills

If you want to periodically "push" your endless history, this section contains
one idea to get you started. "Push" could mean that you copy it to an external
drive or a network drive for backup, or that you upload to some cloud storage,
or anything else you want to programmatically make happen.

Suggested starting point:

1. Put `bin/push_endless_bash.sh` on your $PATH (and make sure the `sh` file is
   executable)
2. Create an executable file named `endless_bash_pluggable_push` and put that on
   your path, too

**You must then populate your executable file "endless_bash_pluggable_push" with
  logic that you write.**

Whenever you call `push_endless_bash.sh`, it will gather up all new entries
added to `$HOME/.persistent_history` since your last "push", and it will put
those in a file and then invoke your `endless_bash_pluggable_push` with the
filename as the only argument. **By populating your executable file
"endless_bash_pluggable_push" with custom logic, this is how you can push it to
the cloud or to some other backup medium.**

Look inside `push_endless_bash.sh` for details.
