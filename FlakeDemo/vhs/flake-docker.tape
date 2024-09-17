Output flake-docker.gif

Set Theme "Catppuccin Latte"

Require nix
Require docker

Set FontSize 24
Set Width 1200
Set Height 600
Set PlaybackSpeed 0.75

Hide
Sleep 2s
Type "gum spin --title 'building...' -- \"
Enter
Show
Type "nix build .#docker"
Enter
Sleep 1s
Hide
Sleep 10s
Show
Type "docker load < ./result"
Hide
Enter
Sleep 1s
Show
Type "docker image ls --filter='reference=flix:1.0.0'"
Enter
Sleep 1s
Type "docker run --rm flix:1.0.0"
Enter
Sleep 3s
