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
  if app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00) != 0:
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


proc `>>`(app: App) =
    app.renderer.renderPresent()
    discard app.renderer.renderClear()

    if app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00) != 0:
        sdl.logWarn(sdl.LogCategoryVideo,
                "Can't set draw color: %s",
                sdl.getError())


###############################################################################GAME LOOP#########################################################


const
    PADDLE_HEIGHT = 120
    PADDLE_WIDTH = 20

    PADDLE_PLAYER_X = 0
    PADDLE_OPPONENT_X = ScreenW - 20

    MIDDLE_LINE_X = ScreenW div 2
    MIDDLE_LINE_Y = 0
    MIDDLE_LINE_WIDTH = 20
    MIDDLE_LINE_HIGHT = ScreenH

    PADDLE_SPEED_PLAYER = 24
    PADDLE_SPEED_OPPONENT = 6

    RADIUS = 10

    POSSIBLE_INIT_SPEEDS = [-3, 3]

var
    app = App(window: nil, renderer: nil)
    done = false # Main loop exit condition
    pressed: seq[sdl.Keycode] = @[] # Pressed keys
  
    paddlePlayerY = ScreenH div 2
    paddleOpponentY = ScreenH div 2

    paddlePlayer = sdl.Rect(x: PADDLE_PLAYER_X, 
        y: paddlePlayerY, w: PADDLE_WIDTH, h: PADDLE_HEIGHT)
    paddleOpponent = sdl.Rect(x: PADDLE_OPPONENT_X, 
        y: paddleOpponentY, w: PADDLE_WIDTH, h: PADDLE_HEIGHT)
    middleLine = sdl.Rect(x: MIDDLE_LINE_X, y: MIDDLE_LINE_Y, 
        w: MIDDLE_LINE_WIDTH, h: MIDDLE_LINE_HIGHT)
    

    xi = ScreenW div 2
    yi = ScreenH div 2

    xSpeed = POSSIBLE_INIT_SPEEDS.sample()
    ySpeed = POSSIBLE_INIT_SPEEDS.sample()

    opponentPaddleDir = -1


proc `+->`(opX: int) =
    paddleOpponentY += opX * PADDLE_SPEED_OPPONENT

    if paddleOpponentY <= 0 or paddleOpponentY >= ScreenH - PADDLE_HEIGHT:
        opponentPaddleDir *= -1


proc drawMiddleLine(app: App) =
    discard app.renderer.setRenderDrawColor(0x11, 0xCF, 0x0D, 0x0EE)
    
    discard app.renderer.renderFillRect(addr(middleLine))

    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00)


proc drawOpponentPaddle(app: App) = 
    discard app.renderer.setRenderDrawColor(0x11, 0xCF, 0x0D, 0x0EE)
    
    paddleOpponent.y = paddleOpponentY

    discard app.renderer.renderFillRect(addr(paddleOpponent))

    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00)



proc drawPlayerPaddle(app: App) = 
    discard app.renderer.setRenderDrawColor(0x11, 0xCF, 0x0D, 0x0EE)
    
    paddlePlayer.y = paddlePlayerY

    discard app.renderer.renderFillRect(addr(paddlePlayer))

    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00)

proc controlPlayerPaddle() = 
    if K_UP in pressed and paddlePlayerY > 0:
        paddlePlayerY -= PADDLE_SPEED_PLAYER
    
    if K_DOWN in pressed and paddlePlayerY < ScreenH - PADDLE_HEIGHT:
        paddlePlayerY += PADDLE_SPEED_PLAYER


proc drawBall(app: App) = 
    discard app.renderer.setRenderDrawColor(0xFF, 0xFF, 0xFF, 0xFF)

    var x: int = RADIUS - 1
    var y: int = 0

    var tx: int = 1
    var ty: int = 1

    var err = tx - (RADIUS shl 1)

    while x >= y:
      discard app.renderer.renderDrawPoint(xi + x, yi + y)
      discard app.renderer.renderDrawPoint(xi + y, yi + x)
      discard app.renderer.renderDrawPoint(xi - y, yi + x)
      discard app.renderer.renderDrawPoint(xi - x, yi + y)
      discard app.renderer.renderDrawPoint(xi - x, yi - y)
      discard app.renderer.renderDrawPoint(xi - y, yi - x)
      discard app.renderer.renderDrawPoint(xi + y, yi - x)
      discard app.renderer.renderDrawPoint(xi + x, yi - y)

      if err <= 0:
        inc(y)
        err += ty
        ty += 2

      if err > 0:
        dec(x)
        tx += 2
        err += tx + (RADIUS shl 1)

    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0x00)


proc `<->`(xSpeedX, ySpeedX: int) = 
    xi += xSpeedX
    yi += ySpeedX

    if xi <= PADDLE_PLAYER_X + PADDLE_WIDTH and yi >= paddlePlayerY and yi < paddlePlayerY + PADDLE_HEIGHT:
        xSpeed *= -1
        ySpeed *= -1

    if xi >= PADDLE_OPPONENT_X - PADDLE_WIDTH and  yi >= paddleOpponentY and yi < paddleOpponentY + PADDLE_HEIGHT:
        xSpeed *= -1
        ySpeed *= -1

    if yi <= 0 or yi >= ScreenH:
        ySpeed *= -1



proc `?>`(xii, yii: int) = 
    var isOut = false

    if xii <= 0 or xii >= ScreenW:
        delay(2000)
        xi = ScreenW div 2
        yi = ScreenH div 2
        xSpeed = POSSIBLE_INIT_SPEEDS.sample()
        ySpeed = POSSIBLE_INIT_SPEEDS.sample()
        paddlePlayerY = ScreenH div 2
        paddleOpponentY = ScreenH div 2
  


if init(app):
    while not done:

        done = events(pressed)
        
        xSpeed<->ySpeed
        xi?>yi
        +->opponentPaddleDir

        drawBall(app)

        drawMiddleLine(app)

        controlPlayerPaddle()

        drawOpponentPaddle(app)
        drawPlayerPaddle(app)
        
        >>app

# Shutdown
exit(app)