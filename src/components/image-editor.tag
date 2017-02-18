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
    </div>
  </div>

  <div class="crop-container" id="crop-container">
    <img class="preview-image" id="preview-image" onload={dimensions} src="http://topix.com/ipicimg/{id}-{editSpec}"/>
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
    this.id = opts.id;
    this.values = {
      brt: 100,
      sat: 100,
      con: 0
    };
    this.editSpec = 'brt100-sat-100-con0x100';
    this.cb = opts.cb;
    this.showCrop = false;

    this.on('mount', () => {
      $('#crop').draggable({
        containment: "#preview-image",
  	    scroll: false
      });
      $('#crop').resizable();
      self.crop = document.getElementById('crop');
      self.image = document.getElementById('preview-image');
    })

    dimensions (event) {
      self.dimensions = {
        width: event.path[0].naturalWidth,
        height: event.path[0].naturalHeight
      };
      self.dimensions.aspectRatio = self.dimensions.width / self.dimensions.height;
    }

    filter (event) {
      const value = event.target.value;
      const type = event.target.dataset.type;
      self.values[type] = value;
      createEditSpec();
    }

    function createEditSpec () {
      console.log(self.values);
      let cropSpec = '';
      if (self.values.crop) {
        cropSpec = `cp${self.values.crop.x}x${self.values.crop.y}x${self.values.crop.width}x${self.values.crop.height}`;
      }
      self.editSpec = `brt${self.values.brt}-sat${self.values.sat}-con${self.values.con}x${100 - self.values.con}-${cropSpec}`;
      self.update();
    }

    crop (event) {
      if (self.showCrop) {
        self.showCrop = false;
        const cropPos = getPosition(self.crop);
        const imgPos = calculatePreviewSize();

        const scaleX = Math.round(((cropPos.x - imgPos.x) / imgPos.width) * self.dimensions.width);
        const scaleY = Math.round(((cropPos.y - imgPos.y) / imgPos.height) * self.dimensions.height);
        const scaleWidth = Math.round((cropPos.width / imgPos.width) * self.dimensions.width + scaleX);
        const scaleHeight = Math.round((cropPos.height / imgPos.height) * self.dimensions.height + scaleY);

        self.values.crop = {
          x: scaleX,
          y: scaleY,
          width: scaleWidth,
          height: scaleHeight
        };

        createEditSpec();
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
      createEditSpec();
    }

    done () {
      self.cb(self.editSpec);
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
  </script>
</image-editor>
