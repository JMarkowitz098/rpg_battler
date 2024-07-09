# rpg_battler
Live Game: https://jmarkowitz098.github.io/rpg_battler/

## Testing
Documentation: https://gut.readthedocs.io/en/latest/Command-Line.html

1. Must be in project/
2. Set alias with `alias gut='/Applications/Godot.app/Contents/MacOS/Godot -s addons/gut/gut_cmdln.gd'`
2. Run tests with `gut`
```
gut -gselect={file name} Filter by file name. Can use partial text
gut -gunit_test_name={test name} Filter by test name. Can use partial text
```

## Deplotment
Pushing changes to main will trigger deployment to web