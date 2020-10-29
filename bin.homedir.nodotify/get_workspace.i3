i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | cut -d '"' -f 4 | dmenu -p  "→" -i -l 25

