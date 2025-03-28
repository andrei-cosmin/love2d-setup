# Love2D Quick Setup scripts for MacOSX

`build-love.sh` - builds the latest main branch of love2d for macosx and install the artifact into `/Applications` (replaces old artifact)

Builds from: https://github.com/love2d/love
```
# Produces in the current directory the love.app artifact
./build-love.sh
```

Builds from:
- EmmyLua API: https://github.com/EmmyLua/Emmy-love-api
- Love2d-API: https://github.com/love2d-community/love-api
- Lua `crush` dependecy manager for love2d: https://codeberg.org/1414codeforge/crush

`create-project.sh` - creates a new project directory, containing the love2d EmmyLua API, and the lua `crush` dependency manager
```
./create-project.sh -p example

# File tree structure
example
├── .lovedeps
├── crush.lua
├── lib
│   └── love-api
│       ├── love.audio.lua
│       ├── love.data.lua
│       ├── love.event.lua
│       ├── love.filesystem.lua
│       ├── love.font.lua
│       ├── love.graphics.lua
│       ├── love.image.lua
│       ├── love.joystick.lua
│       ├── love.keyboard.lua
│       ├── love.lua
│       ├── love.math.lua
│       ├── love.mouse.lua
│       ├── love.physics.lua
│       ├── love.sound.lua
│       ├── love.system.lua
│       ├── love.thread.lua
│       ├── love.timer.lua
│       ├── love.touch.lua
│       ├── love.video.lua
│       └── love.window.lua
└── src
    └── main.lua
```