<image-editor>
  <img
    class="image" src={createImageUrl()}
    style="filter: saturate({image.filter.saturation}%) contrast({image.filter.contrast}%) brightness({image.filter.brightness}%)
    blur({image.filter.blur}px) grayscale({image.filter.grayscale}%) invert({image.filter.invert}%) opacity({image.filter.opacity}%)
    sepia({image.filter.sepia}%);
    -webkit-filter: saturate({image.filter.saturation}%) contrast({image.filter.contrast}%) brightness({image.filter.brightness}%)
    blur({image.filter.blur}px) grayscale({image.filter.grayscale}%) invert({image.filter.invert}%) opacity({image.filter.opacity}%)
    sepia({image.filter.sepia}%);"
  />

  <div class="menu">
    <div class="content-wrap">
      <form onchange={handler}>
        <label>Brightness</label>
        <input type="range" data-type="brightness" value={image.filter.brightness} min="0" max="300"></input>
        <label>Saturation</label>
        <input type="range" data-type="saturation" value={image.filter.saturation} min="0" max="300"></input>
        <label>Contrast</label>
        <input type="range" data-type="contrast" value={image.filter.contrast} min="0" max="300"></input>
        <label>Blur</label>
        <input type="range" data-type="blur" value={image.filter.blur} min="0" max="10"></input>
        <label>Grayscale</label>
        <input type="range" data-type="grayscale" value={image.filter.grayscale} min="0" max="100"></input>
        <label>Invert</label>
        <input type="range" data-type="invert" value={image.filter.invert} min="0" max="100"></input>
        <label>Opacity</label>
        <input type="range" data-type="opacity" value={image.filter.opacity} min="0" max="100"></input>
        <label>Sepia</label>
        <input type="range" data-type="sepia" value={image.filter.sepia} min="0" max="100"></input>
      </form>
      <button onclick={reset}>Reset</button>
    </div>
  </div>

  <style>
    .image {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto;
    }
    .menu {
      float: right;
      vertical-align: middle;
      text-align: right;
      background-color: #f8f8f8;
      height: 100%;
      width: 150px;
    }
    .content-wrap {
      margin-right: 1em;
      position: relative;
      top: 50%;
      transform: translateY(-50%);
    }
  </style>

  <script>
    this.image = {
      id: 'S5V10IJO9MAS1NJ1',
      filter: filterUndefined()
    };
    const IMAGE_HEIGHT = 400;
    const self = this;

    createImageUrl () {
      return `http:\/\/topix.com/ipicimg/${self.image.id}-rszh${IMAGE_HEIGHT}`;
    }

    handler (event) {
      const value = event.target.value;
      const type = event.target.dataset.type;
      self.image.filter[type] = value;
      self.update();
      console.log(JSON.stringify(self.image));
    }

    function filterUndefined () {
      return {
        brightness: 100,
        saturation: 100,
        contrast: 100,
        blur: 0,
        grayscale: 0,
        invert: 0,
        opacity: 100,
        sepia: 0
      };
    }

    reset () {
      self.image.filter = filterUndefined();
    }

    exportImage () {
      // send image parameters to node-image-pipeline
      // download updated image
    }
  </script>
</image-editor>
