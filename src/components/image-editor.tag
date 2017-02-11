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

  <img class="preview-image" src="http://topix.com/ipicimg/{id}-{editSpec}"/>

  <style>
    /*
    .preview-wrap {
      width: 85vw;
      height: 100vh;
    }
    */

    .menu-wrap {
      width: 15vw;
      height: 100vh;
    }

    .preview-image {
      object-fit: contain;
      object-position: center;
      // width: 80vw;
      width: calc(100vw - 170px);
      height: 100vh;
      float: left;
      position: absolute;
    }

    /*
    .image {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto;
      width: 600px;
    }
    */

    .menu {
      // width: 20vw;
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
  </style>

  <script>
  const self = this;
  this.id = 'S5V10IJO9MAS1NJ1';
  this.values = {
    brt: 100,
    sat: 100,
    con: 0,
    crop: {
      x: 20,
      y: 20,
      width: 500,
      height: 500
    }
  }
  this.editSpec = 'brt100-sat-100-con0x100';
  this.cb = opts.cb;

  filter (event) {
    const value = event.target.value;
    const type = event.target.dataset.type;
    self.values[type] = value;
    createEditSpec();
  }

  function createEditSpec () {
    self.editSpec = `brt${self.values.brt}-sat${self.values.sat}-con${self.values.con}x${100 - self.values.con}`;
    self.update();
  }

  crop () {
    // trigger UI
    // add crop values
  }

  reset () {
    self.values = {
      brt: 100,
      sat: 100,
      con: 0,
      crop: {}
    }
    createEditSpec();
  }

  done () {
    cb(self.editSpec);
  }
  </script>
</image-editor>
