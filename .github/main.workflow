workflow "New workflow" {
  on = "push"
  resolves = ["cmd"]
}

action "cmd" {
  uses = "cmd"
  runs = "ls -al"
}
