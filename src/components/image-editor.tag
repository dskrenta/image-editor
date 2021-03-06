<image-editor>
  <div class="menu">
    <div class="content-wrap">
      <button onclick={done}>Done</button>
      <form onchange={filter}>
        <label>Brightness</label>
        <input type="range" data-type="brt" value={values.brt} min="100" max="300"></input>
        <label>Saturation</label>
        <input type="range" data-type="sat" value={values.sat} min="100" max="300"></input>
        <label>Contrast</label>
        <input type="range" data-type="con" value={values.con} min="0" max="50"></input>
      </form>
      <button onclick={crop}>Crop</button>
      <button onclick={reset}>Reset</button>
      <p show={values.crop}>{values.crop.width} x {values.crop.height}</p>
    </div>
  </div>

  <div class="crop-container" id="crop-container">
    <img class="preview-image" id="preview-image" onload={dimensions} src="http://proxy.topixcdn.com/ipicimg/{id}-{editSpec}"/>
    <div class="crop" id="crop" show={showCrop}></div>
  </div>

  <style>
    .crop-container {
      width: calc(100vw - 170px);
      height: 100vh;
      display: inline-block;
    }

    .preview-image {
      object-fit: contain;
      object-position: center;
      width: calc(100vw - 170px);
      height: 100vh;
      float: left;
      position: absolute;
      display: block;
    }

    .menu {
      width: 170px;
      height: 100vh;
      float: right;
      vertical-align: middle;
      text-align: right;
      background-color: #f8f8f8;
    }

    .content-wrap {
      margin-right: 1em;
      position: relative;
      top: 50%;
      transform: translateY(-50%);
    }

    .crop {
      position: absolute;
      width: 400px;
      height: 300px;
      border-style: dashed;
      border-color: red;
      top: 20px;
      left: 20px;
    }
  </style>

  <script>
    const self = this;
    const defaultSpec = opts.defaultSpec;
    this.id = opts.id;
    this.values = {
      brt: 100,
      sat: 100,
      con: 0
    };
    this.editSpec = defaultSpec;
    this.cb = opts.cb;
    this.showCrop = false;
    this.finalEditSpec = defaultSpec;
    this.aspectRatio = opts.aspectRatio;

    this.on('mount', () => {
      $('#crop').draggable({
        containment: "#preview-image",
  	    scroll: false
      });
      $('#crop').resizable({
        stop: updateCropSize,
        aspectRatio: self.aspectRatio,
        containment: "#preview-image"
      });
      self.crop = document.getElementById('crop');
      self.image = document.getElementById('preview-image');
      self.image.onload = () => {
        console.log(getImgSizeInfo(self.image));
      };
      /*
      window.onresize = () => {
        console.log('window dimensions changed');
      };
      */
    })

    dimensions (event) {
      self.dimensions = {
        width: event.path[0].naturalWidth,
        height: event.path[0].naturalHeight
      };

      self.cropSize = {
        width: self.dimensions.width,
        height: self.dimensions.height
      };

      self.dimensions.aspectRatio = self.dimensions.width / self.dimensions.height;
    }

    filter (event) {
      const value = event.target.value;
      const type = event.target.dataset.type;
      self.values[type] = value;
      createEditSpec(true);
    }

    function createEditSpec (display) {
      let cropSpec = '';
      if (self.values.crop) {
        cropSpec = `cp${self.values.crop.x}x${self.values.crop.y}x${self.values.crop.width}x${self.values.crop.height}`;
      }
      const spec = `brt${self.values.brt}-sat${self.values.sat}-con${self.values.con}x${100 - self.values.con}-${cropSpec}`;
      self.finalEditSpec = spec;
      if (display) self.editSpec = spec;
      self.update();
    }

    function cropPosition () {
      const cropPos = getPosition(self.crop);
      const imgPos = calculatePreviewSize();

      const scaleX = Math.round(((cropPos.x - imgPos.x) / imgPos.width) * self.dimensions.width);
      const scaleY = Math.round(((cropPos.y - imgPos.y) / imgPos.height) * self.dimensions.height);
      const scaleWidth = Math.round((cropPos.width / imgPos.width) * self.dimensions.width + scaleX);
      const scaleHeight = Math.round((cropPos.height / imgPos.height) * self.dimensions.height + scaleY);

      return {
        x: scaleX,
        y: scaleY,
        width: scaleWidth,
        height: scaleHeight
      };
    }

    function updateCropSize () {
      self.values.crop = cropPosition();
      createEditSpec(false);
      self.update();
    }

    crop (event) {
      if (self.showCrop) {
        self.showCrop = false;
        self.values.crop = cropPosition();
        createEditSpec(true);
      } else {
        self.showCrop = true;
      }
    }

    reset () {
      self.values = {
        brt: 100,
        sat: 100,
        con: 0
      }
      self.editSpec = defaultSpec;
      self.update();
    }

    done () {
      self.cb(self.finalEditSpec);
    }

    function calculatePreviewSize () {
      const largestSize = self.image.clientHeight;
      let resizeWidth = 0;
      let resizeHeight = 0;

      if (self.dimensions.aspectRatio > 1) {
        resizeHeight = largestSize;
        resizeWidth = self.dimensions.aspectRatio * resizeHeight;
      } else {
        resizeWidth = largestSize;
        resizeHeight = resizeWidth / self.dimensions.aspectRatio;
      }

      return {
        width: resizeWidth,
        height: resizeHeight,
        x: (self.image.clientWidth - resizeWidth) / 2,
        y: 0
      };
    }

    function getPosition (element) {
      const rect = element.getBoundingClientRect();
      return {
        x: rect.left,
        y: rect.top,
        width: rect.width,
        height: rect.height
      };
    }

    function getRenderedSize (contains, cWidth, cHeight, width, height, pos) {
      const oRatio = width / height;
      const cRatio = cWidth / cHeight;
      return function () {
        if (contains ? (oRatio > cRatio) : (oRatio < cRatio)) {
        this.width = cWidth;
        this.height = cWidth / oRatio;
      } else {
        this.width = cHeight * oRatio;
        this.height = cHeight;
      }
      this.left = (cWidth - this.width) * (pos / 100);
      this.right = this.width + this.left;
      return this;
    }.call({});
  }

  function getImgSizeInfo(img) {
    var pos = window.getComputedStyle(img).getPropertyValue('object-position').split(' ');
    const style = window.getComputedStyle(img)
    console.log(style.getPropertyValue('width'), style.getPropertyValue('height'), style.getPropertyValue('top'), style.getPropertyValue('left'));
    console.log(pos);
    return getRenderedSize(true, img.width, img.height, img.naturalWidth, img.naturalHeight, parseInt(pos[0]));
  }
  </script>
</image-editor>
