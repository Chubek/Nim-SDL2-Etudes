import
  random,
  sdl2_nim/sdl


const
  Title = "SDL2 App"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or sdl.RendererPresentVsync


type
  App = ref AppObj
  AppObj = object
    window*: sdl.Window # Window pointer
    renderer*: sdl.Renderer # Rendering state pointer


proc init(app: App): bool =
  # Init SDL
  if sdl.init(sdl.InitVideo) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Create window
  app.window = sdl.createWindow(
    Title,
    sdl.WindowPosUndefined,
    sdl.WindowPosUndefined,
    ScreenW,
    ScreenH,
    WindowFlags)
  if app.window == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't create window: %s",
                    sdl.getError())
    return false

  # Create renderer
  app.renderer = sdl.createRenderer(app.window, -1, RendererFlags)
  if app.renderer == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't create renderer: %s",
                    sdl.getError())
    return false

  # Set draw color
  if app.renderer.setRenderDrawColor(0x0D, 0x0E, 0x0F, 0x0C) != 0:
    sdl.logWarn(sdl.LogCategoryVideo,
                "Can't set draw color: %s",
                sdl.getError())
    return false

  sdl.logInfo(sdl.LogCategoryApplication, "SDL initialized successfully")
  randomize()
  return true

# Shutdown sequence
proc exit(app: App) =
  app.renderer.destroyRenderer()
  app.window.destroyWindow()
  sdl.logInfo(sdl.LogCategoryApplication, "SDL shutdown completed")
  sdl.quit()


  # Event handling
# Return true on app shutdown request, otherwise return false
proc events(pressed: var seq[sdl.Keycode]): bool =
  result = false
  var e: sdl.Event
  if pressed.len > 0:
    pressed = @[]

  while sdl.pollEvent(addr(e)) != 0:

    # Quit requested
    if e.kind == sdl.Quit:
      return true

    # Key pressed
    elif e.kind == sdl.KeyDown:
      # Add pressed key to sequence
      pressed.add(e.key.keysym.sym)

      # Exit on Escape key press
      if e.key.keysym.sym == sdl.K_Escape:
        return true




proc drawBorders(app: App) = 
    discard app.renderer.setRenderDrawColor(0x11, 0xCF, 0x0D, 0x0EE)
    
    var rectLeft = sdl.Rect(x: 0, y: 0, w: 20, h: ScreenH)
    var rectRight = sdl.Rect(x: ScreenW - 20, y: 0, w: 20, h: ScreenH)
    var rectTop = sdl.Rect(x: 0, y: 0, w: ScreenW, h: 20)
    var rectBottom = sdl.Rect(x: 0, y: ScreenH - 20, w: ScreenW, h: 20)

    discard app.renderer.renderFillRect(addr(rectLeft))
    discard app.renderer.renderFillRect(addr(rectRight))
    discard app.renderer.renderFillRect(addr(rectTop))
    discard app.renderer.renderFillRect(addr(rectBottom))

var
  app = App(window: nil, renderer: nil)
  done = false # Main loop exit condition
  pressed: seq[sdl.Keycode] = @[] # Pressed keys
  radius = 25
  xc = ScreenH div 2
  yc = ScreenH div 2
  xSpeed = 3
  ySpeed = 3

proc drawCircle(app: App, xi, yi: int, rds: int) = 
    discard app.renderer.setRenderDrawColor(0xFF, 0xFF, 0xFF, 0xFF)

    var x: int32 = rds - 1
    var y: int32 = 0

    var tx: int32 = 1
    var ty: int32 = 1

    var err = tx - (rds shl 1)

    while x >= y:
      discard app.renderer.renderDrawPoint(xi + x, yi - y)
      discard app.renderer.renderDrawPoint(xi + x, yi + y)
      discard app.renderer.renderDrawPoint(xi - x, yi - y)
      discard app.renderer.renderDrawPoint(xi - x, yi + y)
      discard app.renderer.renderDrawPoint(xi + y, yi - x)
      discard app.renderer.renderDrawPoint(xi + y, yi + x)
      discard app.renderer.renderDrawPoint(xi - y, yi - x)
      discard app.renderer.renderDrawPoint(xi - y, yi + x)

      if err <= 0:
        inc(y)
        err += ty
        ty += 2

      if err > 0:
        dec(x)
        tx += 2
        err += tx + rds shl 1

    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00)


proc `<->`(xSpeedX, ySpeedX: int) = 
  xc += xSpeed
  yc += ySpeed

  if (xc <= 20 or xc >= ScreenW - 20):
    xSpeed *= -1

  if yc <= 20 or yc >= ScreenH - 20:
    ySpeed *= -1






proc `++`(rad: int): int = 
  result = rad
  
  if result > 25:
    result = 5

  result += 5



  
    

if init(app):
    while not done:

        drawBorders(app)       

        xSpeed<->ySpeed
          
        drawCircle(app, xc, yc, ++radius)

        done = events(pressed)

        app.renderer.renderPresent()
        discard app.renderer.renderClear()


# Shutdown
exit(app)