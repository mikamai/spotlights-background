class DynamicBackgroud
  CONTAINER_ID  = 'bg'
  DURATION      = 1500           # milliseconds
  LIGHTSIZE     = 0.4            # relative to window width
  OFFSET        = x: 0.4, y: 0.2 # second light offset relative to window dimensions
  LIGHT_IMG     = 'img/light.png'
  BACKROUND_IMG = 'img/bg.jpg'

  constructor: ->
    @win    = $(window)
    @winWidth  = @win.width()
    @winHeight = @win.height()
    @newWidth  = @winWidth
    @newHeight = @winHeight
    @lightSize = @winWidth * LIGHTSIZE
    @duration  = DURATION
    @prepareStage()
    @prepareBg()
    @prepareLights()
    @bindResize()
    @bindMovement()

  prepareBg: ->
    @background = new Kinetic.Layer()
    @stage.add  @background
    image = new Image()
    image.onload = =>
      ratio  = image.width/image.height
      width  = @winWidth
      height = @winWidth/ratio
      img = new Kinetic.Image(
        x: 0
        y: 0
        image:  image
        width:  width
        height: height
      )
      @background.add img
      @stage.draw()
    image.src = BACKROUND_IMG

  prepareLights: ->
    @lights = new Kinetic.Layer()
    @stage.add  @lights
    @buildLight x: 0, y: 0
    @buildLight x: @winWidth*OFFSET.x, y: @winHeight*OFFSET.y

  buildLight: (opts) ->
    image = new Image()
    image.onload = =>
      img = new Kinetic.Image(
        x:      opts.x
        y:      opts.y
        image:  image
        width:  @lightSize
        height: @lightSize
      )
      @lights.add img
      @stage.draw()
    image.src = LIGHT_IMG

  prepareStage: ->
    @stage = new Kinetic.Stage(
      container: CONTAINER_ID
      width:     @winWidth
      height:    @winHeight
    )

  bindResize: ->
    @win.bind 'resize orientationchange', =>
      @newWidth  = @win.width()
      @newHeight = @win.height()
      @stage.setScale @getScale()
      @stage.setWidth @newWidth
      @stage.setHeight @newHeight
      @stage.draw()

  durationInSeconds: -> @duration/1000

  getScale: ->
    scaleX = @newWidth/@winWidth
    scaleY = @newHeight/@winHeight
    if scaleX > scaleY then scaleX else scaleY

  dance: =>
    for shape in @lights.getChildren()
      xPos   = @newWidth * Math.random() - @lightSize/2
      yPos   = @newHeight * Math.random() - @lightSize/2
      width  = @lightSize * (Math.random() + 0.5)
      height = @lightSize * (Math.random() + 0.5)
      new Kinetic.Tween(
        node:     shape
        duration: @durationInSeconds()
        x:        xPos
        y:        yPos
        rotation: Math.random()*1
        width:    width
        height:   height
        easing:   Kinetic.Easings.EaseInOut
      ).play()


  bindMovement: -> setInterval @dance, @duration


$ -> new DynamicBackgroud()
